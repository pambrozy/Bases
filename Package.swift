// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "Bases",
    products: [
        .library(
            name: "Bases",
            targets: ["Bases"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-algorithms", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "Bases",
            dependencies: [
                .product(name: "Algorithms", package: "swift-algorithms")
            ]
        ),
        .testTarget(
            name: "BasesTests",
            dependencies: ["Bases"]
        ),
        .target(
            name: "BasesCLI",
            dependencies: ["Bases"]
        )
    ]
)
