import Foundation

/// Giờ Hoàng Đạo / Hắc Đạo trong ngày theo dân gian Việt Nam
public struct AuspiciousHour: Identifiable, Hashable, Sendable {
    public var id: String { name }
    public let name: String           // Tý, Sửu, Dần...
    public let timeRange: String      // 23h - 01h, 01h - 03h...
    public let isAuspicious: Bool     // true: Hoàng Đạo, false: Hắc Đạo
    public let starName: String       // Tên sao: Thanh Long, Minh Đường, v.v.
}

public final class AuspiciousHourCalculator {
    public static let shared = AuspiciousHourCalculator()
    
    private let hours = [
        ("Tý", "23:00 - 01:00"),
        ("Sửu", "01:00 - 03:00"),
        ("Dần", "03:00 - 05:00"),
        ("Mão", "05:00 - 07:00"),
        ("Thìn", "07:00 - 09:00"),
        ("Tỵ", "09:00 - 11:00"),
        ("Ngọ", "11:00 - 13:00"),
        ("Mùi", "13:00 - 15:00"),
        ("Thân", "15:00 - 17:00"),
        ("Dậu", "17:00 - 19:00"),
        ("Tuất", "19:00 - 21:00"),
        ("Hợi", "21:00 - 23:00")
    ]
    
    private init() {}
    
    /// Tính danh sách 12 giờ và phân định Hoàng Đạo / Hắc Đạo theo Chi của ngày
    public func getHoursOfDay(chiDay: String) -> [AuspiciousHour] {
        let auspiciousIndices: [Int]
        
        switch chiDay {
        case "Tý", "Ngọ":
            auspiciousIndices = [0, 1, 3, 6, 8, 9] // Tý, Sửu, Mão, Ngọ, Thân, Dậu
        case "Sửu", "Mùi":
            auspiciousIndices = [2, 3, 5, 8, 10, 11] // Dần, Mão, Tỵ, Thân, Tuất, Hợi
        case "Dần", "Thân":
            auspiciousIndices = [0, 1, 4, 5, 7, 10] // Tý, Sửu, Thìn, Tỵ, Mùi, Tuất
        case "Mão", "Dậu":
            auspiciousIndices = [0, 2, 3, 6, 7, 9] // Tý, Dần, Mão, Ngọ, Mùi, Dậu
        case "Thìn", "Tuất":
            auspiciousIndices = [2, 4, 5, 8, 9, 11] // Dần, Thìn, Tỵ, Thân, Dậu, Hợi
        case "Tỵ", "Hợi":
            auspiciousIndices = [1, 4, 6, 7, 10, 11] // Sửu, Thìn, Ngọ, Mùi, Tuất, Hợi
        default:
            auspiciousIndices = [0, 1, 4, 5, 7, 10]
        }
        
        return hours.enumerated().map { index, item in
            let isAuspicious = auspiciousIndices.contains(index)
            let star = isAuspicious ? "Hoàng Đạo (Tốt)" : "Hắc Đạo"
            return AuspiciousHour(
                name: "Giờ \(item.0)",
                timeRange: item.1,
                isAuspicious: isAuspicious,
                starName: star
            )
        }
    }
}
