import SwiftUI

public enum AppThemeMode: String, CaseIterable, Identifiable {
    case system = "Theo hệ thống"
    case light = "Giao diện Sáng"
    case dark = "Giao diện Tối"
    
    public var id: String { rawValue }
    
    public var colorScheme: ColorScheme? {
        switch self {
        case .system:
            return nil
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }
}

public enum AppAccentColor: String, CaseIterable, Identifiable {
    case red = "Đỏ Truyền Thống"
    case gold = "Vàng Hoàng Kim"
    case emerald = "Xanh Ngọc Bích"
    case blue = "Xanh Biển Đông"
    case purple = "Tím Hoàng Triều"
    
    public var id: String { rawValue }
    
    public var color: Color {
        switch self {
        case .red:
            return Color(hex: "#DC2626")
        case .gold:
            return Color(hex: "#D97706")
        case .emerald:
            return Color(hex: "#059669")
        case .blue:
            return Color(hex: "#2563EB")
        case .purple:
            return Color(hex: "#7C3AED")
        }
    }
}

public final class ThemeManager: ObservableObject {
    public static let shared = ThemeManager()
    
    @AppStorage("app_theme_mode") public var selectedTheme: AppThemeMode = .system
    @AppStorage("app_accent_color") public var selectedAccent: AppAccentColor = .red
    
    private init() {}
}
