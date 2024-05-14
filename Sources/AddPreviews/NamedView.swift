// Created 5/7/24

import SwiftUI

public protocol NamedViewCase {
    init?(rawValue: String)
}

/// A model that holds onto a `view`, its `name`, and its associated `case` to enable typesafe switching on the case.
public struct NamedView<Case: NamedViewCase> {
    public let name: String
    public let `case`: Case
    public let view: any View

    /// - Warning: This initializer isn't meant to be used directly - outside of the `@AddPreviews` macro. It will fail if `name` does not match the raw value of a case in `Case`.
    public init?(name: String, view: any View) {
        self.name = name
        self.view = view
        guard let `case` = Case(rawValue: name) else { return nil }
        self.case = `case`
    }
}

extension NamedView: View {
    public var body: some View { AnyView(view) }
}
