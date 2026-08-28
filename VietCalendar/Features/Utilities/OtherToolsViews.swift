import SwiftUI

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
