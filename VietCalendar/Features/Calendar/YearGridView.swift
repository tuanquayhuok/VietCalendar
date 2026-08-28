import SwiftUI

public struct YearGridView: View {
    @Binding var selectedYear: Int
    public let onSelectMonth: (Int) -> Void
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var themeManager = ThemeManager.shared
    
    public init(selectedYear: Binding<Int>, onSelectMonth: @escaping (Int) -> Void) {
        self._selectedYear = selectedYear
        self.onSelectMonth = onSelectMonth
    }
    
    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]
    
    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 28) {
                    yearSection(year: selectedYear)
                    yearSection(year: selectedYear + 1)
                }
                .padding(.horizontal, 16)
                .padding(.top, 10)
                .padding(.bottom, 90)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack(spacing: 12) {
                        Button(action: {}) {
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.primary)
                        }
                        Button(action: {}) {
                            Image(systemName: "plus")
                                .font(.system(size: 17, weight: .bold))
                                .foregroundColor(.primary)
                        }
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 7)
                    .background(Color(UIColor.secondarySystemGroupedBackground))
                    .clipShape(Capsule())
                    .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                }
            }
            .overlay(alignment: .bottom) {
                // Bottom floating navigation capsule
                HStack {
                    Button(action: {
                        let currentMonth = Calendar.current.component(.month, from: Date())
                        onSelectMonth(currentMonth)
                        dismiss()
                    }) {
                        Text("Hôm nay")
                            .font(.system(size: 15, weight: .bold, design: .rounded))
                            .foregroundColor(.primary)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(Color(UIColor.secondarySystemGroupedBackground))
                            .clipShape(Capsule())
                            .shadow(color: Color.black.opacity(0.1), radius: 6, x: 0, y: 3)
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 18) {
                        Button(action: { dismiss() }) {
                            Image(systemName: "calendar")
                                .font(.system(size: 17, weight: .bold))
                                .foregroundColor(.primary)
                        }
                        Button(action: { dismiss() }) {
                            Image(systemName: "tray.full")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.primary)
                        }
                    }
                    .padding(.horizontal, 18)
                    .padding(.vertical, 10)
                    .background(Color(UIColor.secondarySystemGroupedBackground))
                    .clipShape(Capsule())
                    .shadow(color: Color.black.opacity(0.1), radius: 6, x: 0, y: 3)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 12)
            }
        }
    }
    
    private func yearSection(year: Int) -> some View {
        let canChiYear = LunarCalendarConverter.shared.getYearCanChi(year: year)
        return VStack(alignment: .leading, spacing: 14) {
            // Year Header
            HStack(alignment: .bottom) {
                Text("\(year)")
                    .font(.system(size: 38, weight: .black, design: .rounded))
                    .foregroundColor(year == selectedYear ? Color.vnRed : .primary)
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 2) {
                    Text("— \(canChiYear) \(year)")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(.secondary)
                    Text("— Ngày đầu tiên của tháng âm lịch")
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(.secondary.opacity(0.8))
                }
            }
            .padding(.bottom, 4)
            
            Divider()
            
            // 3x4 Month Grid
            LazyVGrid(columns: columns, spacing: 18) {
                ForEach(1...12, id: \.self) { month in
                    monthThumbnail(month: month, year: year)
                }
            }
        }
    }
    
    private func monthThumbnail(month: Int, year: Int) -> some View {
        let isCurrentMonth = (month == Calendar.current.component(.month, from: Date()) && year == Calendar.current.component(.year, from: Date()))
        let daysCount = numberOfDays(month: month, year: year)
        let startOffset = firstWeekdayOffset(month: month, year: year)
        
        return Button(action: {
            selectedYear = year
            onSelectMonth(month)
            dismiss()
        }) {
            VStack(alignment: .leading, spacing: 6) {
                Text("Tháng \(month)")
                    .font(.system(size: 16, weight: .heavy, design: .rounded))
                    .foregroundColor(isCurrentMonth ? Color.vnRed : .primary)
                
                // Mini 7-column Grid
                VStack(spacing: 3) {
                    ForEach(0..<6, id: \.self) { row in
                        HStack(spacing: 0) {
                            ForEach(0..<7, id: \.self) { col in
                                let index = row * 7 + col
                                let dayNumber = index - startOffset + 1
                                if dayNumber >= 1 && dayNumber <= daysCount {
                                    miniDayCell(day: dayNumber, month: month, year: year)
                                } else {
                                    Text("")
                                        .frame(maxWidth: .infinity)
                                }
                            }
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .buttonStyle(.plain)
    }
    
    private func miniDayCell(day: Int, month: Int, year: Int) -> some View {
        let isToday = (day == Calendar.current.component(.day, from: Date()) && month == Calendar.current.component(.month, from: Date()) && year == Calendar.current.component(.year, from: Date()))
        let lunar = LunarCalendarConverter.shared.convertSolarToLunar(day: day, month: month, year: year)
        let isLunarMonthStart = (lunar.day == 1)
        
        return ZStack {
            if isToday {
                Circle()
                    .fill(Color.vnRed)
                    .frame(width: 14, height: 14)
            }
            
            Text("\(day)")
                .font(.system(size: 8.5, weight: isToday ? .bold : (isLunarMonthStart ? .bold : .medium)))
                .foregroundColor(isToday ? .white : (isLunarMonthStart ? Color.vnRed : .primary))
                .underline(isLunarMonthStart && !isToday, color: Color.vnRed)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 11)
    }
    
    private func numberOfDays(month: Int, year: Int) -> Int {
        var comp = DateComponents()
        comp.year = year
        comp.month = month
        guard let date = Calendar.current.date(from: comp),
              let range = Calendar.current.range(of: .day, in: .month, for: date) else { return 30 }
        return range.count
    }
    
    private func firstWeekdayOffset(month: Int, year: Int) -> Int {
        var comp = DateComponents()
        comp.year = year
        comp.month = month
        comp.day = 1
        guard let date = Calendar.current.date(from: comp) else { return 0 }
        let weekday = Calendar.current.component(.weekday, from: date)
        return (weekday == 1) ? 6 : (weekday - 2) // T2 = 0, ..., CN = 6
    }
}
