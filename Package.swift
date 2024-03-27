// swift-tools-version: 5.9

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "CoreImageUtils",
    platforms: [.macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .watchOS(.v6), .macCatalyst(.v13)],
    products: [
        .library(
            name: "CoreImageUtils",
            targets: ["CoreImageUtils"]
        ),
        .executable(
            name: "CoreImageUtilsClient",
            targets: ["CoreImageUtilsClient"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-syntax.git", from: "509.0.0"),
    ],
    targets: [
        .macro(
            name: "CoreImageUtilsMacros",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
            ]
        ),
        .target(name: "CoreImageUtils", dependencies: ["CoreImageUtilsMacros"]),
        .executableTarget(name: "CoreImageUtilsClient", dependencies: ["CoreImageUtils"]),
    ]
)
