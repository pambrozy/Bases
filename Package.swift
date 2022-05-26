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
    targets: [
        .target(name: "Bases"),
        .testTarget(
            name: "BasesTests",
            dependencies: ["Bases"]
        ),
        .executableTarget(
            name: "BasesCLI",
            dependencies: ["Bases"]
        )
    ]
)
