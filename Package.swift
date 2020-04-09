// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "AXML",
	products: [
		.library(
			name: "AXML",
			targets: ["AXML"])
	],
	targets: [
		.target(
			name: "AXML",
			dependencies: []),
		.testTarget(
			name: "AXMLTests",
			dependencies: ["AXML"])
	]
)
