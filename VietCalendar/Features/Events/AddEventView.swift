import SwiftUI

public enum EventEntryType: String, CaseIterable {
    case event = "Sự kiện"
    case reminder = "Lời nhắc"
}

public struct AddEventView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var eventService = EventService.shared
    
    @State private var entryType: EventEntryType = .event
    @State private var title: String = ""
    @State private var location: String = ""
    @State private var isAllDay: Bool = false
    @State private var startDate: Date
    @State private var endDate: Date
    @State private var travelTime: String = "Không có"
    @State private var repeatOption: String = "Không"
    @State private var selectedCalendar: String = "Lịch"
    @State private var alertOption: String = "Không có"
    
    public init(initialDate: Date = Date()) {
        _startDate = State(initialValue: initialDate)
        _endDate = State(initialValue: initialDate.addingTimeInterval(3600))
    }
    
    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    // Segmented Control: [ Sự kiện | Lời nhắc ]
                    Picker("Loại", selection: $entryType) {
                        ForEach(EventEntryType.allCases, id: \.self) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                    
                    // Card 1: Tiêu đề & Vị trí
                    VStack(spacing: 0) {
                        TextField("Tiêu đề", text: $title)
                            .font(.system(size: 16))
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                        
                        Divider().padding(.leading, 16)
                        
                        TextField("Vị trí hoặc cuộc gọi video", text: $location)
                            .font(.system(size: 16))
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                    }
                    .background(Color(UIColor.secondarySystemGroupedBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    .padding(.horizontal, 16)
                    
                    // Card 2: Thời gian & Ngày giờ
                    VStack(spacing: 12) {
                        Toggle("Cả ngày", isOn: $isAllDay)
                            .font(.system(size: 16))
                            .padding(.horizontal, 16)
                            .padding(.top, 12)
                        
                        Divider().padding(.leading, 16)
                        
                        // Bắt đầu
                        HStack {
                            Text("Bắt đầu")
                                .font(.system(size: 16))
                            Spacer()
                            if !isAllDay {
                                DatePicker("", selection: $startDate, displayedComponents: [.hourAndMinute])
                                    .labelsHidden()
                            }
                            DatePicker("", selection: $startDate, displayedComponents: [.date])
                                .labelsHidden()
                        }
                        .padding(.horizontal, 16)
                        
                        Divider().padding(.leading, 16)
                        
                        // Kết thúc
                        HStack {
                            Text("Kết thúc")
                                .font(.system(size: 16))
                            Spacer()
                            if !isAllDay {
                                DatePicker("", selection: $endDate, displayedComponents: [.hourAndMinute])
                                    .labelsHidden()
                            }
                            DatePicker("", selection: $endDate, displayedComponents: [.date])
                                .labelsHidden()
                        }
                        .padding(.horizontal, 16)
                        
                        Divider().padding(.leading, 16)
                        
                        // Thời gian di chuyển
                        HStack {
                            Text("Thời gian di chuyển")
                                .font(.system(size: 16))
                            Spacer()
                            Text("\(travelTime) ⬍")
                                .font(.system(size: 15))
                                .foregroundColor(.secondary)
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 12)
                    }
                    .background(Color(UIColor.secondarySystemGroupedBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    .padding(.horizontal, 16)
                    
                    // Card 3: Lặp lại
                    HStack {
                        Text("Lặp lại")
                            .font(.system(size: 16))
                        Spacer()
                        Text("\(repeatOption) ⬍")
                            .font(.system(size: 15))
                            .foregroundColor(.secondary)
                    }
                    .padding(16)
                    .background(Color(UIColor.secondarySystemGroupedBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    .padding(.horizontal, 16)
                    
                    // Card 4: Lịch & Người mời
                    VStack(spacing: 0) {
                        HStack {
                            Text("Lịch")
                                .font(.system(size: 16))
                            Spacer()
                            HStack(spacing: 6) {
                                Circle().fill(Color.blue).frame(width: 8, height: 8)
                                Text("Lịch ⬍")
                                    .font(.system(size: 15))
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(16)
                        
                        Divider().padding(.leading, 16)
                        
                        HStack {
                            Text("Người được mời")
                                .font(.system(size: 16))
                            Spacer()
                            Text("Không có >")
                                .font(.system(size: 15))
                                .foregroundColor(.secondary)
                        }
                        .padding(16)
                    }
                    .background(Color(UIColor.secondarySystemGroupedBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    .padding(.horizontal, 16)
                    
                    // Card 5: Cảnh báo
                    HStack {
                        Text("Cảnh báo")
                            .font(.system(size: 16))
                        Spacer()
                        Text("\(alertOption) ⬍")
                            .font(.system(size: 15))
                            .foregroundColor(.secondary)
                    }
                    .padding(16)
                    .background(Color(UIColor.secondarySystemGroupedBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    .padding(.horizontal, 16)
                }
                .padding(.bottom, 24)
            }
            .background(Color(UIColor.systemGroupedBackground))
            .navigationTitle("Mới")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.primary)
                            .padding(8)
                            .background(Color(UIColor.secondarySystemGroupedBackground))
                            .clipShape(Circle())
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button(action: {
                        if !title.isEmpty {
                            let cal = Calendar.current
                            let comp = cal.dateComponents([.day, .month, .year], from: startDate)
                            let newEvent = UserEvent(
                                title: title,
                                notes: location,
                                day: comp.day ?? 1,
                                month: comp.month ?? 1,
                                year: comp.year ?? 2026,
                                isLunarBased: false,
                                repeatType: .none,
                                colorHex: "#2563EB",
                                hasReminder: alertOption != "Không có"
                            )
                            eventService.addEvent(newEvent)
                        }
                        dismiss()
                    }) {
                        Image(systemName: "checkmark")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(.white)
                            .padding(8)
                            .background(Color.primary.opacity(0.85))
                            .clipShape(Circle())
                    }
                }
            }
        }
    }
}
