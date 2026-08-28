import SwiftUI

public enum AppLanguage: String, CaseIterable, Identifiable {
    case vietnamese = "Tiếng Việt"
    case english = "English"
    
    public var id: String { rawValue }
    public var code: String {
        switch self {
        case .vietnamese: return "vi"
        case .english: return "en"
        }
    }
}

public final class LanguageManager: ObservableObject {
    public static let shared = LanguageManager()
    
    @AppStorage("app_selected_language") public var selectedLanguage: AppLanguage = .vietnamese
    
    private init() {}
    
    public func tr(_ viText: String, en enText: String) -> String {
        return selectedLanguage == .vietnamese ? viText : enText
    }
}
