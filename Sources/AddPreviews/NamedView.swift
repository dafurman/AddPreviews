// Created 5/7/24

import SwiftUI

public protocol NamedView: View {
    var name: String { get }
    var view: any View { get }
}

extension NamedView {
    public var body: some View { AnyView(view) }
}

public struct _ConcreteNamedView: NamedView {
    public let name: String
    public let view: any View

    public init(name: String, view: any View) {
        self.name = name
        self.view = view
    }
}
