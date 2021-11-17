// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "EUDCCKit",
    platforms: [
        .iOS(.v10),
        .tvOS(.v12),
        .watchOS(.v5),
        .macOS(.v10_15)
    ],
    products: [
        .library(
            name: "EUDCC",
            targets: [
                "EUDCC"
            ]
        ),
        .library(
            name: "EUDCCDecoder",
            targets: [
                "EUDCCDecoder"
            ]
        ),
        .library(
            name: "EUDCCVerifier",
            targets: [
                "EUDCCVerifier"
            ]
        ),
        .library(
            name: "EUDCCValidator",
            targets: [
                "EUDCCValidator"
            ]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/unrelentingtech/SwiftCBOR.git",
            .exact("0.4.3")
        )
    ],
    targets: [
        .target(
            name: "EUDCC"
        ),
        .target(
            name: "EUDCCDecoder",
            dependencies: [
                "EUDCC",
                "SwiftCBOR"
            ]
        ),
        .target(
            name: "EUDCCVerifier",
            dependencies: [
                "EUDCC",
                "SwiftCBOR"
            ]
        ),
        .target(
            name: "EUDCCValidator",
            dependencies: [
                "EUDCC"
            ]
        ),
        .target(
            name: "EUDCCKitTests",
            dependencies: [
                "EUDCC",
                "EUDCCDecoder",
                "EUDCCValidator",
                "EUDCCVerifier"
            ],
            path: "Tests/_EUDCCKitTests"
        ),
        .testTarget(
            name: "EUDCCTests",
            dependencies: [
                "EUDCCKitTests"
            ]
        ),
        .testTarget(
            name: "EUDCCDecoderTests",
            dependencies: [
                "EUDCCKitTests"
            ]
        ),
        .testTarget(
            name: "EUDCCVerifierTests",
            dependencies: [
                "EUDCCKitTests"
            ]
        ),
        .testTarget(
            name: "EUDCCValidatorTests",
            dependencies: [
                "EUDCCKitTests"
            ]
        )
    ]
)
