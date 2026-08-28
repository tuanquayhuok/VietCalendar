import SwiftUI

public enum CalendarViewStyle: String, CaseIterable {
    case compact = "Nhỏ gọn"
    case stacked = "Xếp chồng"
    case detailed = "Chi tiết"
    case list = "Danh sách"
}

public enum CalendarActiveSheet: Identifiable {
    case yearGrid
    case search
    case addEvent
    case editEvent(UserEvent)
    case dayDetail(CalendarDay)
    
    public var id: String {
        switch self {
        case .yearGrid: return "yearGrid"
        case .search: return "search"
        case .addEvent: return "addEvent"
        case .editEvent(let ev): return "editEvent_\(ev.id)"
        case .dayDetail(let day): return "dayDetail_\(day.id)"
        }
    }
}

public struct CalendarView: View {
    @StateObject private var viewModel = CalendarViewModel()
    @ObservedObject private var themeManager = ThemeManager.shared
    @ObservedObject private var langManager = LanguageManager.shared
    @ObservedObject private var eventService = EventService.shared
    
    @State private var viewStyle: CalendarViewStyle = .detailed
    @State private var activeSheet: CalendarActiveSheet? = nil
    
    public init() {}
    
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 4), count: 7)
    private let weekdayHeadersVi = ["T2", "T3", "T4", "T5", "T6", "T7", "CN"]
    private let weekdayHeadersEn = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    
    public var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // MARK: - 1. Top Modern Floating Capsule Toolbar
                topCapsuleToolbar
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                
                // MARK: - 2. Month Title & Controls
                monthTitleBar
                    .padding(.horizontal, 16)
                    .padding(.top, 12)
                
                if viewStyle != .list {
                    // MARK: - 3. Weekday Header
                    weekdayHeaderView
                        .padding(.horizontal, 14)
                        .padding(.top, 10)
                    
                    // MARK: - 4. 42-Day Month Grid
                    LazyVGrid(columns: columns, spacing: viewStyle == .compact ? 2 : 6) {
                        ForEach(viewModel.daysInMonth) { day in
                            DayCellView(
                                day: day,
                                isSelected: Calendar.current.isDate(day.date, inSameDayAs: viewModel.selectedDate)
                            ) {
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
                    
                    if viewStyle == .detailed {
                        Divider()
                            .padding(.top, 10)
                        
                        if let selected = viewModel.selectedDayDetails {
                            selectedDayCard(selected)
                                .padding(.horizontal, 16)
                                .padding(.top, 8)
                        }
                    }
                } else {
                    agendaListView
                }
                
                Spacer()
            }
            .navigationBarHidden(true)
            .sheet(item: $activeSheet) { sheet in
                switch sheet {
                case .yearGrid:
                    YearGridView(selectedYear: $viewModel.selectedYear) { month in
                        viewModel.jumpToMonth(month: month, year: viewModel.selectedYear)
                    }
                case .search:
                    CalendarSearchView { date in
                        viewModel.selectedDate = date
                        viewModel.generateDays()
                    }
                case .addEvent:
                    AddEventView(initialDate: viewModel.selectedDate, editingEvent: nil)
                case .editEvent(let ev):
                    AddEventView(initialDate: ev.solarDate, editingEvent: ev)
                case .dayDetail(let day):
                    DayDetailView(day: day)
                }
            }
        }
    }
    
    // MARK: - Top Floating Capsule Toolbar
    private var topCapsuleToolbar: some View {
        HStack {
            Button(action: {
                #if os(iOS)
                let impact = UIImpactFeedbackGenerator(style: .medium)
                impact.impactOccurred()
                #endif
                activeSheet = .yearGrid
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
            
            HStack(spacing: 18) {
                Menu {
                    Button(action: { viewStyle = .compact }) {
                        Label("Nhỏ gọn", systemImage: "rectangle.compress.vertical")
                    }
                    Button(action: { viewStyle = .stacked }) {
                        Label("Xếp chồng", systemImage: "square.stack.3d.up")
                    }
                    Button(action: { viewStyle = .detailed }) {
                        Label("Chi tiết", systemImage: "rectangle.stack")
                    }
                    Divider()
                    Button(action: { viewStyle = .list }) {
                        Label("Danh sách", systemImage: "list.bullet")
                    }
                } label: {
                    Image(systemName: "list.bullet.rectangle.portrait")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.primary)
                }
                
                Button(action: { activeSheet = .search }) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.primary)
                }
                
                Button(action: { activeSheet = .addEvent }) {
                    Image(systemName: "plus")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(.primary)
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
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) { viewModel.previousMonth() }
                }) {
                    Image(systemName: "chevron.left")
                        .font(.caption.bold())
                        .padding(8)
                        .background(Color.vnSurface)
                        .clipShape(Circle())
                }
                
                Button(action: {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) { viewModel.selectToday() }
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
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) { viewModel.nextMonth() }
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
    private var activeWeekdayHeaders: [String] {
        langManager.selectedLanguage == .vietnamese ? weekdayHeadersVi : weekdayHeadersEn
    }
    
    private var weekdayHeaderView: some View {
        HStack {
            ForEach(0..<7, id: \.self) { index in
                Text(activeWeekdayHeaders[index])
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
                    HStack(spacing: 14) {
                        VStack(spacing: 2) {
                            Text("\(day.solarDay)")
                                .font(.system(size: 20, weight: .heavy, design: .rounded))
                                .foregroundColor(day.isToday ? .white : .primary)
                            Text(day.lunarDate.formattedShort)
                                .font(.system(size: 11, weight: .semibold))
                                .foregroundColor(day.isToday ? Color(hex: "#FEF08A") : Color.vnGold)
                        }
                        .frame(width: 52, height: 52)
                        .background(day.isToday ? themeManager.selectedAccent.color : Color.vnSurface)
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                        
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
                            activeSheet = .dayDetail(day)
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
                    activeSheet = .dayDetail(day)
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
                VStack(alignment: .leading, spacing: 6) {
                    Text("SỰ KIỆN (Nhấn giữ để sửa/xóa):")
                        .font(.caption2.bold())
                        .foregroundColor(.secondary)
                    
                    ForEach(day.events) { event in
                        HStack {
                            Circle()
                                .fill(Color(hex: event.colorHex))
                                .frame(width: 8, height: 8)
                            Text(event.title)
                                .font(.subheadline)
                            Spacer()
                            Text(event.repeatType.rawValue)
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                        .padding(8)
                        .background(Color(UIColor.tertiarySystemGroupedBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .contentShape(Rectangle())
                        .contextMenu {
                            Button(action: {
                                activeSheet = .editEvent(event)
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
        }
        .padding(14)
        .background(Color.vnSurface)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 3)
    }
}
