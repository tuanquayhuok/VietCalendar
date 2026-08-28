import SwiftUI

public struct MiniDayInfo: Identifiable, Sendable {
    public let id: Int // index 0..<42
    public let dayNumber: Int?
    public let isToday: Bool
    public let isLunarStart: Bool
}

public struct MiniMonthInfo: Identifiable, Sendable {
    public let id: Int // month 1..12
    public let monthNumber: Int
    public let days: [MiniDayInfo]
}

public struct YearGridView: View {
    @Binding var selectedYear: Int
    public let onSelectMonth: (Int) -> Void
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var themeManager = ThemeManager.shared
    
    @State private var months2026: [MiniMonthInfo] = []
    @State private var months2027: [MiniMonthInfo] = []
    
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
                    yearSection(year: selectedYear, months: months2026)
                    yearSection(year: selectedYear + 1, months: months2027)
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
            .onAppear {
                loadYearData()
            }
        }
    }
    
    private func loadYearData() {
        months2026 = generateYearMonths(year: selectedYear)
        months2027 = generateYearMonths(year: selectedYear + 1)
    }
    
    private func generateYearMonths(year: Int) -> [MiniMonthInfo] {
        let cal = Calendar.current
        let today = Date()
        let todayD = cal.component(.day, from: today)
        let todayM = cal.component(.month, from: today)
        let todayY = cal.component(.year, from: today)
        
        var result: [MiniMonthInfo] = []
        
        for m in 1...12 {
            var comp = DateComponents()
            comp.year = year
            comp.month = m
            comp.day = 1
            
            let daysInMonth = (cal.range(of: .day, in: .month, for: cal.date(from: comp) ?? Date())?.count) ?? 30
            let startWeekday = cal.component(.weekday, from: cal.date(from: comp) ?? Date())
            let startOffset = (startWeekday == 1) ? 6 : (startWeekday - 2) // T2 = 0
            
            var dayInfos: [MiniDayInfo] = []
            for i in 0..<42 {
                let dayNumber = i - startOffset + 1
                if dayNumber >= 1 && dayNumber <= daysInMonth {
                    let isToday = (dayNumber == todayD && m == todayM && year == todayY)
                    let lunar = LunarCalendarConverter.shared.convertSolarToLunar(day: dayNumber, month: m, year: year)
                    let isLunarStart = (lunar.day == 1)
                    dayInfos.append(MiniDayInfo(id: i, dayNumber: dayNumber, isToday: isToday, isLunarStart: isLunarStart))
                } else {
                    dayInfos.append(MiniDayInfo(id: i, dayNumber: nil, isToday: false, isLunarStart: false))
                }
            }
            result.append(MiniMonthInfo(id: m, monthNumber: m, days: dayInfos))
        }
        return result
    }
    
    private func yearSection(year: Int, months: [MiniMonthInfo]) -> some View {
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
                ForEach(months) { monthInfo in
                    monthCard(monthInfo: monthInfo, year: year)
                }
            }
        }
    }
    
    private func monthCard(monthInfo: MiniMonthInfo, year: Int) -> some View {
        let isCurrentMonth = (monthInfo.monthNumber == Calendar.current.component(.month, from: Date()) && year == Calendar.current.component(.year, from: Date()))
        
        return Button(action: {
            selectedYear = year
            onSelectMonth(monthInfo.monthNumber)
            dismiss()
        }) {
            VStack(alignment: .leading, spacing: 6) {
                Text("Tháng \(monthInfo.monthNumber)")
                    .font(.system(size: 16, weight: .heavy, design: .rounded))
                    .foregroundColor(isCurrentMonth ? Color.vnRed : .primary)
                
                // 6 rows x 7 cols
                VStack(spacing: 2) {
                    ForEach(0..<6, id: \.self) { row in
                        HStack(spacing: 0) {
                            ForEach(0..<7, id: \.self) { col in
                                let index = row * 7 + col
                                if index < monthInfo.days.count {
                                    let day = monthInfo.days[index]
                                    if let num = day.dayNumber {
                                        ZStack {
                                            if day.isToday {
                                                Circle()
                                                    .fill(Color.vnRed)
                                                    .frame(width: 14, height: 14)
                                            }
                                            Text("\(num)")
                                                .font(.system(size: 8.5, weight: day.isToday ? .bold : (day.isLunarStart ? .bold : .medium)))
                                                .foregroundColor(day.isToday ? .white : (day.isLunarStart ? Color.vnRed : .primary))
                                                .underline(day.isLunarStart && !day.isToday, color: Color.vnRed)
                                        }
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 12)
                                    } else {
                                        Text("")
                                            .frame(maxWidth: .infinity)
                                            .frame(height: 12)
                                    }
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
}
