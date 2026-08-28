import SwiftUI

public struct SettingsView: View {
    @ObservedObject private var themeManager = ThemeManager.shared
    @ObservedObject private var langManager = LanguageManager.shared
    
    @AppStorage("enable_holidays") private var enableHolidays = true
    @AppStorage("enable_solar_terms") private var enableSolarTerms = true
    @AppStorage("enable_auspicious_hours") private var enableAuspicious = true
    @AppStorage("enable_notifications_toggle") private var enableNotificationsToggle = false
    
    @State private var notificationStatus = "Chưa cấp quyền"
    @State private var showingSplashPreview = false
    
    public var body: some View {
        NavigationStack {
            Form {
                // MARK: - 1. Giao Diện & Màu Sắc (Theme & Accent)
                Section(header: Text(langManager.tr("Giao Diện & Màu Sắc", en: "Appearance & Theme"))) {
                    Picker(langManager.tr("Chế độ hiển thị", en: "Theme Mode"), selection: $themeManager.selectedTheme) {
                        ForEach(AppThemeMode.allCases) { mode in
                            Text(mode.rawValue).tag(mode)
                        }
                    }
                    .pickerStyle(.menu)
                    
                    Picker(langManager.tr("Màu sắc chủ đạo", en: "Accent Color"), selection: $themeManager.selectedAccent) {
                        ForEach(AppAccentColor.allCases) { accent in
                            HStack {
                                Circle().fill(accent.color).frame(width: 14, height: 14)
                                Text(accent.rawValue)
                            }
                            .tag(accent)
                        }
                    }
                    .pickerStyle(.menu)
                }
                
                // MARK: - 2. Ngôn Ngữ (Language)
                Section(header: Text(langManager.tr("Ngôn Ngữ Ứng Dụng", en: "Language"))) {
                    Picker(langManager.tr("Chọn ngôn ngữ", en: "Select Language"), selection: $langManager.selectedLanguage) {
                        ForEach(AppLanguage.allCases) { lang in
                            Text(lang.rawValue).tag(lang)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                // MARK: - 3. Tùy Chọn Lịch (Calendar Options)
                Section(header: Text(langManager.tr("Tùy Chọn Lịch Việt", en: "Calendar Display Options"))) {
                    Toggle(langManager.tr("Hiển thị ngày lễ Việt Nam", en: "Show Vietnamese Holidays"), isOn: $enableHolidays)
                    Toggle(langManager.tr("Hiển thị 24 Tiết khí", en: "Show 24 Solar Terms"), isOn: $enableSolarTerms)
                    Toggle(langManager.tr("Hiển thị Giờ Hoàng Đạo", en: "Show Auspicious Hours"), isOn: $enableAuspicious)
                }
                
                // MARK: - 4. Thông Báo & Nhắc Nhở (Tự động yêu cầu quyền + Bắn popup)
                Section(header: Text(langManager.tr("Thông Báo & Nhắc Nhở", en: "Notifications"))) {
                    Toggle(langManager.tr("Nhắc nhở thông báo", en: "Enable Notifications"), isOn: $enableNotificationsToggle)
                        .onChange(of: enableNotificationsToggle) { _, newValue in
                            if newValue {
                                Task {
                                    let granted = await NotificationService.shared.requestAuthorizationAndSendWelcome()
                                    notificationStatus = granted ? langManager.tr("Đã kích hoạt", en: "Enabled") : langManager.tr("Bị từ chối", en: "Denied")
                                    if !granted {
                                        enableNotificationsToggle = false
                                    }
                                }
                            }
                        }
                    
                    HStack {
                        Text(langManager.tr("Trạng thái", en: "Status"))
                        Spacer()
                        Text(notificationStatus)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Button(langManager.tr("Gửi thông báo thử nghiệm", en: "Send Test Notification")) {
                        Task {
                            let granted = await NotificationService.shared.requestAuthorizationAndSendWelcome()
                            notificationStatus = granted ? langManager.tr("Đã kích hoạt", en: "Enabled") : langManager.tr("Bị từ chối", en: "Denied")
                        }
                    }
                }
                
                // MARK: - 5. Tác Giả & Nhà Phát Triển (by trongtuandev)
                Section(header: Text(langManager.tr("Nhà Phát Triển", en: "Developer & Creator"))) {
                    HStack(spacing: 14) {
                        Circle()
                            .fill(themeManager.selectedAccent.color)
                            .frame(width: 48, height: 48)
                            .overlay(
                                Image(systemName: "person.fill")
                                    .font(.title3)
                                    .foregroundColor(.white)
                            )
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("by trongtuandev")
                                .font(.headline.bold())
                                .foregroundColor(.primary)
                            
                            Text(langManager.tr("Tác giả & Nhà phát triển ứng dụng", en: "Creator & Lead Developer"))
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.vertical, 4)
                    
                    Button(action: { showingSplashPreview = true }) {
                        Label(langManager.tr("Xem lại màn hình mở đầu (3s)", en: "Replay 3s Splash Animation"), systemImage: "play.circle.fill")
                            .font(.subheadline)
                    }
                }
                
                // MARK: - 6. Thông Tin Ứng Dụng
                Section(header: Text(langManager.tr("Thông Tin Ứng Dụng", en: "About App"))) {
                    HStack {
                        Text(langManager.tr("Phiên bản", en: "Version"))
                        Spacer()
                        Text("1.3.1 (Build 2026)")
                            .foregroundColor(.secondary)
                    }
                    HStack {
                        Text(langManager.tr("Thuật toán Âm Lịch", en: "Lunar Algorithm"))
                        Spacer()
                        Text("Hồ Ngọc Đức (GMT+7)")
                            .foregroundColor(.secondary)
                    }
                    HStack {
                        Text(langManager.tr("Nền tảng", en: "Platform"))
                        Spacer()
                        Text("SwiftUI • iOS 17+")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle(langManager.tr("Cài Đặt", en: "Settings"))
            .fullScreenCover(isPresented: $showingSplashPreview) {
                SplashWelcomeView {
                    showingSplashPreview = false
                }
            }
        }
    }
}
