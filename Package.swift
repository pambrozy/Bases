// swift-tools-version: 5.6

//
//  Package.swift
//  Bases
//
//  Created by Przemek Ambroży on 12.06.2022.
//  Copyright © 2022 Przemysław Ambroży
//

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
        .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0")
    ],
    targets: [
        .target(name: "Bases"),
        .testTarget(
            name: "BasesTests",
            dependencies: ["Bases"]
        )
    ]
)
