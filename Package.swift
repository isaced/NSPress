import PackageDescription

let package = Package(
    name: "NSPress",
    dependencies: [
        .Package(url: "https://github.com/vapor/vapor.git", majorVersion: 1, minor: 1)
    ],
    exclude: [
        "Config",
        "Public",
        "Resources",
    ]
)

