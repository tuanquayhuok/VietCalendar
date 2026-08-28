import SwiftUI

public struct CalendarView: View {
    @StateObject private var viewModel = CalendarViewModel()
    @State private var showingDetailSheet = false
    @State private var showingAddEventSheet = false
    
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 4), count: 7)
    private let weekdayHeaders = ["T2", "T3", "T4", "T5", "T6", "T7", "CN"]
    
    public var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Header Điều Hướng Tháng
                headerView
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                
                // Tiêu đề Thứ trong tuần
                weekdayHeaderView
                    .padding(.horizontal, 12)
                    .padding(.top, 12)
                
                // Lưới Lịch 42 ngày
                LazyVGrid(columns: columns, spacing: 6) {
                    ForEach(viewModel.daysInMonth) { day in
                        let isSelected = Calendar.current.isDate(day.date, inSameDayAs: viewModel.selectedDate)
                        DayCellView(day: day, isSelected: isSelected) {
                            viewModel.selectDay(day)
                        }
                    }
                }
                .padding(.horizontal, 12)
                .padding(.top, 8)
                
                Divider()
                    .padding(.top, 12)
                
                // Card Thông Tin Chi Tiết Ngày Đang Chọn
                if let selected = viewModel.selectedDayDetails {
                    selectedDayCard(selected)
                        .padding(.horizontal, 16)
                        .padding(.top, 12)
                }
                
                Spacer()
            }
            .navigationTitle("Lịch Việt Nam")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddEventSheet = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 20))
                            .foregroundColor(.vnRed)
                    }
                }
            }
            .sheet(isPresented: $showingDetailSheet) {
                if let day = viewModel.selectedDayDetails {
                    DayDetailView(day: day)
                }
            }
            .sheet(isPresented: $showingAddEventSheet) {
                AddEventView(initialDate: viewModel.selectedDate)
            }
        }
    }
    
    // MARK: - Header
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(viewModel.currentMonthHeader)
                    .font(.title2.bold())
                    .foregroundColor(.primary)
                
                if let selected = viewModel.selectedDayDetails {
                    Text("Năm \(selected.lunarDate.yearName) - Tháng \(selected.lunarDate.monthName)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            HStack(spacing: 8) {
                Button(action: { viewModel.previousMonth() }) {
                    Image(systemName: "chevron.left")
                        .padding(8)
                        .background(Color.vnSurface)
                        .clipShape(Circle())
                }
                
                Button("Hôm nay") {
                    withAnimation {
                        viewModel.selectToday()
                    }
                }
                .font(.caption.bold())
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(Color.vnRed.opacity(0.12))
                .foregroundColor(.vnRed)
                .cornerRadius(16)
                
                Button(action: { viewModel.nextMonth() }) {
                    Image(systemName: "chevron.right")
                        .padding(8)
                        .background(Color.vnSurface)
                        .clipShape(Circle())
                }
            }
        }
    }
    
    // MARK: - Weekday Headers
    private var weekdayHeaderView: some View {
        HStack {
            ForEach(0..<7, id: \.self) { index in
                Text(weekdayHeaders[index])
                    .font(.caption.bold())
                    .frame(maxWidth: .infinity)
                    .foregroundColor(index >= 5 ? .vnRed : .secondary)
            }
        }
    }
    
    // MARK: - Selected Day Card
    private func selectedDayCard(_ day: CalendarDay) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(day.date.formattedVietnamese(dateStyle: .full))
                        .font(.headline)
                    
                    Text("Âm Lịch: \(day.lunarDate.formattedFull)")
                        .font(.subheadline)
                        .foregroundColor(.vnGold)
                }
                
                Spacer()
                
                Button("Chi tiết") {
                    showingDetailSheet = true
                }
                .font(.subheadline.bold())
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.vnRed)
                .foregroundColor(.white)
                .cornerRadius(16)
            }
            
            // Ngày lễ nếu có
            if !day.holidays.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    ForEach(day.holidays) { holiday in
                        HStack {
                            Image(systemName: "sparkles")
                                .foregroundColor(holiday.type.badgeColor)
                            Text(holiday.name)
                                .font(.caption.bold())
                                .foregroundColor(holiday.type.badgeColor)
                            if holiday.isDayOff {
                                Text("(Nghỉ lễ)")
                                    .font(.caption2)
                                    .foregroundColor(.vnRed)
                            }
                        }
                    }
                }
            }
            
            // Sự kiện người dùng nếu có
            if !day.events.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    ForEach(day.events) { event in
                        HStack {
                            Circle()
                                .fill(Color(hex: event.colorHex))
                                .frame(width: 8, height: 8)
                            Text(event.title)
                                .font(.caption)
                            Spacer()
                            Text(event.repeatType.rawValue)
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
        }
        .padding(14)
        .background(Color.vnSurface)
        .cornerRadius(16)
    }
}
