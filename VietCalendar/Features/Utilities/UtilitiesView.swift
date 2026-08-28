import SwiftUI

public enum UtilityFeature: String, Identifiable, CaseIterable {
    case stopwatch = "Bấm giờ"
    case countdown = "Đếm ngược"
    case pomodoro = "Pomodoro"
    case worldClock = "Múi giờ"
    case dayCounter = "Đếm ngày"
    case lunarDetails = "Lịch âm"
    case convertDate = "Chuyển đổi âm/dương"
    case workdays = "Ngày làm việc"
    case weekNumber = "Tuần số"
    case quickNotes = "Ghi chú nhanh"
    case todoList = "Todo list"
    case birthday = "Sinh nhật"
    case reminder = "Nhắc nhở"
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
                Button("Đặt lại") { reset() }
                    .font(.headline)
                    .frame(width: 100, height: 45)
                    .background(Color.secondary.opacity(0.2))
                    .clipShape(Capsule())
                
                Button(isRunning ? "Dừng" : "Bắt đầu") { toggle() }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(width: 120, height: 45)
                    .background(isRunning ? Color.red : Color.orange)
                    .clipShape(Capsule())
            }
        }
        .padding()
    }
    
    private func toggle() {
        isRunning.toggle()
        if isRunning {
            timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in timeElapsed += 0.1 }
        } else { timer?.invalidate() }
    }
    
    private func reset() { timer?.invalidate(); isRunning = false; timeElapsed = 0 }
    
    private func timeString(time: Double) -> String {
        let m = Int(time) / 60
        let s = Int(time) % 60
        let t = Int((time.truncatingRemainder(dividingBy: 1)) * 10)
        return String(format: "%02d:%02d.%d", m, s, t)
    }
}

struct CountdownView: View {
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
            
            Button(isRunning ? "Tạm dừng" : "Bắt đầu đếm") {
                isRunning.toggle()
                if isRunning {
                    timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                        if secondsRemaining > 0 { secondsRemaining -= 1 }
                        else { isRunning = false; timer?.invalidate() }
                    }
                } else { timer?.invalidate() }
            }
            .font(.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.orange)
            .clipShape(RoundedRectangle(cornerRadius: 14))
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
            Text("Phiên tập trung 25 phút Pomodoro").font(.subheadline).foregroundColor(.secondary)
            
            Button(isRunning ? "Tạm dừng" : "Bắt đầu tập trung") {
                isRunning.toggle()
                if isRunning {
                    timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                        if secondsRemaining > 0 { secondsRemaining -= 1 }
                    }
                } else { timer?.invalidate() }
            }
            .font(.headline.bold())
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.red)
            .clipShape(RoundedRectangle(cornerRadius: 14))
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
        }
    }
    private func timeRow(city: String, offset: String) -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text(city).font(.headline)
                Text(offset).font(.caption).foregroundColor(.secondary)
            }
            Spacer()
            Text(Date(), style: .time).font(.title2.bold())
        }
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
                Text("\(workdays)").font(.system(size: 56, weight: .black, design: .rounded)).foregroundColor(.blue)
                Text("Ngày làm việc thực tế (trừ T7, CN)").font(.subheadline).foregroundColor(.secondary)
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
            if !cal.isDateInWeekend(current) { count += 1 }
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
            Text("Tuần thứ").font(.headline).foregroundColor(.secondary)
            Text("\(week)").font(.system(size: 72, weight: .black, design: .rounded)).foregroundColor(.blue)
            Text("Trong tổng số 52 tuần của năm 2026").font(.subheadline).foregroundColor(.secondary)
        }
        .padding()
    }
}

struct NoteItem: Identifiable, Codable {
    public var id = UUID()
    public var content: String
    public var date = Date()
}

struct QuickNotesView: View {
    @State private var noteText = ""
    @State private var savedNotes: [NoteItem] = []
    
    var body: some View {
        VStack(spacing: 14) {
            VStack(alignment: .trailing, spacing: 8) {
                TextEditor(text: $noteText)
                    .frame(height: 110)
                    .padding(8)
                    .background(Color(UIColor.secondarySystemGroupedBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                
                Button(action: saveNote) {
                    HStack(spacing: 6) {
                        Image(systemName: "square.and.arrow.down.fill")
                        Text("Lưu Ghi Chú")
                    }
                    .font(.subheadline.bold())
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(noteText.trimmingCharacters(in: .whitespaces).isEmpty ? Color.gray : Color.purple)
                    .clipShape(Capsule())
                }
                .disabled(noteText.trimmingCharacters(in: .whitespaces).isEmpty)
            }
            .padding(.horizontal)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("GHI CHÚ ĐÃ LƯU (\(savedNotes.count))")
                    .font(.caption.bold())
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
                
                List {
                    ForEach(savedNotes) { note in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(note.content).font(.body)
                            Text(note.date.formatted(date: .abbreviated, time: .shortened))
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 4)
                    }
                    .onDelete(perform: deleteNote)
                }
            }
        }
        .padding(.top, 10)
        .onAppear(perform: loadNotes)
    }
    
