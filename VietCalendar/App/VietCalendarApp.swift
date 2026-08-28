import SwiftUI
import UserNotifications

@main
public struct VietCalendarApp: App {
    public init() {
        UNUserNotificationCenter.current().delegate = NotificationDelegate.shared
    }
    
    public var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
