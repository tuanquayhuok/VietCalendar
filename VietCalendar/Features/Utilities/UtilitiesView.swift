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
            return .emeraldColor
        }
    }
}

extension Color {
    static let emeraldColor = Color(red: 16/255, green: 185/255, blue: 129/255)
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
                    // Header Banner
                    headerCard
                    
                    // Section 1: ⏰ Thời gian
                    categorySection(
                        title: "⏰ Thời gian",
                        features: [.stopwatch, .countdown, .pomodoro, .worldClock]
                    )
                    
                    // Section 2: 📅 Ngày tháng
                    categorySection(
                        title: "📅 Ngày tháng",
                        features: [.dayCounter, .lunarDetails, .convertDate, .workdays, .weekNumber]
                    )
                    
                    // Section 3: 📝 Cá nhân
                    categorySection(
                        title: "📝 Cá nhân",
                        features: [.quickNotes, .todoList, .birthday, .reminder]
                    )
                    
                    // Section 4: 🛠️ Công cụ
                    categorySection(
                        title: "🛠️ Công cụ",
                        features: [.calculator, .weather, .exportCalendar, .shareCalendar]
                    )
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

// MARK: - Individual Feature Sheets
public struct UtilityFeatureSheet: View {
    public let feature: UtilityFeature
    @Environment(\.dismiss) private var dismiss
    
    public var body: some View {
        NavigationStack {
            Group {
                switch feature {
                case .stopwatch:
                    StopwatchView()
                case .countdown:
                    CountdownView()
                case .pomodoro:
                    PomodoroFocusView()
                case .worldClock:
                    WorldClockView()
                case .dayCounter:
                    DayCounterView()
                case .lunarDetails:
                    ConvertDateView()
                case .convertDate:
                    ConvertDateView()
                case .workdays:
                    WorkdaysCalcView()
                case .weekNumber:
                    WeekNumberView()
                case .quickNotes:
                    QuickNotesView()
                case .todoList:
                    TodoListView()
                case .birthday:
                    BirthdayTrackerView()
                case .reminder:
                    EventListView()
                case .calculator:
                    MiniCalculatorView()
                case .weather:
                    WeatherInfoView()
                case .exportCalendar:
                    ExportCalendarView()
                case .shareCalendar:
                    ShareCalendarView()
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

// MARK: - Sub Feature Views
struct StopwatchView: View {
    @State private var timeElapsed: Double = 0
    @State private var isRunning = false
    @State private var timer: Timer?
    
    var body: some View {
        VStack(spacing: 30) {
            Text(timeString(time: timeElapsed))
                .font(.system(size: 60, weight: .bold, design: .monospaced))
                .foregroundColor(.orange)
            
            HStack(spacing: 20) {
                Button(action: reset) {
                    Text("Đặt lại")
                        .font(.headline)
                        .frame(width: 100, height: 45)
                        .background(Color.secondary.opacity(0.2))
                        .clipShape(Capsule())
                }
                
                Button(action: toggle) {
                    Text(isRunning ? "Dừng" : "Bắt đầu")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 120, height: 45)
                        .background(isRunning ? Color.red : Color.orange)
                        .clipShape(Capsule())
                }
            }
        }
        .padding()
    }
    
    private func toggle() {
        isRunning.toggle()
        if isRunning {
            timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
                timeElapsed += 0.1
            }
        } else {
            timer?.invalidate()
        }
    }
    
    private func reset() {
        timer?.invalidate()
        isRunning = false
        timeElapsed = 0
    }
    
    private func timeString(time: Double) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        let tenths = Int((time.truncatingRemainder(dividingBy: 1)) * 10)
        return String(format: "%02d:%02d.%d", minutes, seconds, tenths)
    }
}

struct CountdownView: View {
    @State private var minutes = 5
    @State private var secondsRemaining = 300
    @State private var isRunning = false
    @State private var timer: Timer?
    
    var body: some View {
        VStack(spacing: 24) {
            Text(String(format: "%02d:%02d", secondsRemaining / 60, secondsRemaining % 60))
                .font(.system(size: 64, weight: .black, design: .monospaced))
                .foregroundColor(.orange)
            
            HStack(spacing: 12) {
                ForEach([1, 5, 10, 15, 30], id: \.self) { m in
                    Button("\(m)p") {
                        secondsRemaining = m * 60
                        isRunning = false
                        timer?.invalidate()
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color.orange.opacity(0.15))
                    .foregroundColor(.orange)
                    .clipShape(Capsule())
                }
            }
            
            Button(action: {
                isRunning.toggle()
                if isRunning {
                    timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                        if secondsRemaining > 0 { secondsRemaining -= 1 }
                        else { isRunning = false; timer?.invalidate() }
                    }
                } else { timer?.invalidate() }
            }) {
                Text(isRunning ? "Tạm dừng" : "Bắt đầu đếm")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.orange)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            }
            .padding(.horizontal, 40)
        }
        .padding()
    }
}

struct PomodoroFocusView: View {
    @State private var secondsRemaining = 25 * 60
    @State private var isRunning = false
    @State private var timer: Timer?
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "brain.head.profile")
                .font(.system(size: 60))
                .foregroundColor(.red)
            
