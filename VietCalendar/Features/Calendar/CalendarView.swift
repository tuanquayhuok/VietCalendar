import SwiftUI

public enum CalendarDisplayMode {
    case grid
    case list
}

public struct CalendarView: View {
    @StateObject private var viewModel = CalendarViewModel()
    @ObservedObject private var themeManager = ThemeManager.shared
    @ObservedObject private var langManager = LanguageManager.shared
    
    @State private var displayMode: CalendarDisplayMode = .grid
    @State private var showingYearGrid = false
    @State private var showingSearch = false
    @State private var showingAddEvent = false
    @State private var showingDetailSheet = false
    
    public init() {}
    
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 4), count: 7)
    private let weekdayHeadersVi = ["T2", "T3", "T4", "T5", "T6", "T7", "CN"]
    private let weekdayHeadersEn = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    
    public var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // MARK: - 1. Top Modern Floating Capsule Toolbar (Chuẩn thiết kế Apple)
                topCapsuleToolbar
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                
                // MARK: - 2. Month Title & Controls
                monthTitleBar
                    .padding(.horizontal, 16)
                    .padding(.top, 12)
                
                if displayMode == .grid {
                    // MARK: - 3. Weekday Header
                    weekdayHeaderView
                        .padding(.horizontal, 14)
                        .padding(.top, 10)
                    
                    // MARK: - 4. 42-Day Month Grid (Hỗ trợ vuốt ngang chuyển tháng)
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
                    .gesture(
                        DragGesture(minimumDistance: 30, coordinateSpace: .local)
                            .onEnded { value in
                                if value.translation.width < -50 {
                                    withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                                        viewModel.nextMonth()
                                    }
                                } else if value.translation.width > 50 {
                                    withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                                        viewModel.previousMonth()
                                    }
                                }
                            }
                    )
                    
                    Divider()
                        .padding(.top, 12)
                    
                    // MARK: - 5. Card Ngày Đang Chọn
                    if let selected = viewModel.selectedDayDetails {
                        selectedDayCard(selected)
                            .padding(.horizontal, 16)
                            .padding(.top, 10)
                    }
                } else {
                    // MARK: - 3. Agenda List View Mode
                    agendaListView
                }
                
                Spacer()
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showingYearGrid) {
                YearGridView(selectedYear: $viewModel.selectedYear) { month in
                    viewModel.jumpToMonth(month: month, year: viewModel.selectedYear)
                }
            }
            .sheet(isPresented: $showingSearch) {
                CalendarSearchView { date in
                    viewModel.selectedDate = date
                    viewModel.generateDays()
                }
            }
            .sheet(isPresented: $showingAddEvent) {
                AddEventView(initialDate: viewModel.selectedDate)
            }
            .sheet(isPresented: $showingDetailSheet) {
                if let day = viewModel.selectedDayDetails {
                    DayDetailView(day: day)
                }
            }
        }
    }
    
    // MARK: - Top Floating Capsule Toolbar (Matching User Mockup)
    private var topCapsuleToolbar: some View {
        HStack {
            // Left Pill: `< 2026`
            Button(action: {
                #if os(iOS)
                let impact = UIImpactFeedbackGenerator(style: .medium)
                impact.impactOccurred()
                #endif
                showingYearGrid = true
            }) {
                HStack(spacing: 6) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 14, weight: .bold))
                    Text("\(viewModel.selectedYear)")
                        .font(.system(size: 17, weight: .bold, design: .rounded))
                }
                .foregroundColor(.primary)
                .padding(.horizontal, 16)
                .padding(.vertical, 9)
                .background(Color(UIColor.secondarySystemGroupedBackground))
                .clipShape(Capsule())
                .shadow(color: Color.black.opacity(0.06), radius: 6, x: 0, y: 3)
            }
            
            Spacer()
            
            // Right Pill: `[List / Grid] [Search] [+]`
            HStack(spacing: 20) {
                // Toggle List/Grid View
                Button(action: {
                    #if os(iOS)
                    let impact = UIImpactFeedbackGenerator(style: .light)
                    impact.impactOccurred()
                    #endif
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                        displayMode = (displayMode == .grid) ? .list : .grid
                    }
                }) {
                    Image(systemName: displayMode == .grid ? "list.bullet.rectangle.portrait" : "calendar")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(displayMode == .list ? themeManager.selectedAccent.color : .primary)
                }
                
                // Search Button
                Button(action: {
                    showingSearch = true
                }) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.primary)
                }
                
                // Add Event (+) Button
                Button(action: {
                    showingAddEvent = true
                }) {
                    Image(systemName: "plus")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(themeManager.selectedAccent.color)
                }
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 9)
            .background(Color(UIColor.secondarySystemGroupedBackground))
            .clipShape(Capsule())
            .shadow(color: Color.black.opacity(0.06), radius: 6, x: 0, y: 3)
        }
    }
    
    // MARK: - Month Title Bar
    private var monthTitleBar: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 2) {
                Text(viewModel.currentMonthHeader)
                    .font(.system(size: 26, weight: .heavy, design: .rounded))
                
                if let selected = viewModel.selectedDayDetails {
                    Text("Năm \(selected.lunarDate.yearName) • Tháng \(selected.lunarDate.monthName)")
                        .font(.subheadline)
                        .foregroundColor(.vnGold)
                }
            }
            
            Spacer()
            
            HStack(spacing: 8) {
                Button(action: {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                        viewModel.previousMonth()
                    }
                }) {
                    Image(systemName: "chevron.left")
                        .font(.caption.bold())
                        .padding(8)
                        .background(Color.vnSurface)
                        .clipShape(Circle())
                }
                
                Button(action: {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                        viewModel.selectToday()
                    }
                }) {
                    Text(langManager.tr("Hôm nay", en: "Today"))
                        .font(.caption.bold())
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(themeManager.selectedAccent.color.opacity(0.14))
                        .foregroundColor(themeManager.selectedAccent.color)
                        .clipShape(Capsule())
                }
                
                Button(action: {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                        viewModel.nextMonth()
                    }
                }) {
                    Image(systemName: "chevron.right")
                        .font(.caption.bold())
                        .padding(8)
                        .background(Color.vnSurface)
                        .clipShape(Circle())
                }
            }
        }
    }
    
    // MARK: - Weekday Headers
    private var weekdayHeaderView: some View {
        let headers = langManager.selectedLanguage == .vietnamese ? weekdayHeadersVi : weekdayHeadersEn
        return HStack {
            ForEach(0..<7, id: \.self) { index in
                Text(headers[index])
                    .font(.system(size: 13, weight: .bold, design: .rounded))
                    .frame(maxWidth: .infinity)
                    .foregroundColor(index >= 5 ? themeManager.selectedAccent.color : .secondary)
            }
        }
    }
    
    // MARK: - Agenda List View Mode
    private var agendaListView: some View {
        ScrollView {
            LazyVStack(spacing: 10) {
                ForEach(viewModel.daysInMonth.filter { $0.isCurrentMonth }) { day in
                    let isToday = day.isToday
                    HStack(spacing: 14) {
                        // Date Badge
                        VStack(spacing: 2) {
                            Text("\(day.solarDay)")
                                .font(.system(size: 20, weight: .heavy, design: .rounded))
                                .foregroundColor(isToday ? .white : .primary)
                            Text(day.lunarDate.formattedShort)
                                .font(.system(size: 11, weight: .semibold))
                                .foregroundColor(isToday ? Color(hex: "#FEF08A") : Color.vnGold)
                        }
                        .frame(width: 52, height: 52)
                        .background(isToday ? themeManager.selectedAccent.color : Color.vnSurface)
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                        
                        // Event & Details
                        VStack(alignment: .leading, spacing: 4) {
                            Text(day.date.formattedVietnamese(dateStyle: .medium))
                                .font(.headline)
                            
                            if !day.holidays.isEmpty {
                                ForEach(day.holidays) { h in
                                    Text("🎉 \(h.name)")
                                        .font(.caption.bold())
                                        .foregroundColor(h.type.badgeColor)
                                }
                            } else {
                                Text("Can chi: \(day.lunarDate.dayName)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            viewModel.selectDay(day)
                            showingDetailSheet = true
                        }) {
                            Image(systemName: "chevron.right")
                                .font(.caption.bold())
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(12)
                    .background(Color(UIColor.secondarySystemGroupedBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .shadow(color: Color.black.opacity(0.03), radius: 4, x: 0, y: 2)
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
        }
    }
    
    // MARK: - Selected Day Card
    private func selectedDayCard(_ day: CalendarDay) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                VStack(alignment: .leading, spacing: 3) {
                    Text(day.date.formattedVietnamese(dateStyle: .full))
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                    
                    Text("Âm Lịch: \(day.lunarDate.formattedFull)")
                        .font(.subheadline)
                        .foregroundColor(.vnGold)
                }
                
                Spacer()
                
                Button(action: {
                    showingDetailSheet = true
                }) {
                    Text(langManager.tr("Chi tiết", en: "Details"))
                        .font(.subheadline.bold())
                        .padding(.horizontal, 14)
                        .padding(.vertical, 7)
                        .background(themeManager.selectedAccent.color)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                }
            }
            
            if let term = day.solarTerm {
                HStack {
                    Image(systemName: "leaf.fill")
                        .foregroundColor(.vnEmerald)
                    Text("Tiết khí: \(term.name)")
                        .font(.caption.bold())
                        .foregroundColor(.vnEmerald)
                }
            }
            
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
                                Text(langManager.tr("(Nghỉ lễ)", en: "(Day off)"))
                                    .font(.caption2.bold())
                                    .foregroundColor(.vnRed)
                            }
                        }
                    }
                }
            }
            
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
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 3)
    }
}
