import SwiftUI
import UserNotifications

@main
struct VietCalendarApp: App {
    init() {
        UNUserNotificationCenter.current().delegate = NotificationDelegate.shared
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