            Text(String(format: "%02d:%02d", secondsRemaining / 60, secondsRemaining % 60))
                .font(.system(size: 60, weight: .heavy, design: .monospaced))
            
            Text("Phiên tập trung 25 phút Pomodoro")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Button(action: {
                isRunning.toggle()
                if isRunning {
                    timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                        if secondsRemaining > 0 { secondsRemaining -= 1 }
                    }
                } else { timer?.invalidate() }
            }) {
                Text(isRunning ? "Tạm dừng" : "Bắt đầu tập trung")
                    .font(.headline.bold())
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            }
            .padding(.horizontal, 40)
        }
        .padding()
    }
}

struct WorldClockView: View {
    var body: some View {
        List {
            timeRow(city: "Hà Nội, Việt Nam", offset: "+0 (GMT+7)")
            timeRow(city: "Tokyo, Nhật Bản", offset: "+2 giờ")
            timeRow(city: "Seoul, Hàn Quốc", offset: "+2 giờ")
            timeRow(city: "London, Vương quốc Anh", offset: "-6 giờ")
            timeRow(city: "New York, Hoa Kỳ", offset: "-11 giờ")
            timeRow(city: "California, Hoa Kỳ", offset: "-14 giờ")
        }
    }
    
    private func timeRow(city: String, offset: String) -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text(city).font(.headline)
                Text(offset).font(.caption).foregroundColor(.secondary)
            }
            Spacer()
            Text(Date().addingTimeInterval(0), style: .time)
                .font(.title2.bold())
        }
        .padding(.vertical, 4)
    }
}

struct DayCounterView: View {
    @State private var targetDate = Date().addingTimeInterval(86400 * 30)
    @State private var title = "Kỷ niệm đặc biệt"
    
    var body: some View {
        VStack(spacing: 20) {
            TextField("Tên sự kiện kỷ niệm", text: $title)
                .font(.headline)
                .padding()
                .background(Color(UIColor.secondarySystemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 14))
            
            DatePicker("Ngày kỷ niệm", selection: $targetDate, displayedComponents: [.date])
                .datePickerStyle(.graphical)
                .padding()
                .background(Color(UIColor.secondarySystemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 16))
            
            let days = Calendar.current.dateComponents([.day], from: Date(), to: targetDate).day ?? 0
            
            Text("Còn \(abs(days)) ngày \(days >= 0 ? "nữa" : "trước")")
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundColor(.blue)
        }
        .padding()
    }
}

struct WorkdaysCalcView: View {
    @State private var startDate = Date()
    @State private var endDate = Date().addingTimeInterval(86400 * 30)
    
