// Created 4/28/24

import SwiftUI

public struct NamedView: View {
    public let name: String
    public let view: any View

    public init(name: String, view: any View) {
        self.name = name
        self.view = view
    }

    public var body: some View {
        AnyView(view)
    }
}
