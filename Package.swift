// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LiveApp",
    platforms: [.iOS(.v11)], // Xcode cannot build before iOS 11 because their SwiftUI header stubs are broken
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(name: "LiveApp", targets: ["LiveApp"]),
        // cli installer
        .executable(name: "liveappi", targets: ["LiveAppCLIInstaller"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        // todo: move over to the public binary distribution
        .package(name: "SwiftInterpreter", url: "https://github.com/App-Maker-Software/SwiftInterpreter", from: "0.4.6"),
//        .package(name: "SwiftInterpreterSource", url: "https://github.com/App-Maker-Software/SwiftInterpreterSource", .branch("main")), // for private development work
        .package(name: "ExceptionCatcher", url: "https://github.com/sindresorhus/ExceptionCatcher", from: "2.0.0"),
        .package(url: "https://github.com/wickwirew/Runtime.git", from: "2.2.2"),
    ],
    targets: [
        .target(
            name: "LiveApp",
            dependencies: [
                "ExceptionCatcher",
                "Runtime",
                .product(name: "SwiftInterpreter", package: "SwiftInterpreter"),
//                .product(name: "SwiftInterpreterDebugOnly", package: "SwiftInterpreter") // unfortunately, this still isn't working. we must bring the xcframework into production builds even if we aren't using it
            ],
            swiftSettings: [
                .define("INCLUDE_DEVELOPER_TOOLS", .when(configuration: .debug)),
                .define("PRODUCTION", .when(configuration: .release)),
                .define("STUB", .when(configuration: .release))
            ]
        ),
        .target(
            name: "LiveAppCLIInstaller"
        ),
//        // This is for internal development at App Maker Software LLC. If you are interested in joining the team, contact Joe Hinkle
//        .target(
//            name: "LiveApp",
//            dependencies: [
//                "ExceptionCatcher",
//                .product(name: "SwiftInterpreterSource", package: "SwiftInterpreterSource")
//            ],
//            swiftSettings: [
//                .define("INCLUDE_DEVELOPER_TOOLS", .when(configuration: .debug)),
//                .define("INCLUDE_DEVELOPER_LOGGING", .when(configuration: .debug)),
//                .define("PRODUCTION", .when(configuration: .release)),
//                .define("_BUILD_FROM_SOURCE")
//            ]
//        ),
//        // This is for use in App Maker
//        .target(
//            name: "LiveApp",
//            dependencies: [
//                "ExceptionCatcher",
//                .product(name: "SwiftInterpreterPrivate", package: "SwiftInterpreterSource")
//            ],
//            swiftSettings: [
//                .define("INCLUDE_DEVELOPER_TOOLS", .when(configuration: .debug)),
//                .define("INCLUDE_DEVELOPER_LOGGING", .when(configuration: .debug)),
//                .define("PRODUCTION", .when(configuration: .release)),
//                .define("_BUILD_FOR_APP_MAKER")
//            ]
//        ),
//        .testTarget(
//            name: "LiveAppTests",
//            dependencies: ["LiveApp"]),
    ]
)
