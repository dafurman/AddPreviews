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
        XCTAssertTrue(NamedView<ViewCase>(name: ViewCase.one.rawValue, view: Text("")).view is Text)
        XCTAssertTrue(NamedView<ViewCase>(name: ViewCase.one.rawValue, view: someView).view is Text)
        XCTAssertTrue(NamedView<ViewCase>(name: ViewCase.one.rawValue, view: AnyView(someView)).view is AnyView)
    }

    func testCaseSwitching() {
        XCTAssertEqual(NamedView<ViewCase>(name: ViewCase.one.rawValue, view: EmptyView()).case, .one)
        XCTAssertEqual(NamedView<ViewCase>(name: ViewCase.two.rawValue, view: EmptyView()).case, .two)
    }
}
