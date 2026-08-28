import Foundation
import SwiftUI

public enum EventRepeatType: String, Codable, CaseIterable, Sendable {
    case none = "Không lặp lại"
    case daily = "Hàng ngày"
    case weekly = "Hàng tuần"
    case monthlySolar = "Hàng tháng (Dương lịch)"
    case yearlySolar = "Hàng năm (Dương lịch)"
    case yearlyLunar = "Hàng năm (Âm lịch - Giỗ, Tết)"
}

public struct UserEvent: Identifiable, Codable, Hashable, Sendable {
    public let id: UUID
    public var title: String
    public var notes: String
    public var solarDate: Date
    public var isLunarBased: Bool
    public var lunarDay: Int
    public var lunarMonth: Int
    public var repeatType: EventRepeatType
    public var colorHex: String
    public var isAllDay: Bool
    public var hasReminder: Bool
    
    public init(
        id: UUID = UUID(),
        title: String,
        notes: String = "",
        solarDate: Date = Date(),
        isLunarBased: Bool = false,
        lunarDay: Int = 1,
        lunarMonth: Int = 1,
        repeatType: EventRepeatType = .none,
        colorHex: String = "#3B82F6",
        isAllDay: Bool = true,
        hasReminder: Bool = false
    ) {
        self.id = id
        self.title = title
        self.notes = notes
        self.solarDate = solarDate
        self.isLunarBased = isLunarBased
        self.lunarDay = lunarDay
        self.lunarMonth = lunarMonth
        self.repeatType = repeatType
        self.colorHex = colorHex
        self.isAllDay = isAllDay
        self.hasReminder = hasReminder
    }
}
