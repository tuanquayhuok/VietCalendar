import Foundation

public final class HolidayService: Sendable {
    public static let shared = HolidayService()
    
    public let holidays: [Holiday]
    
    private init() {
        self.holidays = [
            // MARK: - Ngày Lễ Âm Lịch (Vietnamese Lunar Holidays)
            Holiday(name: "Tết Ông Táo (23 tháng Chạp)", type: .traditional, isLunar: true, day: 23, month: 12, description: "Cúng Táo Quân về trời"),
            Holiday(name: "Tất Niên (30 Tết)", type: .national, isLunar: true, day: 30, month: 12, isDayOff: true, description: "Bữa cơm tất niên gia đình"),
            Holiday(name: "Tết Nguyên Đán (Mùng 1)", type: .national, isLunar: true, day: 1, month: 1, isDayOff: true, description: "Tết Cổ Truyền - Đầu năm mới"),
            Holiday(name: "Tết Nguyên Đán (Mùng 2)", type: .national, isLunar: true, day: 2, month: 1, isDayOff: true, description: "Tết Cổ Truyền - Chúc Tết"),
            Holiday(name: "Tết Nguyên Đán (Mùng 3)", type: .national, isLunar: true, day: 3, month: 1, isDayOff: true, description: "Tết Thầy - Du xuân"),
            Holiday(name: "Tết Thượng Nguyên (Rằm Tháng Giêng)", type: .traditional, isLunar: true, day: 15, month: 1, description: "Lễ hội hoa đăng, cầu an"),
            Holiday(name: "Tết Hàn Thực (3/3)", type: .traditional, isLunar: true, day: 3, month: 3, description: "Bánh trôi, bánh chay"),
            Holiday(name: "Giỗ Tổ Hùng Vương (10/3)", type: .national, isLunar: true, day: 10, month: 3, isDayOff: true, description: "Quốc giỗ Hùng Vương"),
            Holiday(name: "Lễ Phật Đản (Rằm Tháng Tư)", type: .religious, isLunar: true, day: 15, month: 4, description: "Kỷ niệm Đức Phật đản sinh"),
            Holiday(name: "Tết Đoan Ngọ (5/5)", type: .traditional, isLunar: true, day: 5, month: 5, description: "Tết giết sâu bọ"),
            Holiday(name: "Lễ Vu Lan & Xá Tội Vong Nhân (Rằm Tháng 7)", type: .traditional, isLunar: true, day: 15, month: 7, description: "Lễ báo hiếu cha mẹ"),
            Holiday(name: "Tết Trung Thu (Rằm Tháng 8)", type: .traditional, isLunar: true, day: 15, month: 8, description: "Tết trông trăng, rước đèn phá cỗ"),
            Holiday(name: "Tết Trùng Cửu (9/9)", type: .traditional, isLunar: true, day: 9, month: 9, description: "Uống trà hoa cúc, ngắm cảnh"),
            Holiday(name: "Tết Hạ Nguyên (Rằm Tháng 10)", type: .traditional, isLunar: true, day: 15, month: 10, description: "Lễ tạ ơn thần linh"),
            
            // MARK: - Ngày Lễ Dương Lịch (Solar Holidays)
            Holiday(name: "Tết Dương Lịch (Tết Tây)", type: .national, isLunar: false, day: 1, month: 1, isDayOff: true, description: "Ngày đầu năm dương lịch"),
            Holiday(name: "Ngày Thầy Thuốc Việt Nam", type: .international, isLunar: false, day: 27, month: 2, description: "Tôn vinh y bác sĩ"),
            Holiday(name: "Quốc Tế Phụ Nữ", type: .international, isLunar: false, day: 8, month: 3, description: "Chúc mừng phái đẹp"),
            Holiday(name: "Ngày Thành Lập Đoàn TNCS HCM", type: .international, isLunar: false, day: 26, month: 3, description: "Kỷ niệm ngày thành lập Đoàn"),
            Holiday(name: "Giải Phóng Miền Nam (30/4)", type: .national, isLunar: false, day: 30, month: 4, isDayOff: true, description: "Ngày Thống nhất đất nước"),
            Holiday(name: "Quốc Tế Lao Động (1/5)", type: .national, isLunar: false, day: 1, month: 5, isDayOff: true, description: "Ngày lễ của người lao động"),
            Holiday(name: "Quốc Tế Thiếu Nhi (1/6)", type: .international, isLunar: false, day: 1, month: 6, description: "Tết của thiếu nhi"),
            Holiday(name: "Ngày Báo Chí Cách Mạng VN", type: .international, isLunar: false, day: 21, month: 6, description: "Kỷ niệm ngày Báo chí"),
            Holiday(name: "Ngày Thương Binh Liệt Sĩ (27/7)", type: .international, isLunar: false, day: 27, month: 7, description: "Tri ân các anh hùng liệt sĩ"),
            Holiday(name: "Quốc Khánh Nước CHXHCN Việt Nam (2/9)", type: .national, isLunar: false, day: 2, month: 9, isDayOff: true, description: "Kỷ niệm Tuyên ngôn Độc lập"),
            Holiday(name: "Ngày Giải Phóng Thủ Đô", type: .international, isLunar: false, day: 10, month: 10, description: "Kỷ niệm giải phóng Hà Nội"),
            Holiday(name: "Ngày Phụ Nữ Việt Nam (20/10)", type: .international, isLunar: false, day: 20, month: 10, description: "Tôn vinh phụ nữ Việt Nam"),
            Holiday(name: "Ngày Nhà Giáo Việt Nam (20/11)", type: .international, isLunar: false, day: 20, month: 11, description: "Tri ân thầy cô giáo"),
            Holiday(name: "Ngày Quân Đội Nhân Dân VN (22/12)", type: .international, isLunar: false, day: 22, month: 12, description: "Ngày hội Quốc phòng toàn dân"),
            Holiday(name: "Lễ Giáng Sinh (Noel)", type: .religious, isLunar: false, day: 25, month: 12, description: "Mừng Chúa Giáng sinh")
        ]
    }
    
    /// Tìm danh sách ngày lễ cho một ngày cụ thể
    public func getHolidays(solarDay: Int, solarMonth: Int, lunarDay: Int, lunarMonth: Int) -> [Holiday] {
        return holidays.filter { holiday in
            if holiday.isLunar {
                return holiday.day == lunarDay && holiday.month == lunarMonth
            } else {
                return holiday.day == solarDay && holiday.month == solarMonth
            }
        }
    }
}
