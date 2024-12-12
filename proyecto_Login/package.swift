//
//  package.swift
//  proyecto_Login
//
//  Created by Victor Tejeda on 11/12/24.
//

// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "ProfessionalGoogleFormCreator",
    platforms: [
        .iOS(.v15)
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.6.1")),
        .package(url: "https://github.com/SwiftyJSON/SwiftyJSON.git", .upToNextMajor(from: "5.0.1")),
        .package(url: "https://github.com/onevcat/Kingfisher.git", .upToNextMajor(from: "7.0.0"))
    ],
    targets: [
        .target(
            name: "ProfessionalGoogleFormCreator",
            dependencies: ["Alamofire", "SwiftyJSON", "Kingfisher"]
        )
    ]
)


