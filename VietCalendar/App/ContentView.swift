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
                // Tab 0: Lịch Tháng
                CalendarView()
                    .tabItem {
                        Label(langManager.tr("Lịch", en: "Calendar"), systemImage: "calendar")
                    }
                    .tag(0)
                
                // Tab 1: Đổi Ngày Âm Dương
                ConvertDateView()
                    .tabItem {
                        Label(langManager.tr("Đổi Ngày", en: "Convert"), systemImage: "arrow.left.arrow.right")
                    }
                    .tag(1)
                
                // Tab 2: ⚡ Tiện Ích (Nằm chính giữa Footer theo yêu cầu)
                UtilitiesView()
                    .tabItem {
                        Label(langManager.tr("Tiện Ích", en: "Utilities"), systemImage: "sparkles.square.filled.on.square")
                    }
                    .tag(2)
                
                // Tab 3: Sự Kiện & Lời Nhắc
                EventListView()
                    .tabItem {
                        Label(langManager.tr("Sự Kiện", en: "Events"), systemImage: "list.bullet.rectangle")
                    }
                    .tag(3)
                
                // Tab 4: Cài Đặt
                SettingsView()
                    .tabItem {
                        Label(langManager.tr("Cài Đặt", en: "Settings"), systemImage: "gearshape")
                    }
                    .tag(4)
            }
            .tint(themeManager.selectedAccent.color)
            .preferredColorScheme(themeManager.selectedTheme.colorScheme)
            
            // Màn hình Chào Mừng Đầu Tiên (Splash Welcome Screen 3s)
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
