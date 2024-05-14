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

    /// - Warning: This initializer is not safe to be invoked manually - it's just meant for use directly within `@AddPreviews`. If you must invoke this manually, ensure that `name` matches a case within `Case`.
    public init(name: String, view: any View) {
        self.name = name
        self.view = view
        self.case = Case(rawValue: name)!
    }
}

extension NamedView: View {
    public var body: some View { AnyView(view) }
}
