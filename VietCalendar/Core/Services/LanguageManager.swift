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
    
    @Published public var selectedLanguage: AppLanguage {
        didSet {
            UserDefaults.standard.set(selectedLanguage.rawValue, forKey: "app_selected_language")
        }
    }
    
    private init() {
        let savedLang = UserDefaults.standard.string(forKey: "app_selected_language") ?? ""
        self.selectedLanguage = AppLanguage(rawValue: savedLang) ?? .vietnamese
    }
    
    public func tr(_ viText: String, en enText: String) -> String {
        return selectedLanguage == .vietnamese ? viText : enText
    }
}
