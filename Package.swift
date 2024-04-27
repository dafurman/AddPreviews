// swift-tools-version: 5.9

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "AddPreviews",
    platforms: [
        .macOS(.v10_15), 
        .iOS(.v13), 
        .tvOS(.v13),
        .watchOS(.v6),
        .macCatalyst(.v13)
    ],
    products: [
        .library(
            name: "AddPreviews",
            targets: ["AddPreviews"]
        ),
        .executable(
            name: "AddPreviewsClient",
            targets: ["AddPreviewsClient"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-syntax.git", "509.0.0"..<"511.0.0"),
        .package(url: "https://github.com/pointfreeco/swift-macro-testing", from: "0.4.0"),
    ],
    targets: [
        .macro(
            name: "AddPreviewsMacros",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
            ]
        ),
        .target(name: "AddPreviews", dependencies: ["AddPreviewsMacros"]),
        .executableTarget(name: "AddPreviewsClient", dependencies: ["AddPreviews"]),
        .testTarget(
            name: "AddPreviewsTests",
            dependencies: [
                "AddPreviewsMacros",
                .product(name: "MacroTesting", package: "swift-macro-testing"),
                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
            ]
        ),
    ]
)
