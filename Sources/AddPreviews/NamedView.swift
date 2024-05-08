// Created 5/7/24

import SwiftUI

public struct NamedView {
    public let name: String
    public let view: any View

    public init(name: String, view: any View) {
        self.name = name
        self.view = view
    }
}
