import SwiftUI

public struct AddEventView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var eventService = EventService.shared
    
    @State private var title: String = ""
    @State private var notes: String = ""
    @State private var solarDate: Date
    @State private var isLunarBased: Bool = false
    @State private var lunarDay: Int = 1
    @State private var lunarMonth: Int = 1
    @State private var repeatType: EventRepeatType = .none
    @State private var selectedColorHex: String = "#DC2626"
    @State private var hasReminder: Bool = false
    
    private let availableColors = ["#DC2626", "#F59E0B", "#10B981", "#2563EB", "#8B5CF6", "#EC4899"]
    
    public init(initialDate: Date = Date()) {
        _solarDate = State(initialValue: initialDate)
        let lunar = LunarCalendarConverter.shared.convertSolarToLunar(date: initialDate)
        _lunarDay = State(initialValue: lunar.day)
        _lunarMonth = State(initialValue: lunar.month)
    }
    
    public var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Thông Tin Sự Kiện")) {
                    TextField("Tiêu đề (VD: Ngày Giỗ Cụ, Sinh nhật...)", text: $title)
                    TextField("Ghi chú (tùy chọn)", text: $notes, axis: .vertical)
                        .lineLimit(2...4)
                }
                
                Section(header: Text("Thời Gian & Lịch")) {
                    Toggle("Tính theo Âm Lịch", isOn: $isLunarBased)
                    
                    if isLunarBased {
                        Picker("Ngày Âm Lịch", selection: $lunarDay) {
                            ForEach(1...30, id: \.self) { d in
                                Text("Ngày \(d)").tag(d)
                            }
                        }
                        Picker("Tháng Âm Lịch", selection: $lunarMonth) {
                            ForEach(1...12, id: \.self) { m in
                                Text("Tháng \(m)").tag(m)
                            }
                        }
                    } else {
                        DatePicker("Ngày Dương Lịch", selection: $solarDate, displayedComponents: [.date])
                    }
                    
                    Picker("Lặp lại", selection: $repeatType) {
                        ForEach(EventRepeatType.allCases, id: \.self) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                    
                    Toggle("Nhắc nhở thông báo", isOn: $hasReminder)
                }
                
                Section(header: Text("Màu Sắc Nhận Diện")) {
                    HStack(spacing: 12) {
                        ForEach(availableColors, id: \.self) { hex in
                            Circle()
                                .fill(Color(hex: hex))
                                .frame(width: 32, height: 32)
                                .overlay(
                                    Circle()
                                        .stroke(Color.primary, lineWidth: selectedColorHex == hex ? 3 : 0)
                                )
                                .onTapGesture {
                                    selectedColorHex = hex
                                }
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("Thêm Sự Kiện")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Hủy") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Lưu") {
                        saveEvent()
                        dismiss()
                    }
                    .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }
    
    private func saveEvent() {
        let newEvent = UserEvent(
            title: title.trimmingCharacters(in: .whitespaces),
            notes: notes.trimmingCharacters(in: .whitespaces),
            solarDate: solarDate,
            isLunarBased: isLunarBased,
            lunarDay: lunarDay,
            lunarMonth: lunarMonth,
            repeatType: repeatType,
            colorHex: selectedColorHex,
            hasReminder: hasReminder
        )
        
        eventService.addEvent(newEvent)
        if hasReminder {
            NotificationService.shared.scheduleReminder(for: newEvent)
        }
    }
}
