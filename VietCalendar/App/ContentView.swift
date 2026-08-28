import SwiftUI

public struct ContentView: View {
    @State private var selectedTab = 0
    
    public init() {}
    
    public var body: some View {
        TabView(selection: $selectedTab) {
            CalendarView()
                .tabItem {
                    Label("Lịch Tháng", systemImage: "calendar")
                }
                .tag(0)
            
            ConvertDateView()
                .tabItem {
                    Label("Đổi Ngày", systemImage: "arrow.left.arrow.right")
                }
                .tag(1)
            
            EventListView()
                .tabItem {
                    Label("Sự Kiện", systemImage: "list.bullet.rectangle")
                }
                .tag(2)
            
            SettingsView()
                .tabItem {
                    Label("Cài Đặt", systemImage: "gearshape")
                }
                .tag(3)
        }
        .tint(Color.vnRed)
    }
}
