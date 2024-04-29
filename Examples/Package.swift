// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "Examples",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
        .tvOS(.v13),
        .watchOS(.v6),
        .macCatalyst(.v13)
    ],
    products: [
        .library(
            name: "Examples",
            targets: ["Examples"]
        ),
    ],
    dependencies: [
        .package(name: "AddPreviews", path: "../"),
        .package(url: "https://github.com/pointfreeco/swift-snapshot-testing", from: "1.16.0"),
    ],
    targets: [
        .target(
            name: "Examples",
            dependencies: [
                .product(name: "AddPreviews", package: "AddPreviews"),
            ],
            path: "Sources"
        ),
        .testTarget(
            name: "ExamplesTests",
            dependencies: [
                "Examples",
                .product(name: "SnapshotTesting", package: "swift-snapshot-testing")
            ],
            path: "Tests"
        ),
    ]
)
