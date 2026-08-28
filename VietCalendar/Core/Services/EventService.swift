import Foundation
import Combine

@MainActor
public final class EventService: ObservableObject {
    public static let shared = EventService()
    
    @Published public var events: [UserEvent] = []
    
    private let storageKey = "viet_calendar_user_events"
    
    private init() {
        loadEvents()
        if events.isEmpty {
            loadSampleEvents()
        }
    }
    
    public func addEvent(_ event: UserEvent) {
        events.append(event)
        saveEvents()
    }
    
    public func updateEvent(_ event: UserEvent) {
        if let index = events.firstIndex(where: { $0.id == event.id }) {
            events[index] = event
            saveEvents()
        }
    }
    
    public func deleteEvent(id: UUID) {
        events.removeAll(where: { $0.id == id })
        saveEvents()
    }
    
    /// Kiểm tra xem sự kiện có diễn ra vào ngày chỉ định không (bao gồm lặp âm/dương)
    public func eventsForDay(solarDay: Int, solarMonth: Int, solarYear: Int, lunarDay: Int, lunarMonth: Int, date: Date) -> [UserEvent] {
        let calendar = Calendar.current
        
        return events.filter { event in
            switch event.repeatType {
            case .none:
                if event.isLunarBased {
                    let evLunar = LunarCalendarConverter.shared.convertSolarToLunar(date: event.solarDate)
                    return evLunar.day == lunarDay && evLunar.month == lunarMonth && evLunar.year == lunarDay
                } else {
                    return calendar.isDate(event.solarDate, inSameDayAs: date)
                }
                
            case .daily:
                return date >= event.solarDate
                
            case .weekly:
                let evWeekday = calendar.component(.weekday, from: event.solarDate)
                let currentWeekday = calendar.component(.weekday, from: date)
                return evWeekday == currentWeekday && date >= event.solarDate
                
            case .monthlySolar:
                let evDay = calendar.component(.day, from: event.solarDate)
                return evDay == solarDay && date >= event.solarDate
                
            case .yearlySolar:
                let evDay = calendar.component(.day, from: event.solarDate)
                let evMonth = calendar.component(.month, from: event.solarDate)
                return evDay == solarDay && evMonth == solarMonth
                
            case .yearlyLunar:
                return event.lunarDay == lunarDay && event.lunarMonth == lunarMonth
            }
        }
    }
    
    private func saveEvents() {
        if let encoded = try? JSONEncoder().encode(events) {
            UserDefaults.standard.set(encoded, forKey: storageKey)
        }
    }
    
    private func loadEvents() {
        if let data = UserDefaults.standard.data(forKey: storageKey),
           let decoded = try? JSONDecoder().decode([UserEvent].self, from: data) {
            self.events = decoded
        }
    }
    
    private func loadSampleEvents() {
        let sample1 = UserEvent(
            title: "Ngày Giỗ Gia Tiên",
            notes: "Cúng giỗ ông bà nội (Hàng năm 15/10 Âm lịch)",
            isLunarBased: true,
            lunarDay: 15,
            lunarMonth: 10,
            repeatType: .yearlyLunar,
            colorHex: "#EF4444"
        )
        let sample2 = UserEvent(
            title: "Họp Định Kỳ Công Ty",
            notes: "Họp tổng kết tuần",
            solarDate: Date(),
            isLunarBased: false,
            repeatType: .weekly,
            colorHex: "#10B981"
        )
        self.events = [sample1, sample2]
        saveEvents()
    }
}
