import SwiftUI

public struct DayDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var eventService = EventService.shared
    public let day: CalendarDay
    @State private var showingAddEvent = false
    @State private var editingEvent: UserEvent? = nil
    
    public init(day: CalendarDay) {
        self.day = day
    }
    
    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    headerBanner
                    canChiCard
                    if let term = day.solarTerm {
                        solarTermCard(term)
                    }
                    if !day.holidays.isEmpty {
                        holidaysSection
                    }
                    auspiciousHoursSection
                    eventsSection
                }
                .padding(16)
            }
            .navigationTitle("Chi Tiết Ngày")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Đóng") {
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $showingAddEvent) {
                AddEventView(initialDate: day.date)
            }
            .sheet(item: $editingEvent) { ev in
                AddEventView(initialDate: ev.solarDate, editingEvent: ev)
            }
        }
    }
    
    private var headerBanner: some View {
        VStack(spacing: 8) {
            Text("\(day.solarDay)")
                .font(.system(size: 56, weight: .bold, design: .rounded))
                .foregroundColor(.vnRed)
            
            Text("Tháng \(day.solarMonth) năm \(day.solarYear)")
                .font(.title3.bold())
            
            Divider().frame(width: 80)
            
            HStack(spacing: 6) {
                Image(systemName: "moon.stars.fill")
                    .foregroundColor(.vnGold)
                Text("Âm Lịch: \(day.lunarDate.formattedFull)")
                    .font(.headline)
                    .foregroundColor(.vnGold)
            }
            
            if day.lunarDate.isLeapMonth {
                Text("(Tháng Nhuận)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(20)
        .background(Color.vnSurface)
        .cornerRadius(16)
    }
    
    private var canChiCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Thông Tin Can Chi & Bát Tự")
                .font(.headline)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                infoRow(title: "Năm", value: day.lunarDate.yearName)
                infoRow(title: "Tháng", value: day.lunarDate.monthName)
                infoRow(title: "Ngày", value: day.lunarDate.dayName)
                infoRow(title: "Tiết Khí", value: day.solarTerm?.name ?? "—")
            }
        }
        .padding(16)
        .background(Color.vnSurface)
        .cornerRadius(16)
    }
    
    private func solarTermCard(_ term: SolarTerm) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Image(systemName: "leaf.fill")
                    .foregroundColor(.vnEmerald)
                Text("Tiết Khí: \(term.name)")
                    .font(.headline)
                    .foregroundColor(.vnEmerald)
            }
            Text(term.meaning)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(Color.vnEmerald.opacity(0.1))
        .cornerRadius(16)
    }
    
    private var holidaysSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Ngày Lễ & Sự Kiện Dân Gian")
                .font(.headline)
            
            ForEach(day.holidays) { holiday in
                HStack {
                    Image(systemName: "sparkles")
                        .foregroundColor(holiday.type.badgeColor)
                    VStack(alignment: .leading, spacing: 2) {
                        Text(holiday.name)
                            .font(.subheadline.bold())
                        if !holiday.description.isEmpty {
                            Text(holiday.description)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    Spacer()
                    if holiday.isDayOff {
                        Text("Nghỉ lễ")
                            .font(.caption2.bold())
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(Color.vnRed)
                            .foregroundColor(.white)
                            .cornerRadius(6)
                    }
                }
                .padding(10)
                .background(Color(UIColor.secondarySystemGroupedBackground))
                .cornerRadius(10)
            }
        }
        .padding(16)
        .background(Color.vnSurface)
        .cornerRadius(16)
    }
    
    private var auspiciousHoursSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Giờ Hoàng Đạo (Tốt)")
                .font(.headline)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                ForEach(day.auspiciousHours) { hour in
                    VStack(spacing: 2) {
                        Text("Giờ \(hour.branchName)")
                            .font(.subheadline.bold())
                        Text(hour.timeRange)
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(8)
                    .background(Color(UIColor.secondarySystemGroupedBackground))
                    .cornerRadius(8)
                }
            }
        }
        .padding(16)
        .background(Color.vnSurface)
        .cornerRadius(16)
    }
    
    private var eventsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Sự Kiện Của Bạn (Nhấn giữ để sửa/xóa)")
                    .font(.headline)
                Spacer()
                Button(action: { showingAddEvent = true }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title3)
                }
            }
            
            if day.events.isEmpty {
                Text("Chưa có sự kiện nào cho ngày này.")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.vertical, 8)
            } else {
                ForEach(day.events) { event in
                    HStack {
                        Circle()
                            .fill(Color(hex: event.colorHex))
                            .frame(width: 10, height: 10)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(event.title)
                                .font(.subheadline.bold())
                            if !event.notes.isEmpty {
                                Text(event.notes)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        Spacer()
                        Text(event.repeatType.rawValue)
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                    .padding(10)
                    .background(Color(UIColor.secondarySystemGroupedBackground))
                    .cornerRadius(10)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        editingEvent = event
                    }
                    .contextMenu {
                        Button(action: {
                            editingEvent = event
                        }) {
                            Label("Sửa sự kiện", systemImage: "pencil")
                        }
                        Button(role: .destructive, action: {
                            eventService.deleteEvent(id: event.id)
                        }) {
                            Label("Xóa sự kiện", systemImage: "trash")
                        }
                    }
                }
            }
        }
        .padding(16)
        .background(Color.vnSurface)
        .cornerRadius(16)
    }
    
    private func infoRow(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            Text(value)
                .font(.subheadline.bold())
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(10)
        .background(Color(UIColor.secondarySystemGroupedBackground))
        .cornerRadius(10)
    }
}
