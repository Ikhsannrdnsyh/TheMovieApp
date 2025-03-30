// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Detail",
    
    platforms: [.iOS(.v18), .macOS(.v15)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Detail",
            targets: ["Detail"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.2.0")),
        .package(url: "https://github.com/Ikhsannrdnsyh/TheMovieApp-Core.git", .upToNextMajor(from: "1.0.0")),
        .package(path: "../Category"),
        .package(path: "../Favorites")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Detail",
            dependencies: [
                "Category",
                "Alamofire",
                "Favorites",
                .product(name: "Core", package: "TheMovieApp-Core")
            ]),
        .testTarget(
            name: "DetailTests",
            dependencies: ["Detail"]
        ),
    ]
)
