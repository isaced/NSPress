import PackageDescription

let package = Package(
    name: "NSPress",
    dependencies: [
        .Package(url: "https://github.com/vapor/vapor.git", majorVersion: 2),
        .Package(url: "https://github.com/vapor/fluent-provider.git", majorVersion: 1),
        .Package(url: "https://github.com/vapor/auth-provider.git", majorVersion: 1),
        .Package(url: "https://github.com/vapor/leaf-provider.git", majorVersion: 1)
    ],
    exclude: [
        "Config",
        "Public",
        "Resources",
    ]
)

