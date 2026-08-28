import SwiftUI

public struct SettingsView: View {
    @AppStorage("enable_holidays") private var enableHolidays = true
    @AppStorage("enable_solar_terms") private var enableSolarTerms = true
    @AppStorage("enable_auspicious_hours") private var enableAuspicious = true
    @State private var notificationStatus = "Chưa cấp quyền"
    
    public var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Tùy Chọn Hiển Thị")) {
                    Toggle("Hiển thị ngày lễ Việt Nam", isOn: $enableHolidays)
                    Toggle("Hiển thị 24 Tiết khí", isOn: $enableSolarTerms)
                    Toggle("Hiển thị Giờ Hoàng Đạo", isOn: $enableAuspicious)
                }
                
                Section(header: Text("Thông Báo & Nhắc Nhở")) {
                    HStack {
                        Text("Trạng thái thông báo")
                        Spacer()
                        Text(notificationStatus)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Button("Cấp quyền nhận thông báo") {
                        Task {
                            let granted = await NotificationService.shared.requestAuthorization()
                            notificationStatus = granted ? "Đã bật" : "Bị từ chối"
                        }
                    }
                }
                
                Section(header: Text("Về Ứng Dụng")) {
                    HStack {
                        Text("Phiên bản")
                        Spacer()
                        Text("1.0.0 (Build 2026)")
                            .foregroundColor(.secondary)
                    }
                    HStack {
                        Text("Thuật toán Âm Lịch")
                        Spacer()
                        Text("Hồ Ngọc Đức (GMT+7)")
                            .foregroundColor(.secondary)
                    }
                    HStack {
                        Text("Nền tảng")
                        Spacer()
                        Text("SwiftUI • iOS 17+")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Cài Đặt")
        }
    }
}
