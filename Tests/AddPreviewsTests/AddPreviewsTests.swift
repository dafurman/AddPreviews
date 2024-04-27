import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest
import MacroTesting
import AddPreviewsMacros

final class AddPreviewsTests: XCTestCase {
    override func invokeTest() {
        withMacroTesting(
            isRecording: false,
            macros: ["AddPreviews": AddPreviews.self]
        ) {
            super.invokeTest()
        }
    }

    func testThoroughExpansion() {
        assertMacro {
            """
            @AddPreviews
            struct MyView_Previews: PreviewProvider {
                static fileprivate var fileprivateView: some View { EmptyView() }
                static var internalView: some View { EmptyView() }
                static internal var explicitlyInternalView: some View { EmptyView() }
                static public var publicView: some View { EmptyView() }
                static let letView = Text("")

                // Demonstrate an intentional lax-ness on the expansion. If you want to have non-view properties, just make them private.
                static var nonViewProperty: Int { 0 }

                // Demonstrate ignored properties
                static private var privateView: some View { EmptyView() }
                static private var privateNonViewProperty: Int { 0 }
                var nonStaticView: some View { EmptyView() }
            }
            """
        } expansion: {
            """
            struct MyView_Previews: PreviewProvider {
                static fileprivate var fileprivateView: some View { EmptyView() }
                static var internalView: some View { EmptyView() }
                static internal var explicitlyInternalView: some View { EmptyView() }
                static public var publicView: some View { EmptyView() }
                static let letView = Text("")

                // Demonstrate an intentional lax-ness on the expansion. If you want to have non-view properties, just make them private.
                static var nonViewProperty: Int { 0 }

                // Demonstrate ignored properties
                static private var privateView: some View { EmptyView() }
                static private var privateNonViewProperty: Int { 0 }
                var nonStaticView: some View { EmptyView() }

                static var previews: some View {
                    fileprivateView.previewDisplayName("fileprivateView")
                    internalView.previewDisplayName("internalView")
                    explicitlyInternalView.previewDisplayName("explicitlyInternalView")
                    publicView.previewDisplayName("publicView")
                    letView.previewDisplayName("letView")
                    nonViewProperty.previewDisplayName("nonViewProperty")
                    nonStaticView.previewDisplayName("nonStaticView")
                }
            }
            """
        }
    }

    // MARK: - View Count Tests

    func testNoViews() {
        assertMacro {
            """
            @AddPreviews
            struct MyView_Previews: PreviewProvider {
            }
            """
        } expansion: {
            """
            struct MyView_Previews: PreviewProvider {

                static var previews: some View {
                    EmptyView()
                }
            }
            """
        }
    }

    func testJustEnoughViews() {
        assertMacro {
            """
            @AddPreviews
            struct MyView_Previews: PreviewProvider {
                var _1: some View { EmptyView() }
                var _2: some View { EmptyView() }
                var _3: some View { EmptyView() }
                var _4: some View { EmptyView() }
                var _5: some View { EmptyView() }
                var _6: some View { EmptyView() }
                var _7: some View { EmptyView() }
                var _8: some View { EmptyView() }
                var _9: some View { EmptyView() }
                var _10: some View { EmptyView() }
                var _11: some View { EmptyView() }
                var _12: some View { EmptyView() }
                var _13: some View { EmptyView() }
                var _14: some View { EmptyView() }
                var _15: some View { EmptyView() }
            }
            """
        } expansion: {
            """
            struct MyView_Previews: PreviewProvider {
                var _1: some View { EmptyView() }
                var _2: some View { EmptyView() }
                var _3: some View { EmptyView() }
                var _4: some View { EmptyView() }
                var _5: some View { EmptyView() }
                var _6: some View { EmptyView() }
                var _7: some View { EmptyView() }
                var _8: some View { EmptyView() }
                var _9: some View { EmptyView() }
                var _10: some View { EmptyView() }
                var _11: some View { EmptyView() }
                var _12: some View { EmptyView() }
                var _13: some View { EmptyView() }
                var _14: some View { EmptyView() }
                var _15: some View { EmptyView() }

                static var previews: some View {
                    _1.previewDisplayName("_1")
                    _2.previewDisplayName("_2")
                    _3.previewDisplayName("_3")
                    _4.previewDisplayName("_4")
                    _5.previewDisplayName("_5")
                    _6.previewDisplayName("_6")
                    _7.previewDisplayName("_7")
                    _8.previewDisplayName("_8")
                    _9.previewDisplayName("_9")
                    _10.previewDisplayName("_10")
                    _11.previewDisplayName("_11")
                    _12.previewDisplayName("_12")
                    _13.previewDisplayName("_13")
                    _14.previewDisplayName("_14")
                    _15.previewDisplayName("_15")
                }
            }
            """
        }
    }