    private func saveNote() {
        guard !noteText.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        let newNote = NoteItem(content: noteText)
        savedNotes.insert(newNote, at: 0)
        noteText = ""
        persistNotes()
    }
    
    private func deleteNote(at offsets: IndexSet) {
        savedNotes.remove(atOffsets: offsets)
        persistNotes()
    }
    
    private func loadNotes() {
        if let data = UserDefaults.standard.data(forKey: "saved_notes_data"),
           let decoded = try? JSONDecoder().decode([NoteItem].self, from: data) {
            savedNotes = decoded
        } else {
            savedNotes = [
                NoteItem(content: "Mua vàng ngày Thần Tài mùng 10 tháng Giêng"),
                NoteItem(content: "Chuẩn bị mâm cúng rằm tháng 7")
            ]
        }
    }
    
    private func persistNotes() {
        if let encoded = try? JSONEncoder().encode(savedNotes) {
            UserDefaults.standard.set(encoded, forKey: "saved_notes_data")
        }
    }
}

struct TodoListView: View {
    @State private var items = ["Thắp hương ngày Rằm", "Chuẩn bị lễ Vu Lan", "Xem ngày tốt khai trương"]
    @State private var completedItems: Set<String> = ["Xem ngày tốt khai trương"]
    @State private var newItem = ""
    
    var body: some View {
        VStack {
            HStack {
                TextField("Thêm việc cần làm...", text: $newItem)
                    .padding(10)
                    .background(Color(UIColor.secondarySystemGroupedBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                Button("Thêm") {
                    if !newItem.trimmingCharacters(in: .whitespaces).isEmpty {
                        items.append(newItem)
                        newItem = ""
                    }
                }
                .font(.headline)
                .foregroundColor(.purple)
            }
            .padding(.horizontal)
            .padding(.top, 10)
            
            List {
                ForEach(items, id: \.self) { item in
                    let isDone = completedItems.contains(item)
                    Button(action: {
                        if isDone { completedItems.remove(item) }
                        else { completedItems.insert(item) }
                    }) {
                        HStack(spacing: 12) {
                            Image(systemName: isDone ? "checkmark.circle.fill" : "circle")
                                .font(.title3)
                                .foregroundColor(isDone ? .purple : .secondary)
                            Text(item)
                                .strikethrough(isDone, color: .secondary)
                                .foregroundColor(isDone ? .secondary : .primary)
                        }
                    }
                    .buttonStyle(.plain)
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
                HStack(spacing: 14) {
                    ZStack {
                        Circle().fill(Color.purple.opacity(0.15)).frame(width: 44, height: 44)
                        Image(systemName: "gift.fill").foregroundColor(.purple)
                    }
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Mẹ - Sinh nhật Âm Lịch").font(.headline)
                        Text("15/07 Âm Lịch (Vu Lan) • Tuổi Quý Mão").font(.caption).foregroundColor(.secondary)
                    }
                    Spacer()
                    Text("Còn 14 ngày")
                        .font(.caption2.bold())
                        .foregroundColor(.purple)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.purple.opacity(0.12))
                        .clipShape(Capsule())
                }
            }
        }
    }
}

// MARK: - Full Working iOS Calculator Keypad
struct MiniCalculatorView: View {
    @State private var display = "0"
    @State private var currentVal: Double = 0
    @State private var pendingOp: String? = nil
    @State private var isTypingNewNumber = true
    
    private let buttons: [[String]] = [
        ["AC", "+/-", "%", "÷"],
        ["7", "8", "9", "×"],
        ["4", "5", "6", "-"],
        ["1", "2", "3", "+"],
        ["0", ".", "="]
    ]
    
