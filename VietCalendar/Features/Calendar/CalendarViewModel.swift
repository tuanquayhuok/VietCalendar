import Foundation
import Combine
import SwiftUI

@MainActor
public final class CalendarViewModel: ObservableObject {
    @Published public var currentDate: Date = Date()
    @Published public var selectedDate: Date = Date()
    @Published public var daysInMonth: [CalendarDay] = []
    @Published public var selectedDayDetails: CalendarDay?
    @Published public var selectedYear: Int = Calendar.current.component(.year, from: Date())
    
    private var cancellables = Set<AnyCancellable>()
    private let calendar = Calendar.current
    private let lunarConverter = LunarCalendarConverter.shared
    private let solarTermCalculator = SolarTermCalculator.shared
    private let holidayService = HolidayService.shared
    private let eventService = EventService.shared
    
    public init() {
        generateMonthGrid(for: currentDate)
        selectToday()
        
        // Lắng nghe thay đổi từ EventService để refresh giao diện
        eventService.$events
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.generateMonthGrid(for: self.currentDate)
                self.updateSelectedDayDetails()
            }
            .store(in: &cancellables)
    }
    
    public func selectToday() {
        let today = Date()
        self.currentDate = today
        self.selectedDate = today
        self.selectedYear = calendar.component(.year, from: today)
        generateMonthGrid(for: today)
        updateSelectedDayDetails()
    }
    
    public func nextMonth() {
        currentDate = currentDate.addingMonth(1)
        selectedYear = calendar.component(.year, from: currentDate)
        generateMonthGrid(for: currentDate)
    }
    
    public func previousMonth() {
        currentDate = currentDate.addingMonth(-1)
        selectedYear = calendar.component(.year, from: currentDate)
        generateMonthGrid(for: currentDate)
    }
    
    public func jumpToMonth(month: Int, year: Int) {
        var comp = DateComponents()
        comp.year = year
        comp.month = month
        comp.day = 1
        if let newDate = calendar.date(from: comp) {
            currentDate = newDate
            selectedDate = newDate
            selectedYear = year
            generateMonthGrid(for: newDate)
            updateSelectedDayDetails()
        }
    }
    
    public func generateDays() {
        generateMonthGrid(for: currentDate)
        updateSelectedDayDetails()
    }
    
    public func selectDay(_ day: CalendarDay) {
        self.selectedDate = day.date
        self.selectedDayDetails = day
        self.selectedYear = calendar.component(.year, from: day.date)
    }
    
    private func updateSelectedDayDetails() {
        let comp = calendar.dateComponents([.day, .month, .year], from: selectedDate)
        guard let d = comp.day, let m = comp.month, let y = comp.year else { return }
        
        let lunar = lunarConverter.convertSolarToLunar(day: d, month: m, year: y)
        let holidays = holidayService.getHolidays(solarDay: d, solarMonth: m, lunarDay: lunar.day, lunarMonth: lunar.month)
        let events = eventService.eventsForDay(solarDay: d, solarMonth: m, solarYear: y, lunarDay: lunar.day, lunarMonth: lunar.month, date: selectedDate)
        let solarTerm = solarTermCalculator.getSolarTerm(day: d, month: m, year: y)
        let hours = AuspiciousHourCalculator.shared.getHoursOfDay(chiDay: lunar.chiDay)
        
        self.selectedDayDetails = CalendarDay(
            date: selectedDate,
            solarDay: d,
            solarMonth: m,
            solarYear: y,
            lunarDate: lunar,
            isCurrentMonth: true,
            isToday: calendar.isDateInToday(selectedDate),
            isWeekend: calendar.isDateInWeekend(selectedDate),
            holidays: holidays,
            events: events,
            solarTerm: solarTerm,
            auspiciousHours: hours
        )
    }
    
    public func generateMonthGrid(for baseDate: Date) {
        var days: [CalendarDay] = []
        
        let startOfMonth = baseDate.startOfMonth
        let currentYear = calendar.component(.year, from: baseDate)
        let currentMonth = calendar.component(.month, from: baseDate)
        self.selectedYear = currentYear
        
        // Tìm ngày đầu tiên hiển thị trên lịch (Thứ Hai)
        let firstWeekday = calendar.component(.weekday, from: startOfMonth) // 1: CN, 2: T2, ..., 7: T7
        // Chuyển sang chuẩn VN: T2 = 0, ..., CN = 6
        let leadingOffset = (firstWeekday == 1) ? 6 : (firstWeekday - 2)
        
        guard let startDate = calendar.date(byAdding: .day, value: -leadingOffset, to: startOfMonth) else { return }
        
        // Tạo lưới 42 ngày (6 tuần x 7 ngày)
        for i in 0..<42 {
            guard let date = calendar.date(byAdding: .day, value: i, to: startDate) else { continue }
            let comp = calendar.dateComponents([.day, .month, .year], from: date)
            guard let d = comp.day, let m = comp.month, let y = comp.year else { continue }
            
            let isCurrent = (m == currentMonth && y == currentYear)
            let isToday = calendar.isDateInToday(date)
            let isWeekend = calendar.isDateInWeekend(date)
            
            let lunar = lunarConverter.convertSolarToLunar(day: d, month: m, year: y)
            let holidays = holidayService.getHolidays(solarDay: d, solarMonth: m, lunarDay: lunar.day, lunarMonth: lunar.month)
            let events = eventService.eventsForDay(solarDay: d, solarMonth: m, solarYear: y, lunarDay: lunar.day, lunarMonth: lunar.month, date: date)
            let solarTerm = solarTermCalculator.getSolarTerm(day: d, month: m, year: y)
            let hours = AuspiciousHourCalculator.shared.getHoursOfDay(chiDay: lunar.chiDay)
            
            let calDay = CalendarDay(
                date: date,
                solarDay: d,
                solarMonth: m,
                solarYear: y,
                lunarDate: lunar,
                isCurrentMonth: isCurrent,
                isToday: isToday,
                isWeekend: isWeekend,
                holidays: holidays,
                events: events,
                solarTerm: solarTerm,
                auspiciousHours: hours
            )
            days.append(calDay)
        }
        
        self.daysInMonth = days
    }
    
    public var currentMonthHeader: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "vi_VN")
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: currentDate).capitalized
    }
}
