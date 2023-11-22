// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let packageName = "Newton"
let productName = "Newton"
let targetName = productName

let package = Package(
    name: packageName,
    platforms: [
        .iOS(.v16)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(name: productName, targets: [targetName]),
    ],
    targets: [
        .target(
        	name: targetName,
        	path: "Newton"
        )
    ]
)
