import SwiftUI

public enum UtilityFeature: String, Identifiable, CaseIterable {
    // ⏰ Thời gian
    case stopwatch = "Bấm giờ"
    case countdown = "Đếm ngược"
    case pomodoro = "Pomodoro"
    case worldClock = "Múi giờ"
    
    // 📅 Ngày tháng
    case dayCounter = "Đếm ngày"
    case lunarDetails = "Lịch âm"
    case convertDate = "Chuyển đổi âm/dương"
    case workdays = "Ngày làm việc"
    case weekNumber = "Tuần số"
    
    // 📝 Cá nhân
    case quickNotes = "Ghi chú nhanh"
    case todoList = "Todo list"
    case birthday = "Sinh nhật"
    case reminder = "Nhắc nhở"
    
    // 🛠️ Công cụ
    case calculator = "Máy tính"
    case weather = "Thời tiết"
    case exportCalendar = "Xuất lịch"
    case shareCalendar = "Chia sẻ lịch"
    
    public var id: String { self.rawValue }
    
    public var icon: String {
        switch self {
        case .stopwatch: return "stopwatch"
        case .countdown: return "timer"
        case .pomodoro: return "brain.head.profile"
        case .worldClock: return "globe.asia.australia.fill"
            
        case .dayCounter: return "heart.text.square.fill"
        case .lunarDetails: return "moon.stars.fill"
        case .convertDate: return "arrow.left.arrow.right"
        case .workdays: return "briefcase.fill"
        case .weekNumber: return "calendar.badge.clock"
            
        case .quickNotes: return "note.text"
        case .todoList: return "checklist"
        case .birthday: return "gift.fill"
        case .reminder: return "bell.badge.fill"
            
        case .calculator: return "plus.slash.minus"
        case .weather: return "cloud.sun.rain.fill"
        case .exportCalendar: return "square.and.arrow.up.fill"
        case .shareCalendar: return "paperplane.fill"
        }
    }
    
    public var color: Color {
        switch self {
        case .stopwatch, .countdown, .pomodoro, .worldClock:
            return .orange
        case .dayCounter, .lunarDetails, .convertDate, .workdays, .weekNumber:
            return .blue
        case .quickNotes, .todoList, .birthday, .reminder:
            return .purple
        case .calculator, .weather, .exportCalendar, .shareCalendar:
            return Color.vnEmerald
        }
    }
}

public struct UtilitiesView: View {
    @ObservedObject private var themeManager = ThemeManager.shared
    @ObservedObject private var langManager = LanguageManager.shared
    @State private var selectedFeature: UtilityFeature? = nil
    
    public init() {}
    
    private let columns = [
        GridItem(.flexible(), spacing: 14),
        GridItem(.flexible(), spacing: 14)
    ]
    
    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    headerCard
                    categorySection(title: "⏰ Thời gian", features: [.stopwatch, .countdown, .pomodoro, .worldClock])
                    categorySection(title: "📅 Ngày tháng", features: [.dayCounter, .lunarDetails, .convertDate, .workdays, .weekNumber])
                    categorySection(title: "📝 Cá nhân", features: [.quickNotes, .todoList, .birthday, .reminder])
                    categorySection(title: "🛠️ Công cụ", features: [.calculator, .weather, .exportCalendar, .shareCalendar])
                }
                .padding(16)
            }
            .background(Color(UIColor.systemGroupedBackground))
            .navigationTitle("Tiện Ích")
            .navigationBarTitleDisplayMode(.large)
            .sheet(item: $selectedFeature) { feat in
                UtilityFeatureSheet(feature: feat)
            }
        }
    }
    
    private var headerCard: some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                Text("Bộ Công Cụ Tiện Ích")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                Text("Quản lý thời gian, ngày âm dương, công việc và cuộc sống hàng ngày.")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
            Image(systemName: "sparkles.square.filled.on.square")
                .font(.system(size: 38))
                .foregroundColor(themeManager.selectedAccent.color)
        }
        .padding(18)
        .background(Color(UIColor.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 3)
    }
    
    private func categorySection(title: String, features: [UtilityFeature]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.system(size: 17, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
                .padding(.leading, 4)
            
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(features) { feat in
                    Button(action: {
                        #if os(iOS)
                        let impact = UIImpactFeedbackGenerator(style: .light)
                        impact.impactOccurred()
                        #endif
                        selectedFeature = feat
                    }) {
                        HStack(spacing: 12) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .fill(feat.color.opacity(0.15))
                                    .frame(width: 42, height: 42)
                                Image(systemName: feat.icon)
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(feat.color)
                            }
                            Text(feat.rawValue)
                                .font(.system(size: 14, weight: .semibold, design: .rounded))
                                .foregroundColor(.primary)
                                .lineLimit(1)
                            Spacer()
                        }
                        .padding(12)
                        .background(Color(UIColor.secondarySystemGroupedBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .shadow(color: Color.black.opacity(0.03), radius: 4, x: 0, y: 2)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}

public struct UtilityFeatureSheet: View {
    public let feature: UtilityFeature
    @Environment(\.dismiss) private var dismiss
    
    public var body: some View {
        NavigationStack {
            Group {
                switch feature {
                case .stopwatch: StopwatchView()
                case .countdown: CountdownView()
                case .pomodoro: PomodoroFocusView()
                case .worldClock: WorldClockView()
                case .dayCounter: DayCounterView()
                case .lunarDetails, .convertDate: ConvertDateView()
                case .workdays: WorkdaysCalcView()
                case .weekNumber: WeekNumberView()
                case .quickNotes: QuickNotesView()
                case .todoList: TodoListView()
                case .birthday: BirthdayTrackerView()
                case .reminder: EventListView()
                case .calculator: MiniCalculatorView()
                case .weather: WeatherInfoView()
                case .exportCalendar: ExportCalendarView()
                case .shareCalendar: ShareCalendarView()
                }
            }
            .navigationTitle(feature.rawValue)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Đóng") { dismiss() }
                }
            }
        }
    }
}
