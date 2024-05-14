// Created 5/7/24

import SwiftUI

public protocol NamedViewCase {
    var rawValue: String { get }

    init?(rawValue: String)
}

/// A model that holds onto a `view`, its `name`, and its associated `case` to enable typesafe switching on the case.
public struct NamedView<Case: NamedViewCase> {
    public let `case`: Case
    public let view: any View
    public var name: String { `case`.rawValue }

    public init(case: Case, view: any View) {
        self.case = `case`
        self.view = view
    }
}

extension NamedView: View {
    public var body: some View { AnyView(view) }
}
