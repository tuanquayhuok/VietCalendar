import SwiftUI

public struct CalendarSearchView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var searchText: String = ""
    public let onSelectDate: (Date) -> Void
    
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 4), count: 7)
    private let weekdays = ["T2", "T3", "T4", "T5", "T6", "T7", "CN"]
    
    public init(onSelectDate: @escaping (Date) -> Void) {
        self.onSelectDate = onSelectDate
    }
    
    public var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Top Search Bar (Matching Image 4)
                HStack(spacing: 10) {
                    HStack(spacing: 8) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.secondary)
                        TextField("Tìm kiếm", text: $searchText)
                            .font(.system(size: 17))
                        
                        if !searchText.isEmpty {
                            Button(action: { searchText = "" }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.secondary)
                            }
                        } else {
                            Image(systemName: "mic.fill")
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(Color(UIColor.secondarySystemGroupedBackground))
                    .clipShape(Capsule())
                    .shadow(color: Color.black.opacity(0.04), radius: 4, x: 0, y: 2)
                    
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.primary)
                            .padding(10)
                            .background(Color(UIColor.secondarySystemGroupedBackground))
                            .clipShape(Circle())
                            .shadow(color: Color.black.opacity(0.04), radius: 4, x: 0, y: 2)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 10)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 14) {
                        // Large Month Header
                        Text("Tháng 8")
                            .font(.system(size: 34, weight: .black, design: .rounded))
                            .padding(.horizontal, 16)
                            .padding(.top, 12)
                        
                        // Weekdays Row
                        HStack {
                            ForEach(weekdays, id: \.self) { w in
                                Text(w)
                                    .font(.system(size: 12, weight: .bold, design: .rounded))
                                    .frame(maxWidth: .infinity)
                                    .foregroundColor(w == "T7" || w == "CN" ? .secondary : .primary)
                            }
                        }
                        .padding(.horizontal, 14)
                        
                        // Month Days Grid (Matching Image 4)
                        LazyVGrid(columns: columns, spacing: 10) {
                            // August 2026 starts on Saturday (offset 5 empty cells)
                            ForEach(0..<5, id: \.self) { _ in
                                Text("").frame(height: 48)
                            }
                            
                            ForEach(1...31, id: \.self) { day in
                                searchDayCell(day: day, month: 8, year: 2026)
                            }
                        }
                        .padding(.horizontal, 12)
                        
                        // Bottom Event Status
                        VStack(spacing: 8) {
                            Spacer().frame(height: 20)
                            Text("Không có sự kiện")
                                .font(.system(size: 20, weight: .bold, design: .rounded))
                                .foregroundColor(Color.secondary.opacity(0.8))
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                        .padding(.top, 24)
                    }
                }
            }
            .background(Color(UIColor.systemBackground))
            .navigationBarHidden(true)
        }
    }
    
    private func searchDayCell(day: Int, month: Int, year: Int) -> some View {
        let lunar = LunarCalendarConverter.shared.convertSolarToLunar(day: day, month: month, year: year)
        let isToday = (day == 29)
        let isLunarMonthStart = (lunar.day == 1) // Ngày 13 Dương là Mùng 1 Thg 7 Âm
        
        return Button(action: {
            var comp = DateComponents()
            comp.year = year
            comp.month = month
            comp.day = day
            if let d = Calendar.current.date(from: comp) {
                onSelectDate(d)
                dismiss()
            }
        }) {
            VStack(spacing: 2) {
                if isToday {
                    ZStack {
                        Circle()
                            .fill(Color.vnRed)
                            .frame(width: 38, height: 38)
                        
                        VStack(spacing: 0) {
                            Text("\(day)")
                                .font(.system(size: 16, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                            Text("\(lunar.day)")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(.white)
                        }
                    }
                } else {
                    Text("\(day)")
                        .font(.system(size: 17, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                    
                    if isLunarMonthStart {
                        Text("Thg \(lunar.month)")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(Color.vnRed)
                            .underline(true, color: Color.vnRed)
                    } else {
                        Text("\(lunar.day)")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(.secondary)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 48)
        }
        .buttonStyle(.plain)
    }
}
