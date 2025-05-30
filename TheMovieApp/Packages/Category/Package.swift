// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Category",
    
    platforms: [.iOS(.v18), .macOS(.v15)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Category",
            targets: ["Category"]),
    ],
    
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.2.0")),
        .package(url: "https://github.com/Ikhsannrdnsyh/TheMovieApp-Core.git", .upToNextMajor(from: "1.0.0")),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Category",
            dependencies: [
                "Alamofire",
                .product(name: "Core", package: "TheMovieApp-Core")
                
            ]),
        .testTarget(
            name: "CategoryTests",
            dependencies: ["Category"]
        ),
    ]
)
