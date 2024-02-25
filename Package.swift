// swift-tools-version: 5.8

// WARNING:
// This file is automatically generated.
// Do not edit it by hand because the contents will be replaced.

import PackageDescription
import AppleProductTypes

let package = Package(
    name: "wwdc",
    platforms: [
        .iOS("16.0")
    ],
    products: [
        .iOSApplication(
            name: "wwdc",
            targets: ["AppModule"],
            bundleIdentifier: "rafachinelatto.wwdc",
            teamIdentifier: "J3D6H27WWS",
            displayVersion: "1.0",
            bundleVersion: "1",
            appIcon: .placeholder(icon: .flower),
            accentColor: .presetColor(.purple),
            supportedDeviceFamilies: [
                .pad,
                .phone
            ],
            supportedInterfaceOrientations: [
                .portrait,
                .landscapeRight,
                .landscapeLeft,
                .portraitUpsideDown(.when(deviceFamilies: [.pad]))
            ],
            capabilities: [
                .camera(purposeString: "A camera é usada para tirar uma foto que será usada no app, essa foto não é salva em nenhum lugar.")
            ]
        )
    ],
    dependencies: [
        .package(path: "../LaTeXSwiftUI")
    ],
    targets: [
        .executableTarget(
            name: "AppModule",
            dependencies: [
                .product(name: "LaTeXSwiftUI", package: "latexswiftui")
            ],
            path: "."
        )
    ]
)