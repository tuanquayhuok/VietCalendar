import SwiftUI

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