    var body: some View {
        VStack(spacing: 12) {
            Spacer()
            
            Text(display)
                .font(.system(size: 60, weight: .light, design: .rounded))
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.horizontal, 24)
                .lineLimit(1)
                .minimumScaleFactor(0.4)
            
            VStack(spacing: 10) {
                ForEach(buttons, id: \.self) { row in
                    HStack(spacing: 10) {
                        ForEach(row, id: \.self) { btn in
                            calcButton(btn)
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 20)
        }
        .background(Color(UIColor.systemBackground))
    }
    
    private func calcButton(_ text: String) -> some View {
        Button(action: { buttonPressed(text) }) {
            Text(text)
                .font(.system(size: text.count > 1 ? 22 : 28, weight: .medium))
                .foregroundColor(buttonTextColor(text))
                .frame(maxWidth: text == "0" ? .infinity : 72)
                .frame(height: 72)
                .background(buttonBgColor(text))
                .clipShape(RoundedRectangle(cornerRadius: 36, style: .continuous))
        }
    }
    
    private func buttonPressed(_ text: String) {
        #if os(iOS)
        let impact = UIImpactFeedbackGenerator(style: .light)
        impact.impactOccurred()
        #endif
        
        switch text {
        case "0"..."9":
            if isTypingNewNumber || display == "0" {
                display = text
                isTypingNewNumber = false
            } else {
                display += text
            }
        case ".":
            if isTypingNewNumber {
                display = "0."
                isTypingNewNumber = false
            } else if !display.contains(".") {
                display += "."
            }
        case "AC":
            display = "0"
            currentVal = 0
            pendingOp = nil
            isTypingNewNumber = true
        case "+/-":
            if let val = Double(display) { display = formatNumber(-val) }
        case "%":
            if let val = Double(display) { display = formatNumber(val / 100) }
        case "+", "-", "×", "÷":
            if let val = Double(display) {
                currentVal = val
                pendingOp = text
                isTypingNewNumber = true
            }
        case "=":
            if let op = pendingOp, let secondVal = Double(display) {
                var res: Double = 0
                switch op {
                case "+": res = currentVal + secondVal
                case "-": res = currentVal - secondVal
                case "×": res = currentVal * secondVal
                case "÷": res = secondVal != 0 ? currentVal / secondVal : 0
                default: break
                }
                display = formatNumber(res)
                pendingOp = nil
                isTypingNewNumber = true
            }
        default: break
        }
    }
    
    private func formatNumber(_ num: Double) -> String {
        if num.truncatingRemainder(dividingBy: 1) == 0 && num < 1e9 && num > -1e9 {
            return "\(Int(num))"
        }
        return String(format: "%.4g", num)
    }
    
    private func buttonBgColor(_ text: String) -> Color {
        if text == "+" || text == "-" || text == "×" || text == "÷" || text == "=" { return .orange }
        if text == "AC" || text == "+/-" || text == "%" { return Color(UIColor.systemGray4) }
        return Color(UIColor.systemGray5)
    }
    
    private func buttonTextColor(_ text: String) -> Color {
        if text == "+" || text == "-" || text == "×" || text == "÷" || text == "=" { return .white }
        return .primary
    }
}

struct WeatherInfoView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "cloud.sun.rain.fill").font(.system(size: 64)).foregroundColor(Color.vnEmerald)
            Text("29°C • Việt Nam").font(.system(size: 32, weight: .bold, design: .rounded))
            Text("Mùa Thu • Tiết Xử Thử (Trời mát mẻ, có mưa rào nhẹ)").font(.subheadline).foregroundColor(.secondary)
            Divider()
            VStack(alignment: .leading, spacing: 10) {
                Text("Dự Báo & Khí Hậu Theo Tiết Khí:").font(.headline)
                Text("• Miền Bắc: Gió heo may, sáng sớm se lạnh, đêm mát mẻ.")
                Text("• Miền Trung: Nắng hanh xen kẽ mưa dông chiều tối.")
                Text("• Miền Nam: Mùa mưa nhiệt đới, triều cường rằm tháng 7.")
            }
            .font(.caption)
            .padding()
            .background(Color(UIColor.secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 14))
        }
        .padding()
    }
}

struct ExportCalendarView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "square.and.arrow.up.fill").font(.system(size: 54)).foregroundColor(Color.vnEmerald)
            Text("Xuất File Lịch (.ICS)").font(.title2.bold())
            Text("Đồng bộ toàn bộ ngày giỗ, tết, sự kiện vào ứng dụng Lịch mặc định của Apple.").font(.subheadline).multilineTextAlignment(.center).foregroundColor(.secondary)
            Button("Xuất file .ics ngay") {}
                .font(.headline).foregroundColor(.white).padding().frame(maxWidth: .infinity).background(Color.vnEmerald).clipShape(RoundedRectangle(cornerRadius: 14))
        }
        .padding(24)
    }
}

struct ShareCalendarView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "paperplane.fill").font(.system(size: 54)).foregroundColor(Color.vnEmerald)
            Text("Chia Sẻ Thiệp Lịch Âm").font(.title2.bold())
            Text("Tạo ảnh thiệp chúc mừng ngày lễ, rằm, mùng 1 gửi tặng bạn bè qua Zalo, Messenger.").font(.subheadline).multilineTextAlignment(.center).foregroundColor(.secondary)
        }
        .padding(24)
    }
}