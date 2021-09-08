// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "HRSCustomErrorHandling",
	platforms: [
		.macOS(.v10_11),
		.iOS(.v9),
        .tvOS(.v9),
		.watchOS(.v3)
	],
	products: [
		.library(
			name: "HRSCustomErrorHandling",
			targets: ["HRSCustomErrorHandling"])
	],
	targets: [
		.target(
			name: "HRSCustomErrorHandling",
			dependencies: [],
			path: "Pod/Classes/",
            sources: ["Public", "Private"],
            publicHeadersPath: "Public/",
			cSettings: [
                .headerSearchPath("Public/"),
                .headerSearchPath("Private/")
			]
		)
	]
)
