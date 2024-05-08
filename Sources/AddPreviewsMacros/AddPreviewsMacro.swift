import SwiftCompilerPlugin
import SwiftParserDiagnostics
import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxMacros

private let macroName = "AddPreviews"

private struct ViewProperty {
    let isGenericView: Bool
    let identifier: String
}

public struct AddPreviews {}

extension AddPreviews: MemberMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        guard declaration.is(StructDeclSyntax.self) else {
            let node: TokenSyntax? = switch declaration.kind {
            case .actorDecl:
                declaration.as(ActorDeclSyntax.self)?
                    .actorKeyword
            case .classDecl:
                declaration.as(ClassDeclSyntax.self)?
                    .classKeyword
            case .enumDecl:
                declaration.as(EnumDeclSyntax.self)?
                    .enumKeyword
            default:
                nil
            }

            if let node {
                let newNode = TokenSyntax(
                    .identifier("struct"),
                    leadingTrivia: node.leadingTrivia,
                    trailingTrivia: node.trailingTrivia,
                    presence: node.presence
                )
                let diagnostic = Diagnostic(
                    node: Syntax(node),
                    message: InvalidDeclaration(),
                    fixIt: .replace(
                        message: InvalidDeclaration.Fixit(),
                        oldNode: node,
                        newNode: newNode
                    )
                )
                context.diagnose(diagnostic)
                return []
            }
            throw InvalidDeclaration.DeclarationError()
        }

        let viewProperties = declaration.memberBlock.members
            .filter { !$0.isPrivateVariable }
            .compactMap { $0.property }
        guard !viewProperties.isEmpty else {
            return [previewsDeclaration(statements: ["EmptyView()"])]
        }

        let viewIdentifiers = viewProperties.map(\.identifier)
        let viewPropertiesCount = viewProperties.count
        guard viewPropertiesCount <= 15 else {
            throw TooManyPreviewsError(count: viewPropertiesCount)
        }

        let rawMembers = viewIdentifiers
            .map { "\($0).previewDisplayName(\"\($0)\")" }

        return [
            iteratorDeclaration,
            iteratorNextDeclaration(viewProperties: viewProperties),
            previewsDeclaration(statements: rawMembers),
        ]
    }
}

extension AddPreviews: ExtensionMacro {
    public static func expansion(of node: AttributeSyntax, attachedTo declaration: some DeclGroupSyntax, providingExtensionsOf type: some TypeSyntaxProtocol, conformingTo protocols: [TypeSyntax], in context: some MacroExpansionContext) throws -> [ExtensionDeclSyntax] {
        [try ExtensionDeclSyntax("extension \(type.trimmed): Sequence & IteratorProtocol {}")]
    }
}

private func iteratorNextDeclaration(viewProperties: [ViewProperty]) -> DeclSyntax {
    var decl = """
    mutating func next() -> NamedView? {
    defer { iterator += 1 }

    return switch iterator {
    """

    for (count, viewProperty) in viewProperties.enumerated() {
        decl += "case \(count):\n"

        if viewProperty.isGenericView {
            let identifier = viewProperty.identifier
            decl += "\tNamedView(name: \"\(identifier)\", view: Self.\(identifier))"
        } else {
            decl += "Self.\(viewProperty.identifier)"
        }
        decl += "\n"
    }
    decl += """
    default:
        nil
    }
    }
    """
    return DeclSyntax(stringLiteral: decl)
}

private var iteratorDeclaration: DeclSyntax {
    "private var iterator = 0"
}

private func previewsDeclaration(statements: [String]) -> DeclSyntax {
    var string = "static var previews: some View {"
    for statement in statements {
        string += statement + "\n"
    }
    string += "}"
    return DeclSyntax(stringLiteral: string)
}

private extension MemberBlockItemListSyntax.Element {
    var isPrivateVariable: Bool {
        decl.as(VariableDeclSyntax.self)?.modifiers.contains {
            if case .keyword(.private) = $0.as(DeclModifierSyntax.self)?.name.tokenKind {
                true
            } else {
                false
            }
        } == true
    }

    var variableIdentifier: String? {
        decl.as(VariableDeclSyntax.self)?
            .bindings.first { $0.is(PatternBindingSyntax.self) }?
            .pattern.as(IdentifierPatternSyntax.self)?.identifier.trimmedDescription
    }

    var property: ViewProperty? {
        guard let firstPatternBinding = decl.as(VariableDeclSyntax.self)?
            .bindings.first(where: { $0.is(PatternBindingSyntax.self) }),
              let variableIdentifier = firstPatternBinding.pattern.as(IdentifierPatternSyntax.self)?.identifier.trimmedDescription
        else {
            return nil
        }

        let isGenericView = firstPatternBinding.typeAnnotation?.isGenericView ?? false
        return ViewProperty(isGenericView: isGenericView, identifier: variableIdentifier)
    }
}

private extension TypeAnnotationSyntax {
    var isGenericView: Bool {
        guard let someOrAnyTypeSyntax = type.as(SomeOrAnyTypeSyntax.self),
              let name = someOrAnyTypeSyntax.constraint.as(IdentifierTypeSyntax.self)?.name,
              case let .identifier(text) = name.tokenKind 
        else {
            return false
        }
        return text == "View"
    }
}

private struct TooManyPreviewsError: Error, CustomStringConvertible {
    let count: Int

    var description: String { 
        """
        Xcode currently only supports displaying 15 previews at once, and you have \(count).

        Some options are:
            1. If you're previewing a small view, put multiple variants together in a stack, instead of as separate properties, like this:
                ```
                var tabVariants: some View {
                    VStack {
                        MyView(tab: .tab1)
                        MyView(tab: .tab2)
                    }
                }
                ```
            2. Break down your view to be composed of smaller component views with less state, and add your thorough preview coverage on those, instead of the overall view that they're a part of.
        """
    }
}

private struct InvalidDeclaration: ParserError {
    struct Fixit: FixItMessage {
        let message = "Replace with struct"
        let fixItID = MessageID(domain: macroName, id: "invalid-declaration")
    }

    struct DeclarationError: Error, CustomStringConvertible {
        let description = "\(macroName) can only be used on structs"
    }

    let message = DeclarationError().description
}

@main
struct AddPreviewsPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        AddPreviews.self,
    ]
}
