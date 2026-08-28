import Foundation

public struct CalendarDay: Identifiable, Hashable, Sendable {
    public var id: String { "\(solarYear)-\(solarMonth)-\(solarDay)" }
    public let date: Date
    public let solarDay: Int
    public let solarMonth: Int
    public let solarYear: Int
    public let lunarDate: LunarDate
    
    public let isCurrentMonth: Bool
    public let isToday: Bool
    public let isWeekend: Bool
    
    public var holidays: [Holiday]
    public var events: [UserEvent]
    public var solarTerm: SolarTerm?
    public var auspiciousHours: [AuspiciousHour]
    
    public var hasHoliday: Bool {
        !holidays.isEmpty
    }
    
    public var hasDayOff: Bool {
        holidays.contains(where: { $0.isDayOff })
    }
    
    public var hasEvent: Bool {
        !events.isEmpty
    }
    
    public var isFirstDayOfLunarMonth: Bool {
        lunarDate.day == 1
    }
    
    public var isFullMoon: Bool {
        lunarDate.day == 15
    }
    
    public init(
        date: Date,
        solarDay: Int,
        solarMonth: Int,
        solarYear: Int,
        lunarDate: LunarDate,
        isCurrentMonth: Bool,
        isToday: Bool,
        isWeekend: Bool,
        holidays: [Holiday] = [],
        events: [UserEvent] = [],
        solarTerm: SolarTerm? = nil,
        auspiciousHours: [AuspiciousHour] = []
    ) {
        self.date = date
        self.solarDay = solarDay
        self.solarMonth = solarMonth
        self.solarYear = solarYear
        self.lunarDate = lunarDate
        self.isCurrentMonth = isCurrentMonth
        self.isToday = isToday
        self.isWeekend = isWeekend
        self.holidays = holidays
        self.events = events
        self.solarTerm = solarTerm
        self.auspiciousHours = auspiciousHours
    }
}