    func testTooManyViews() {
        assertMacro {
            """
            @AddPreviews
            struct MyView_Previews: PreviewProvider {
                var _1: some View { EmptyView() }
                var _2: some View { EmptyView() }
                var _3: some View { EmptyView() }
                var _4: some View { EmptyView() }
                var _5: some View { EmptyView() }
                var _6: some View { EmptyView() }
                var _7: some View { EmptyView() }
                var _8: some View { EmptyView() }
                var _9: some View { EmptyView() }
                var _10: some View { EmptyView() }
                var _11: some View { EmptyView() }
                var _12: some View { EmptyView() }
                var _13: some View { EmptyView() }
                var _14: some View { EmptyView() }
                var _15: some View { EmptyView() }
                var _16: some View { EmptyView() }
            }
            """
        } diagnostics: {
            """
            @AddPreviews
            ┬───────────
            ╰─ 🛑 Xcode currently only supports displaying 15 previews at once, and you have 16.

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
            struct MyView_Previews: PreviewProvider {
                var _1: some View { EmptyView() }
                var _2: some View { EmptyView() }
                var _3: some View { EmptyView() }
                var _4: some View { EmptyView() }
                var _5: some View { EmptyView() }
                var _6: some View { EmptyView() }
                var _7: some View { EmptyView() }
                var _8: some View { EmptyView() }
                var _9: some View { EmptyView() }
                var _10: some View { EmptyView() }
                var _11: some View { EmptyView() }
                var _12: some View { EmptyView() }
                var _13: some View { EmptyView() }
                var _14: some View { EmptyView() }
                var _15: some View { EmptyView() }
                var _16: some View { EmptyView() }
            }
            """
        }
    }

    // MARK: - Invalid Declaration Tests

    func testInvalidDeclaration_actor() {
        assertMacro {
            """
            @AddPreviews
            actor MyView_Previews {
                var myView: some View { EmptyView() }
            }
            """
        } diagnostics: {
            """
            @AddPreviews
            actor MyView_Previews {
            ┬────
            ╰─ 🛑 AddPreviews can only be used on structs
               ✏️ Replace with struct
                var myView: some View { EmptyView() }
            }
            """
        } fixes: {
            """
            @AddPreviews
            struct MyView_Previews {
                var myView: some View { EmptyView() }
            }
            """
        } expansion: {
            """
            struct MyView_Previews {
                var myView: some View { EmptyView() }

                static var previews: some View {
                    myView.previewDisplayName("myView")
                }
            }
            """
        }
    }

    func testInvalidDeclaration_class() {
        assertMacro {
            """
            @AddPreviews
            class MyView_Previews {
                var myView: some View { EmptyView() }
            }
            """
        } diagnostics: {
            """
            @AddPreviews
            class MyView_Previews {
            ┬────
            ╰─ 🛑 AddPreviews can only be used on structs
               ✏️ Replace with struct
                var myView: some View { EmptyView() }
            }
            """
        } fixes: {
            """
            @AddPreviews
            struct MyView_Previews {
                var myView: some View { EmptyView() }
            }
            """
        } expansion: {
            """
            struct MyView_Previews {
                var myView: some View { EmptyView() }

                static var previews: some View {
                    myView.previewDisplayName("myView")
                }
            }
            """
        }
    }

    func testInvalidDeclaration_enum() {
        assertMacro {
            """
            @AddPreviews
            enum MyView_Previews {
                var myView: some View { EmptyView() }
            }
            """
        } diagnostics: {
            """
            @AddPreviews
            enum MyView_Previews {
            ┬───
            ╰─ 🛑 AddPreviews can only be used on structs
               ✏️ Replace with struct
                var myView: some View { EmptyView() }
            }
            """
        } fixes: {
            """
            @AddPreviews
            struct MyView_Previews {
                var myView: some View { EmptyView() }
            }
            """
        } expansion: {
            """
            struct MyView_Previews {
                var myView: some View { EmptyView() }

                static var previews: some View {
                    myView.previewDisplayName("myView")
                }
            }
            """
        }
    }

    func testInvalidDeclaration_other() {
        assertMacro {
            """
            @AddPreviews
            protocol MyView_Previews {
                var myView: some View
            }
            """
        } diagnostics: {
            """
            @AddPreviews
            ┬───────────
            ╰─ 🛑 AddPreviews can only be used on structs
            protocol MyView_Previews {
                var myView: some View
            }
            """
        }
    }

}
