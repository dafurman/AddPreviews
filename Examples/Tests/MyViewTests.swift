// Created 4/28/24

import XCTest
@testable import Examples

final class MyViewTests: XCTestCase {
    func testPreviews() {
        assertPreviewSnapshots(of: MyView_Previews())
    }
}
