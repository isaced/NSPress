import PackageDescription

let package = Package(
    name: "NSPress",
    dependencies: [
        .Package(url: "https://github.com/vapor/vapor.git", majorVersion: 1),
        .Package(url: "https://github.com/vapor/sqlite-provider.git", majorVersion: 1)
//        .Package(url: "https://github.com/vapor/mysql-provider.git", majorVersion: 1)
    ],
    exclude: [
        "Config",
        "Public",
        "Resources",
    ]
)

