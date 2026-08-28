import SwiftUI
import UserNotifications

public final class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate, Sendable {
    public static let shared = NotificationDelegate()
    
    // Cho phép hiển thị thông báo popup dạng banner ngay cả khi app đang mở
    public func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .sound, .badge, .list])
    }
}

public final class NotificationService: Sendable {
    public static let shared = NotificationService()
    
    private init() {
        UNUserNotificationCenter.current().delegate = NotificationDelegate.shared
    }
    
    /// Yêu cầu cấp quyền và bắn ngay 1 thông báo popup chào mừng để test
    public func requestAuthorizationAndSendWelcome() async -> Bool {
        do {
            let center = UNUserNotificationCenter.current()
            center.delegate = NotificationDelegate.shared
            
            let granted = try await center.requestAuthorization(options: [.alert, .sound, .badge])
            if granted {
                sendInstantNotification(
                    title: "🔔 Lịch Việt - Thông Báo",
                    body: "Đã bật nhắc nhở thành công! Bạn sẽ nhận được thông báo vào các ngày lễ, mùng 1, ngày rằm và ngày giỗ quan trọng."
                )
            }
            return granted
        } catch {
            print("Error requesting notification authorization: \(error)")
            return false
        }
    }
    
    /// Bắn thông báo ngay lập tức (sau 1 giây)
    public func sendInstantNotification(title: String, body: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Lỗi gửi thông báo tức thì: \(error)")
            }
        }
    }
    
    public func scheduleReminder(for event: UserEvent) {
        guard event.hasReminder else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "📅 " + event.title
        content.body = event.notes.isEmpty ? "Đến ngày diễn ra sự kiện!" : event.notes
        content.sound = .default
        
        var dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: event.solarDate)
        dateComponents.hour = 8
        dateComponents.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let request = UNNotificationRequest(identifier: event.id.uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    public func removeReminder(for eventId: UUID) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [eventId.uuidString])
    }
}
