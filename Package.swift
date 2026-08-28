// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "VietCalendar",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "VietCalendarCore",
            targets: ["VietCalendarCore"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "VietCalendarCore",
            dependencies: [],
            path: "VietCalendar"
        ),
        .testTarget(
            name: "VietCalendarTests",
            dependencies: ["VietCalendarCore"],
            path: "Tests"
        )
    ]
)
