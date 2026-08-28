import Foundation

/// 24 Tiết Khí trong năm theo vị trí Mặt Trời trên Hoàng Đạo
public struct SolarTerm: Identifiable, Codable, Hashable, Sendable {
    public var id: String { name }
    public let name: String            // Tên tiết khí (VD: Xuân Phân, Lập Xuân...)
    public let degree: Int             // Kinh độ Mặt Trời (0°, 15°, ..., 345°)
    public let description: String     // Ý nghĩa dân gian
}

public final class SolarTermCalculator {
    public static let shared = SolarTermCalculator()
    
    public static let allTerms: [SolarTerm] = [
        SolarTerm(name: "Xuân Phân", degree: 0, description: "Giữa mùa xuân, ngày đêm dài bằng nhau"),
        SolarTerm(name: "Thanh Minh", degree: 15, description: "Trời trong sáng, tảo mộ tổ tiên"),
        SolarTerm(name: "Cốc Vũ", degree: 30, description: "Mưa rào cho mùa màng"),
        SolarTerm(name: "Lập Hạ", degree: 45, description: "Bắt đầu mùa hè"),
        SolarTerm(name: "Tiểu Mãn", degree: 60, description: "Hạt đơm bông nhỏ"),
        SolarTerm(name: "Mang Chủng", degree: 75, description: "Gieo trồng các loại ngũ cốc có râu"),
        SolarTerm(name: "Hạ Chí", degree: 90, description: "Giữa mùa hè, ngày dài nhất trong năm"),
        SolarTerm(name: "Tiểu Thử", degree: 105, description: "Nóng nhẹ"),
        SolarTerm(name: "Đại Thử", degree: 120, description: "Nóng oi bức nhất"),
        SolarTerm(name: "Lập Thu", degree: 135, description: "Bắt đầu mùa thu"),
        SolarTerm(name: "Xử Thử", degree: 150, description: "Mưa giảm nhiệt mùa hè"),
        SolarTerm(name: "Bạch Lộ", degree: 165, description: "Sương sớm màu trắng"),
        SolarTerm(name: "Thu Phân", degree: 180, description: "Giữa mùa thu, ngày đêm dài bằng nhau"),
        SolarTerm(name: "Hàn Lộ", degree: 195, description: "Sương lạnh bắt đầu xuất hiện"),
        SolarTerm(name: "Sương Giáng", degree: 210, description: "Sương mù rơi nhiều"),
        SolarTerm(name: "Lập Đông", degree: 225, description: "Bắt đầu mùa đông"),
        SolarTerm(name: "Tiểu Tuyết", degree: 240, description: "Tuyết nhẹ (vùng cao / khí hậu hậu á nhiệt)"),
        SolarTerm(name: "Đại Tuyết", degree: 255, description: "Rét đậm mùa đông"),
        SolarTerm(name: "Đông Chí", degree: 270, description: "Giữa mùa đông, đêm dài nhất trong năm"),
        SolarTerm(name: "Tiểu Hàn", degree: 285, description: "Rét nhẹ"),
        SolarTerm(name: "Đại Hàn", degree: 300, description: "Rét buốt khắc nghiệt"),
        SolarTerm(name: "Lập Xuân", degree: 315, description: "Bắt đầu một mùa xuân mới"),
        SolarTerm(name: "Vũ Thủy", degree: 330, description: "Mưa ẩm ướt đầu xuân"),
        SolarTerm(name: "Kinh Trập", degree: 345, description: "Sấm đầu mùa xuân, sâu bọ thức giấc")
    ]
    
    private init() {}
    
    /// Xác định Tiết Khí tại một ngày dương lịch
    public func getSolarTerm(day: Int, month: Int, year: Int) -> SolarTerm? {
        let jd = LunarCalendarConverter.shared.jdFromDate(day: day, month: month, year: year)
        let sunLong = LunarCalendarConverter.shared.getSunLongitude(dayNumber: jd, timeZone: 7.0)
        let degrees = sunLong * 180.0 / Double.pi
        
        let index = Int(floor(degrees / 15.0)) % 24
        guard index >= 0 && index < Self.allTerms.count else { return nil }
        return Self.allTerms[index]
    }
}
