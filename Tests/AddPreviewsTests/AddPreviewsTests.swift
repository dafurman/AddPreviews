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
//            isRecording: true,
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

                private var iterator = 0

                mutating func next() -> NamedView? {
                    defer {
                        iterator += 1
                    }

                    return switch iterator {
                    case 0:
                    	NamedView(name: "fileprivateView", view: Self.fileprivateView)
                    case 1:
                    	NamedView(name: "internalView", view: Self.internalView)
                    case 2:
                    	NamedView(name: "explicitlyInternalView", view: Self.explicitlyInternalView)
                    case 3:
                    	NamedView(name: "publicView", view: Self.publicView)
                    case 4:
                        Self.letView
                    case 5:
                        Self.nonViewProperty
                    case 6:
                    	NamedView(name: "nonStaticView", view: Self.nonStaticView)
                    default:
                        nil
                    }
                }

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

            extension MyView_Previews: Sequence & IteratorProtocol {
            }
            """
        }
    }

    func testTypedViews() {
        assertMacro {
            """
            @AddPreviews
            struct MyView_Previews: PreviewProvider {
                static var view: CustomView { EmptyView() }
                static var someView: some View { EmptyView() }
                static var anyView: any View { EmptyView() }
            }
            """
        } expansion: {
            """
            struct MyView_Previews: PreviewProvider {
                static var view: CustomView { EmptyView() }
                static var someView: some View { EmptyView() }
                static var anyView: any View { EmptyView() }

                private var iterator = 0

                mutating func next() -> NamedView? {
                    defer {
                        iterator += 1
                    }

                    return switch iterator {
                    case 0:
                        Self.view
                    case 1:
                    	NamedView(name: "someView", view: Self.someView)
                    case 2:
                    	NamedView(name: "anyView", view: Self.anyView)
                    default:
                        nil
                    }
                }

                static var previews: some View {
                    view.previewDisplayName("view")
                    someView.previewDisplayName("someView")
                    anyView.previewDisplayName("anyView")
                }
            }

            extension MyView_Previews: Sequence & IteratorProtocol {
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

            extension MyView_Previews: Sequence & IteratorProtocol {
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

                private var iterator = 0

                mutating func next() -> NamedView? {
                    defer {
                        iterator += 1
                    }

                    return switch iterator {
                    case 0:
                    	NamedView(name: "_1", view: Self._1)
                    case 1:
                    	NamedView(name: "_2", view: Self._2)
                    case 2:
                    	NamedView(name: "_3", view: Self._3)
                    case 3:
                    	NamedView(name: "_4", view: Self._4)
                    case 4:
                    	NamedView(name: "_5", view: Self._5)
                    case 5:
                    	NamedView(name: "_6", view: Self._6)
                    case 6:
                    	NamedView(name: "_7", view: Self._7)
                    case 7:
                    	NamedView(name: "_8", view: Self._8)
                    case 8:
                    	NamedView(name: "_9", view: Self._9)
                    case 9:
                    	NamedView(name: "_10", view: Self._10)
                    case 10:
                    	NamedView(name: "_11", view: Self._11)
                    case 11:
                    	NamedView(name: "_12", view: Self._12)
                    case 12:
                    	NamedView(name: "_13", view: Self._13)
                    case 13:
                    	NamedView(name: "_14", view: Self._14)
                    case 14:
                    	NamedView(name: "_15", view: Self._15)
                    default:
                        nil
                    }
                }

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

            extension MyView_Previews: Sequence & IteratorProtocol {
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

                private var iterator = 0

                mutating func next() -> NamedView? {
                    defer {
                        iterator += 1
                    }

                    return switch iterator {
                    case 0:
                    	NamedView(name: "myView", view: Self.myView)
                    default:
                        nil
                    }
                }

                static var previews: some View {
                    myView.previewDisplayName("myView")
                }
            }

            extension MyView_Previews: Sequence & IteratorProtocol {
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

                private var iterator = 0

                mutating func next() -> NamedView? {
                    defer {
                        iterator += 1
                    }

                    return switch iterator {
                    case 0:
                    	NamedView(name: "myView", view: Self.myView)
                    default:
                        nil
                    }
                }

                static var previews: some View {
                    myView.previewDisplayName("myView")
                }
            }

            extension MyView_Previews: Sequence & IteratorProtocol {
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

                private var iterator = 0

                mutating func next() -> NamedView? {
                    defer {
                        iterator += 1
                    }

                    return switch iterator {
                    case 0:
                    	NamedView(name: "myView", view: Self.myView)
                    default:
                        nil
                    }
                }

                static var previews: some View {
                    myView.previewDisplayName("myView")
                }
            }

            extension MyView_Previews: Sequence & IteratorProtocol {
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
