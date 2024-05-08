// Created 5/7/24

import SwiftUI

public protocol NamedView {
    var name: String { get }
    var view: any View { get }
}

public struct _ConcreteNamedView {
    public let name: String
    public let view: any View

    public init(name: String, view: any View) {
        self.name = name
        self.view = view
    }
}
