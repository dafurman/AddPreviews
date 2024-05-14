// Created 5/13/24

@testable import AddPreviews
import SwiftUI
import XCTest

final class NamedViewTests: XCTestCase {
    private enum ViewCase: String, NamedViewCase {
        case one
        case two
    }

    func testViewCasting() {
        var someView: some View { Text("") }
        XCTAssertTrue(NamedView<ViewCase>(case: .one, view: Text("")).view is Text)
        XCTAssertTrue(NamedView<ViewCase>(case: .one, view: someView).view is Text)
        XCTAssertTrue(NamedView<ViewCase>(case: .one, view: AnyView(someView)).view is AnyView)
    }

    func testCaseSwitching() {
        XCTAssertEqual(NamedView<ViewCase>(case: .one, view: EmptyView()).case, .one)
        XCTAssertEqual(NamedView<ViewCase>(case: .two, view: EmptyView()).case, .two)
    }

    func testBodyIsTypeErasedView() {
        XCTAssertTrue(NamedView<ViewCase>(case: .one, view: EmptyView()).body is AnyView)
    }

    func testNameIsCaseRawValue() {
        XCTAssertEqual(NamedView<ViewCase>(case: .one, view: EmptyView()).name, "one")
        XCTAssertEqual(NamedView<ViewCase>(case: .two, view: EmptyView()).name, "two")
    }
}
