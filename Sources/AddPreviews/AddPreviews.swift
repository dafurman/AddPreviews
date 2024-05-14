/// A macro that augments a preview provider to make preview-based [snapshot tests](https://github.com/pointfreeco/swift-snapshot-testing) easier.
/// When applied to a preview provider, `@AddPreviews` does the following...
/// 1. Automatically creates a preview by deriving the view's contents from static view properties within the struct.
/// 2. Makes the preview provider iterable through its view properties, facilitating snapshot coverage of each preview state.
@attached(member, names: named(previews), named(next), named(iterator), named(ViewCase))
@attached(extension, conformances: IteratorProtocol, Sequence)
public macro AddPreviews() = #externalMacro(module: "AddPreviewsMacros", type: "AddPreviews")
