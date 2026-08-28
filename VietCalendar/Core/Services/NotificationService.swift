import Foundation
import UserNotifications

public final class NotificationService: Sendable {
    public static let shared = NotificationService()
    
    private init() {}
    
    public func requestAuthorization() async -> Bool {
        do {
            let center = UNUserNotificationCenter.current()
            return try await center.requestAuthorization(options: [.alert, .sound, .badge])
        } catch {
            print("Error requesting notification authorization: \(error)")
            return false
        }
    }
    
    public func scheduleReminder(for event: UserEvent) {
        guard event.hasReminder else { return }
        
        let content = UNMutableNotificationContent()
        content.title = event.title
        content.body = event.notes.isEmpty ? "Đến giờ diễn ra sự kiện!" : event.notes
        content.sound = .default
        
        var dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: event.solarDate)
        dateComponents.hour = 8 // Mặc định 8h sáng
        dateComponents.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let request = UNNotificationRequest(identifier: event.id.uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    public func removeReminder(for eventId: UUID) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [eventId.uuidString])
    }
}
