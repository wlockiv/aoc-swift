// swift-tools-version:5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

// if a specific day needs additional dependencies, add them here. For example:
// [6 : [.product(name: "Collections", package: "swift-collections")]]
let dayDependencies: [Int: [Target.Dependency]] = [:]

let dayTargets: [Target] = (1...25).map {
  .target(
    name: "Day\($0)",
    dependencies: [
      .product(name: "Algorithms", package: "swift-algorithms"),
      .product(name: "AdventUtilities", package: "AdventUtilities")
    ] + dayDependencies[$0, default: []],
    swiftSettings: [.unsafeFlags(["-enable-bare-slash-regex"])]
  )
}

let package = Package(
  name: "AdventOfCode",
  platforms: [.macOS(.v13)],
  products: [
    .executable(name: "Main", targets: ["Main"]),
  ],
  dependencies: [
    .package(url: "https://github.com/apple/swift-algorithms", from: "1.0.0"),
    .package(url: "https://github.com/2bjake/AdventUtilities", branch: "main")
  ],
  targets: [
    .executableTarget(
      name: "Main",
      dependencies: (1...25).map { .byName(name: "Day\($0)") }
    ),
  ] + dayTargets
)
