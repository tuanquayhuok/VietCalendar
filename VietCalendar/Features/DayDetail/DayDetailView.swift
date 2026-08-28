import SwiftUI

public struct DayDetailView: View {
    @Environment(\.dismiss) private var dismiss
    public let day: CalendarDay
    @State private var showingAddEvent = false
    
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
        }
        .frame(maxWidth: .infinity)
        .padding(20)
        .background(Color.vnSurface)
        .cornerRadius(16)
    }
    
    private var canChiCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Can Chi & Ngày Giờ")
                .font(.headline)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                infoRow(title: "Năm", value: day.lunarDate.yearName)
                infoRow(title: "Tháng", value: day.lunarDate.monthName)
                infoRow(title: "Ngày", value: day.lunarDate.dayName)
                infoRow(title: "Giờ đầu", value: "Giáp Tý")
            }
        }
        .padding(16)
        .background(Color.vnSurface)
        .cornerRadius(16)
    }
    
    private func solarTermCard(_ term: SolarTerm) -> some View {
        HStack {
            Image(systemName: "leaf.fill")
                .font(.title2)
                .foregroundColor(.vnEmerald)
            VStack(alignment: .leading) {
                Text("Tiết Khí Hiện Tại")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(term.name)
                    .font(.headline.bold())
                    .foregroundColor(.vnEmerald)
                Text(term.description)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
        .padding(16)
        .background(Color.vnSurface)
        .cornerRadius(16)
    }
    
    private var holidaysSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Ngày Lễ & Kỷ Niệm")
                .font(.headline)
            
            ForEach(day.holidays) { holiday in
                HStack {
                    Image(systemName: "sparkles")
                        .foregroundColor(holiday.type.badgeColor)
                    VStack(alignment: .leading) {
                        Text(holiday.name)
                            .font(.subheadline.bold())
                        if let desc = holiday.description {
                            Text(desc)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    Spacer()
                    if holiday.isDayOff {
                        Text("Nghỉ Lễ")
                            .font(.caption2.bold())
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.vnRed.opacity(0.15))
                            .foregroundColor(.vnRed)
                            .cornerRadius(8)
                    }
                }
                .padding(12)
                .background(holiday.type.badgeColor.opacity(0.08))
                .cornerRadius(12)
            }
        }
        .padding(16)
        .background(Color.vnSurface)
        .cornerRadius(16)
    }
    
    private var auspiciousHoursSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Giờ Hoàng Đạo (Tốt)")
                .font(.headline)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                ForEach(day.auspiciousHours.filter { $0.isAuspicious }) { h in
                    VStack(spacing: 2) {
                        Text(h.name)
                            .font(.subheadline.bold())
                            .foregroundColor(.vnGold)
                        Text(h.timeRange)
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(8)
                    .background(Color.vnGold.opacity(0.1))
                    .cornerRadius(8)
                }
            }
        }
        .padding(16)
        .background(Color.vnSurface)
        .cornerRadius(16)
    }
    
    private var eventsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Sự Kiện & Lịch Trình")
                    .font(.headline)
                Spacer()
                Button(action: { showingAddEvent = true }) {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.vnRed)
                }
            }
            
            if day.events.isEmpty {
                Text("Không có sự kiện nào cho ngày này.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding(.vertical, 8)
            } else {
                ForEach(day.events) { event in
                    HStack {
                        Circle()
                            .fill(Color(hex: event.colorHex))
                            .frame(width: 10, height: 10)
                        VStack(alignment: .leading) {
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
