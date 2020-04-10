// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AXML",
    products: [
        .library(name: "AXML", targets: ["AXML"]),
        .executable(name: "axml-to-xml", targets: ["AXMLCLI"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "0.0.2")
    ],
    targets: [
        .target(
            name: "AXML",
            dependencies: []),
        .testTarget(
            name: "AXMLTests",
            dependencies: ["AXML"]),

        .target(
            name: "AXMLCLI",
            dependencies: [
                "AXML",
                .product(name: "ArgumentParser", package: "swift-argument-parser")
        ])
    ]
)
