// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TKUIKit",
    products: [
        .library(
            name: "TKUIKit",
            targets: ["TKUIKit"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "TKUIKit",
            dependencies: [])
    ]
)
