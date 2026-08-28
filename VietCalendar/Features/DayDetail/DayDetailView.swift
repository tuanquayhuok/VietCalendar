import SwiftUI

public struct DayDetailView: View {
    @Environment(\.dismiss) private var dismiss
    public let day: CalendarDay
    @State private var showingAddEvent = false
    
    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    // Header Banner Ngày Âm & Dương
                    headerBanner
                    
                    // Card Can Chi & Bát Tự
                    canChiCard
                    
                    // Tiết Khí
                    if let term = day.solarTerm {
                        solarTermCard(term)
                    }
                    
                    // Ngày Lễ
                    if !day.holidays.isEmpty {
                        holidaysSection
                    }
                    
                    // Giờ Hoàng Đạo
                    auspiciousHoursSection
                    
                    // Sự Kiện Cá Nhân
                    eventsSection
                }
                .padding(16)
            }
            .navigationTitle("Chi Tiết Ngày")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
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
    
    // MARK: - Banner Header
    private var headerBanner: some View {
        VStack(spacing: 8) {
            Text("\(day.solarDay)")
                .font(.system(size: 56, weight: .bold, design: .rounded))
                .foregroundColor(.vnRed)
            
            Text("Tháng \(day.solarMonth) năm \(day.solarYear)")
                .font(.title3.bold())
            
            Text(day.date.formattedVietnamese(dateStyle: .full))
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Divider().padding(.vertical, 4)
            
            HStack(spacing: 6) {
                Image(systemName: "moon.stars.fill")
                    .foregroundColor(.vnGold)
                Text(day.lunarDate.formattedFull)
                    .font(.headline)
                    .foregroundColor(.vnGold)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(20)
        .background(Color.vnSurface)
        .cornerRadius(20)
    }
    
    // MARK: - Can Chi Card
    private var canChiCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Can Chi Ngày Tháng Năm", systemImage: "sparkles")
                .font(.headline)
                .foregroundColor(.vnRed)
            
            HStack {
                canChiItem(title: "Ngày", value: day.lunarDate.dayName)
                Divider()
                canChiItem(title: "Tháng", value: day.lunarDate.monthName)
                Divider()
                canChiItem(title: "Năm", value: day.lunarDate.yearName)
            }
        }
        .padding(16)
        .background(Color.vnSurface)
        .cornerRadius(16)
    }
    
    private func canChiItem(title: String, value: String) -> some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            Text(value)
                .font(.subheadline.bold())
                .foregroundColor(.primary)
        }
        .frame(maxWidth: .infinity)
    }
    
    // MARK: - Tiết Khí
    private func solarTermCard(_ term: SolarTerm) -> some View {
        HStack(spacing: 12) {
            Image(systemName: "sun.max.fill")
                .font(.title2)
                .foregroundColor(.orange)
            
            VStack(alignment: .leading, spacing: 2) {
                Text("Tiết Khí: \(term.name)")
                    .font(.headline)
                Text(term.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
        .padding(16)
        .background(Color.orange.opacity(0.12))
        .cornerRadius(16)
    }
    
    // MARK: - Ngày Lễ
    private var holidaysSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label("Ngày Lễ & Kỷ Niệm", systemImage: "flag.fill")
                .font(.headline)
                .foregroundColor(.vnRed)
            
            ForEach(day.holidays) { holiday in
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(holiday.name)
                            .font(.subheadline.bold())
                        Text(holiday.description)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    Text(holiday.type.rawValue)
                        .font(.caption2.bold())
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(holiday.type.badgeColor.opacity(0.15))
                        .foregroundColor(holiday.type.badgeColor)
                        .cornerRadius(8)
                }
                .padding(12)
                .background(Color.vnSurface)
                .cornerRadius(12)
            }
        }
    }
    
    // MARK: - Giờ Hoàng Đạo
    private var auspiciousHoursSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label("Giờ Hoàng Đạo (Tốt)", systemImage: "clock.badge.checkmark.fill")
                .font(.headline)
                .foregroundColor(.vnEmerald)
            
            let goodHours = day.auspiciousHours.filter { $0.isAuspicious }
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                ForEach(goodHours) { hour in
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(hour.name)
                                .font(.subheadline.bold())
                            Text(hour.timeRange)
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        Image(systemName: "checkmark.seal.fill")
                            .foregroundColor(.vnEmerald)
                    }
                    .padding(10)
                    .background(Color.vnEmerald.opacity(0.08))
                    .cornerRadius(10)
                }
            }
        }
    }
    
    // MARK: - Sự Kiện
    private var eventsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Label("Sự Kiện Trong Ngày", systemImage: "calendar.badge.plus")
                    .font(.headline)
                Spacer()
                Button(action: { showingAddEvent = true }) {
                    Label("Thêm", systemImage: "plus")
                        .font(.caption.bold())
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
                    .padding(12)
                    .background(Color.vnSurface)
                    .cornerRadius(12)
                }
            }
        }
    }
}
