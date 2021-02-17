// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LocationPicker",
    platforms: [SupportedPlatform.iOS(.v13)],
    products: [
        .library(
            name: "LocationPicker",
            targets: ["LocationPicker"]
        )
    ],
    targets: [
        .target(
            name: "LocationPicker"
        )
    ]
)
