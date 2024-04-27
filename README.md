# AddPreviews

A simple macro that automates the process of creating previews in your `PreviewProvider`s, by deriving its contents from static view properties within the struct.

## Usage

Just `import AddPreviews` and attach `@AddPreviews` to your preview struct.

```swift
import AddPreviews

@AddPreviews
struct MyView_Previews: PreviewProvider {
    static var stateOne: some View { MyView(state: .one) }
    static var stateTwo: some View { MyView(state: .two) }

    // (Generated)
    static var previews: some View {
        stateOne.previewDisplayName("stateOne")
        stateTwo.previewDisplayName("stateTwo")
    }
}
```

## Motivation

It's easy to add a preview state then forget to put it into your previews, and it's no fun to manually write out `previewDisplayName` on every state. 
This macro eliminates both of these pieces of boilerplate.

### Why create specific view properties?
This pattern makes writing [snapshot tests](https://github.com/pointfreeco/swift-snapshot-testing) a breeze!

If you've got dedicated view properties for each state you want to snapshot, your tests become as simple as this:

```swift
final class MyViewTests: XCTestCase {
    func testStateOne() {
        assertSnapshot(of: MyView_Previews.stateOne, as: .image(layout: .device(config: .yourDevice)))
    }
    
    func testStateTwo() {
        assertSnapshot(of: MyView_Previews.stateTwo, as: .image(layout: .device(config: .yourDevice)))
    }
}
```

### What about the `#Preview` macro?
[#Preview](https://developer.apple.com/documentation/swiftui/preview(_:body:)) is nice and concise, but it doesn't support snapshot testing in the way that `PreviewProvider` does, as shown above.

Using `#Preview` generates a struct with a mangled type name like this:
`$s17<YourTarget>33_5594AE1E7369B73F633885FC4E970BA7Ll7PreviewfMf_15PreviewRegistryfMu_`

While it's technically possible to reference this type name (though ill-advised), there's still no `View` that can be extracted out from it that can be plugged into a snapshot test.
[DeveloperToolsSupport](https://developer.apple.com/documentation/developertoolssupport) is currently a black-box in regards to how Xcode turns these previews into views.

## License

This library is released under the MIT license. See [LICENSE](LICENSE) for details.
