// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TKUIKit",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "TKUIKit",
            targets: ["TKUIKit"]),
        .library(
          name: "TKScreenKit",
          targets: ["TKScreenKit"]
        )
    ],
    dependencies: [
      .package(url: "https://github.com/SnapKit/SnapKit.git", .upToNextMajor(from: "5.0.1"))
    ],
    targets: [
        .target(
            name: "TKUIKit",
            dependencies: [
              .product(name: "SnapKit-Dynamic", package: "SnapKit")
            ],
            path: "TKUIKit/Sources/TKUIKit",
            resources: [.process("Resources/Fonts")]
        ),
        .target(
            name: "TKScreenKit",
            dependencies: [
              .target(name: "TKUIKit")
            ],
            path: "TKUIKit/Sources/TKScreenKit"
        )
    ]
)