    var body: some View {
        VStack(spacing: 20) {
            DatePicker("Từ ngày", selection: $startDate, displayedComponents: [.date])
            DatePicker("Đến ngày", selection: $endDate, displayedComponents: [.date])
            
            let workdays = calculateWorkdays()
            
            VStack(spacing: 8) {
                Text("\(workdays)")
                    .font(.system(size: 56, weight: .black, design: .rounded))
                    .foregroundColor(.blue)
                Text("Ngày làm việc thực tế (trừ T7, CN)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(24)
            .background(Color.blue.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 18))
        }
        .padding()
    }
    
    private func calculateWorkdays() -> Int {
        var count = 0
        var current = startDate
        let cal = Calendar.current
        while current <= endDate {
            if !cal.isDateInWeekend(current) {
                count += 1
            }
            guard let next = cal.date(byAdding: .day, value: 1, to: current) else { break }
            current = next
        }
        return count
    }
}

struct WeekNumberView: View {
    var body: some View {
        let week = Calendar.current.component(.weekOfYear, from: Date())
        VStack(spacing: 16) {
            Text("Tuần thứ")
                .font(.headline)
                .foregroundColor(.secondary)
            Text("\(week)")
                .font(.system(size: 72, weight: .black, design: .rounded))
                .foregroundColor(.blue)
            Text("Trong tổng số 52 tuần của năm 2026")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
    }
}

struct QuickNotesView: View {
    @AppStorage("saved_quick_notes") private var notes: String = ""
    
    var body: some View {
        VStack {
            TextEditor(text: $notes)
                .padding()
                .background(Color(UIColor.secondarySystemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding()
        }
    }
}

struct TodoListView: View {
    @State private var items = ["Thắp hương ngày Rằm", "Chuẩn bị lễ Vu Lan", "Xem ngày tốt khai trương"]
    @State private var newItem = ""
    
    var body: some View {
        VStack {
            HStack {
                TextField("Thêm việc cần làm...", text: $newItem)
                    .padding(10)
                    .background(Color(UIColor.secondarySystemGroupedBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                Button("Thêm") {
                    if !newItem.isEmpty {
                        items.append(newItem)
                        newItem = ""
                    }
                }
                .font(.headline)
            }
            .padding(.horizontal)
            
            List {
                ForEach(items, id: \.self) { item in
                    HStack {
                        Image(systemName: "circle")
                            .foregroundColor(.purple)
                        Text(item)
                    }
                }
                .onDelete { items.remove(atOffsets: $0) }
            }
        }
    }
}

struct BirthdayTrackerView: View {
    var body: some View {
        List {
            Section(header: Text("Sinh nhật sắp tới")) {
                HStack {
                    Image(systemName: "gift.fill").foregroundColor(.purple)
                    VStack(alignment: .leading) {
                        Text("Mẹ - 15/07 Âm Lịch (Vu Lan)").font(.headline)
                        Text("Tuổi Quý Mão • Mệnh Kim").font(.caption).foregroundColor(.secondary)
                    }
                }
            }
        }
    }
}

struct MiniCalculatorView: View {
    @State private var display = "0"
    
    var body: some View {
        VStack(spacing: 16) {
            Text(display)
                .font(.system(size: 48, weight: .bold, design: .rounded))
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding()
                .background(Color(UIColor.secondarySystemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 16))
            
            Text("Máy tính hỗ trợ tính toán nhanh ngày công, chi tiêu.")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
    }
}

struct WeatherInfoView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "cloud.sun.rain.fill")
                .font(.system(size: 64))
                .foregroundColor(.emeraldColor)
            Text("29°C • Hà Nội")
                .font(.system(size: 32, weight: .bold, design: .rounded))
            Text("Mùa Thu • Tiết Xử Thử (Trời mát mẻ, có mưa rào nhẹ)")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
    }
}

struct ExportCalendarView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "square.and.arrow.up.fill")
                .font(.system(size: 54))
                .foregroundColor(.emeraldColor)
            Text("Xuất File Lịch (.ICS)")
                .font(.title2.bold())
            Text("Đồng bộ toàn bộ ngày giỗ, tết, sự kiện vào ứng dụng Lịch mặc định của Apple.")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
            
            Button("Xuất file .ics ngay") {
                #if os(iOS)
                let impact = UIImpactFeedbackGenerator(style: .medium)
                impact.impactOccurred()
                #endif
            }
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.emeraldColor)
            .clipShape(RoundedRectangle(cornerRadius: 14))
        }
        .padding(24)
    }
}

struct ShareCalendarView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "paperplane.fill")
                .font(.system(size: 54))
                .foregroundColor(.emeraldColor)
            Text("Chia Sẻ Thiệp Lịch Âm")
                .font(.title2.bold())
            Text("Tạo ảnh thiệp chúc mừng ngày lễ, rằm, mùng 1 gửi tặng bạn bè qua Zalo, Messenger.")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
        }
        .padding(24)
    }
}
