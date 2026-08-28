import SwiftUI

public struct CalendarSearchView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var searchText = ""
    @ObservedObject private var themeManager = ThemeManager.shared
    public let onSelectDate: (Date) -> Void
    
    private var filteredHolidays: [Holiday] {
        if searchText.isEmpty {
            return HolidayService.allHolidays
        }
        return HolidayService.allHolidays.filter {
            $0.name.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    public var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Ngày Lễ & Sự Kiện Truyền Thống")) {
                    ForEach(filteredHolidays) { holiday in
                        HStack(spacing: 12) {
                            Circle()
                                .fill(holiday.type.badgeColor.opacity(0.15))
                                .frame(width: 36, height: 36)
                                .overlay(
                                    Image(systemName: "sparkles")
                                        .font(.caption)
                                        .foregroundColor(holiday.type.badgeColor)
                                )
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text(holiday.name)
                                    .font(.headline)
                                Text(holiday.isLunar ? "Âm Lịch: Ngày \(holiday.day) tháng \(holiday.month)" : "Dương Lịch: Ngày \(holiday.day) tháng \(holiday.month)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            if holiday.isDayOff {
                                Text("Nghỉ lễ")
                                    .font(.caption2.bold())
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.vnRed.opacity(0.12))
                                    .foregroundColor(.vnRed)
                                    .cornerRadius(8)
                            }
                        }
                        .padding(.vertical, 2)
                    }
                }
            }
            .searchable(text: $searchText, prompt: "Tìm kiếm ngày lễ, tết, giỗ chạp...")
            .navigationTitle("Tìm Kiếm")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Đóng") { dismiss() }
                }
            }
        }
    }
}
