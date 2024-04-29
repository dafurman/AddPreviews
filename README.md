# AddPreviews

![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/Dafurman/AddPreviews/Test_SwiftPM.yml?label=CI&logo=GitHub)
[![codecov](https://codecov.io/gh/dafurman/AddPreviews/graph/badge.svg?token=SLS5308CEO)](https://codecov.io/gh/dafurman/AddPreviews)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fdafurman%2FAddPreviews%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/dafurman/AddPreviews)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fdafurman%2FAddPreviews%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/dafurman/AddPreviews)

`@AddPreviews` makes preview-based [snapshot tests](https://github.com/pointfreeco/swift-snapshot-testing) easier.

When applied to a preview provider it...
1. Automatically creates a `preview` by deriving the view's contents from static view properties within the struct.
2. Makes the preview provider iterable through its view properties, facilitating snapshot coverage of each preview state.

## Usage

### Use in Previews

Just `import AddPreviews` and attach `@AddPreviews` to your preview struct.

```swift
import AddPreviews

@AddPreviews
struct MyView_Previews: PreviewProvider {
    static var stateOne: some View { MyView(state: .one) }
    static var stateTwo: some View { MyView(state: .two) }
}
```

This will generate a `previews` property containing each of your view states, along with display names to easily identify which one you're looking at in Xcode:

```swift
// (Generated)
static var previews: some View {
    stateOne.previewDisplayName("stateOne")
    stateTwo.previewDisplayName("stateTwo")
}
```

### Use in Snapshot Tests

The real magic comes in the boilerplate removal in [snapshot tests](https://github.com/pointfreeco/swift-snapshot-testing).

`@AddPreviews` makes an annotated preview provider iterable over each of its view properties, allowing a snapshot test to be reduced from this:

```swift
import SnapshotTesting
import XCTest

final class MyViewTests: XCTestCase {
    func testStateOne() {
        assertSnapshot(of: MyView_Previews.stateOne, as: .image(layout: .device(config: .yourDevice)))
    }
    
    func testStateTwo() {
        assertSnapshot(of: MyView_Previews.stateTwo, as: .image(layout: .device(config: .yourDevice)))
    }
}
```

To this - code that effortlessly scales with the addition of new preview states:

```swift
import SnapshotTesting
import XCTest

final class MyViewTests: XCTestCase {
    func testPreviews() {
        for preview in MyView_Previews() {
            assertSnapshot(of: preview, as: .image(layout: .device(config: .yourDevice)), named: preview.name)
        }
    }
}
```

All you have to do is rerecord snapshots when making an addition or change, or remove unused reference images when removing a preview state.

## Motivation

### Why create specific view properties? Why not just inline different states in the preview property itself?

This pattern makes writing [snapshot tests](https://github.com/pointfreeco/swift-snapshot-testing) for device-sized views a breeze, as [shown above](#use-in-snapshot-tests)!

That said, this pattern is best-tailored for screen-sized views that should have their own reference images. For smaller views, this approach is overkill, and a preview comprising of multiple states in a stack could just be simply written and snapshotted directly, as shown below:

Preview:
```swift
struct RowView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            RowView(title: "Title")
            RowView(title: "Title", subtitle: "Subtitle")
            RowView(title: "Title", subtitle: "Subtitle") {
                Image(systemSymbol: .envelopeFill)
            }
        }
    }
}
```
Snapshot:
```swift
final class RowViewTests: XCTestCase {
    func testPreviews() {
        assertSnapshot(of: RowView_Previews.previews, as: .image(layout: .device(config: .yourDevice)))
    }
}
```

## What about the `#Preview` macro?
[#Preview](https://developer.apple.com/documentation/swiftui/preview(_:body:)) is nice, concise, and is positioned as the future of Xcode previews, but it doesn't support snapshot testing in the way that `PreviewProvider` does, as shown above.

Using `#Preview` generates a struct with a mangled type name like this:
`$s17<YourTarget>33_5594AE1E7369B73F633885FC4E970BA7Ll7PreviewfMf_15PreviewRegistryfMu_`

While it's technically possible to reference this type name (though ill-advised), there's still no `View` that can be extracted out from it that can be plugged into a snapshot test.
[DeveloperToolsSupport](https://developer.apple.com/documentation/developertoolssupport) is currently a black-box in regards to how Xcode turns these previews into views.

## License

This library is released under the MIT license. See [LICENSE](LICENSE) for details.
