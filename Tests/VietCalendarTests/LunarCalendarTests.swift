import XCTest
@testable import VietCalendarCore

final class LunarCalendarTests: XCTestCase {
    
    func testTetNguyenDan2024() {
        // Mùng 1 Tết Giáp Thìn 2024 là ngày 10/02/2024 Dương Lịch
        let lunar = LunarCalendarConverter.shared.convertSolarToLunar(day: 10, month: 2, year: 2024)
        XCTAssertEqual(lunar.day, 1)
        XCTAssertEqual(lunar.month, 1)
        XCTAssertEqual(lunar.year, 2024)
        XCTAssertEqual(lunar.yearName, "Giáp Thìn")
    }
    
    func testTetNguyenDan2025() {
        // Mùng 1 Tết Ất Tỵ 2025 là ngày 29/01/2025 Dương Lịch
        let lunar = LunarCalendarConverter.shared.convertSolarToLunar(day: 29, month: 1, year: 2025)
        XCTAssertEqual(lunar.day, 1)
        XCTAssertEqual(lunar.month, 1)
        XCTAssertEqual(lunar.year, 2025)
        XCTAssertEqual(lunar.yearName, "Ất Tỵ")
    }
    
    func testTetNguyenDan2026() {
        // Mùng 1 Tết Bính Ngọ 2026 là ngày 17/02/2026 Dương Lịch
        let lunar = LunarCalendarConverter.shared.convertSolarToLunar(day: 17, month: 2, year: 2026)
        XCTAssertEqual(lunar.day, 1)
        XCTAssertEqual(lunar.month, 1)
        XCTAssertEqual(lunar.year, 2026)
        XCTAssertEqual(lunar.yearName, "Bính Ngọ")
    }
    
    func testGioToHungVuong2024() {
        // 10/3 Âm lịch năm 2024 tương ứng 18/04/2024 Dương lịch
        let lunar = LunarCalendarConverter.shared.convertSolarToLunar(day: 18, month: 4, year: 2024)
        XCTAssertEqual(lunar.day, 10)
        XCTAssertEqual(lunar.month, 3)
    }
    
    func testLunarToSolarConversion() {
        // 1/1/2024 Âm lịch -> 10/02/2024 Dương lịch
        let solar = LunarCalendarConverter.shared.convertLunarToSolar(lunarDay: 1, lunarMonth: 1, lunarYear: 2024, isLeap: false)
        XCTAssertNotNil(solar)
        XCTAssertEqual(solar?.day, 10)
        XCTAssertEqual(solar?.month, 2)
        XCTAssertEqual(solar?.year, 2024)
    }
    
    func testSolarTerms() {
        // 20/03/2024 thường là ngày Xuân Phân
        let term = SolarTermCalculator.shared.getSolarTerm(day: 20, month: 3, year: 2024)
        XCTAssertNotNil(term)
        XCTAssertEqual(term?.name, "Xuân Phân")
    }
}
