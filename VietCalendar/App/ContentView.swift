import SwiftUI

public struct ContentView: View {
    @StateObject private var themeManager = ThemeManager.shared
    @StateObject private var langManager = LanguageManager.shared
    @State private var selectedTab = 0
    @State private var showSplash = true
    
    public init() {}
    
    public var body: some View {
        ZStack {
            TabView(selection: $selectedTab) {
                CalendarView()
                    .tabItem {
                        Label(langManager.tr("Lịch Tháng", en: "Calendar"), systemImage: "calendar")
                    }
                    .tag(0)
                
                ConvertDateView()
                    .tabItem {
                        Label(langManager.tr("Đổi Ngày", en: "Convert"), systemImage: "arrow.left.arrow.right")
                    }
                    .tag(1)
                
                EventListView()
                    .tabItem {
                        Label(langManager.tr("Sự Kiện", en: "Events"), systemImage: "list.bullet.rectangle")
                    }
                    .tag(2)
                
                SettingsView()
                    .tabItem {
                        Label(langManager.tr("Cài Đặt", en: "Settings"), systemImage: "gearshape")
                    }
                    .tag(3)
            }
            .tint(themeManager.selectedAccent.color)
            .preferredColorScheme(themeManager.selectedTheme.colorScheme)
            
            // Màn hình Chào Mừng Đầu Tiên (Splash Welcome Screen)
            if showSplash {
                SplashWelcomeView {
                    withAnimation(.easeInOut(duration: 0.6)) {
                        showSplash = false
                    }
                }
                .transition(.opacity.combined(with: .scale(scale: 1.05)))
                .zIndex(999)
            }
        }
    }
}
