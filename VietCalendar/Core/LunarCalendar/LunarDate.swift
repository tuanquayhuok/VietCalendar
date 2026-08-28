import Foundation

/// Đại diện cho một ngày Âm Lịch Việt Nam
public struct LunarDate: Codable, Hashable, Sendable {
    public let day: Int            // 1 - 30
    public let month: Int          // 1 - 12
    public let year: Int           // Ví dụ: 2026
    public let isLeapMonth: Bool   // Có phải tháng nhuận hay không
    public let jd: Double          // Julian Day Number
    
    // MARK: - Can Chi & Phong Thủy
    public let canDay: String      // Can ngày: Giáp, Ất, Bính, Đinh, Mậu, Kỷ, Canh, Tân, Nhâm, Quý
    public let chiDay: String      // Chi ngày: Tý, Sửu, Dần, Mão, Thìn, Tỵ, Ngọ, Mùi, Thân, Dậu, Tuất, Hợi
    public let canMonth: String    // Can tháng
    public let chiMonth: String    // Chi tháng
    public let canYear: String     // Can năm
    public let chiYear: String     // Chi năm
    
    public var dayName: String {
        "\(canDay) \(chiDay)"
    }
    
    public var monthName: String {
        "\(canMonth) \(chiMonth)" + (isLeapMonth ? " (Nhuận)" : "")
    }
    
    public var yearName: String {
        "\(canYear) \(chiYear)"
    }
    
    public var formattedShort: String {
        "\(day)/\(month)\(isLeapMonth ? "N" : "")"
    }
    
    public var formattedFull: String {
        "Ngày \(day) tháng \(month)\(isLeapMonth ? " nhuận" : "") năm \(yearName)"
    }

    public init(
        day: Int,
        month: Int,
        year: Int,
        isLeapMonth: Bool,
        jd: Double = 0,
        canDay: String = "",
        chiDay: String = "",
        canMonth: String = "",
        chiMonth: String = "",
        canYear: String = "",
        chiYear: String = ""
    ) {
        self.day = day
        self.month = month
        self.year = year
        self.isLeapMonth = isLeapMonth
        self.jd = jd
        self.canDay = canDay
        self.chiDay = chiDay
        self.canMonth = canMonth
        self.chiMonth = chiMonth
        self.canYear = canYear
        self.chiYear = chiYear
    }
}
