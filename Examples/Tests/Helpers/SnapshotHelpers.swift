// Created 4/28/24

import AddPreviews
import SnapshotTesting
import SwiftUI

// Note: None of this is essential for the example of the macro itself.
// These are just some nice conveniences you can use to make things even easier when paired with SnapshotTesting.

extension Snapshotting where Value: View, Format == UIImage {
    static var standardImage: Snapshotting {
        .image(layout: .device(config: .iPhone13Pro))
    }
}

func assertPreviewSnapshot<Content: View>(
    of view: Content,
    named name: String? = nil,
    file: StaticString = #file,
    testName: String = #function,
    line: UInt = #line
) {
    assertSnapshot(
        of: view,
        as: .standardImage,
        named: name,
        file: file,
        testName: testName,
        line: line
    )
}

func assertPreviewSnapshots<Previews: PreviewProvider & Sequence<NamedView> & IteratorProtocol>(
    of previews: Previews,
    file: StaticString = #file,
    testName: String = #function,
    line: UInt = #line
) {
    for preview in previews {
        assertPreviewSnapshot(
            of: preview,
            named: preview.name,
            file: file,
            testName: testName,
            line: line
        )
    }
}
