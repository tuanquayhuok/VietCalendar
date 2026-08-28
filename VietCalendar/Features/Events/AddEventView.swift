import SwiftUI

public enum EventEntryType: String, CaseIterable {
    case event = "Sự kiện"
    case reminder = "Lời nhắc"
}

public struct AddEventView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var eventService = EventService.shared
    
    public var initialDate: Date = Date()
    public var editingEvent: UserEvent? = nil
    
    @State private var entryType: EventEntryType = .event
    @State private var title: String = ""
    @State private var location: String = ""
    @State private var isAllDay: Bool = false
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date().addingTimeInterval(3600)
    @State private var travelTime: String = "Không có"
    @State private var repeatOption: String = "Không"
    @State private var selectedCalendar: String = "Lịch"
    @State private var alertOption: String = "Không có"
    
    public init(initialDate: Date = Date(), editingEvent: UserEvent? = nil) {
        self.initialDate = initialDate
        self.editingEvent = editingEvent
    }
    
    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    Picker("Loại", selection: $entryType) {
                        ForEach(EventEntryType.allCases, id: \.self) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                    
                    VStack(spacing: 0) {
                        TextField("Tiêu đề sự kiện", text: $title)
                            .font(.system(size: 16))
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                        
                        Divider().padding(.leading, 16)
                        
                        TextField("Vị trí hoặc ghi chú", text: $location)
                            .font(.system(size: 16))
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                    }
                    .background(Color(UIColor.secondarySystemGroupedBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    .padding(.horizontal, 16)
                    
                    VStack(spacing: 12) {
                        Toggle("Cả ngày", isOn: $isAllDay)
                            .font(.system(size: 16))
                            .padding(.horizontal, 16)
                            .padding(.top, 12)
                        
                        Divider().padding(.leading, 16)
                        
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
                    
                    if let ev = editingEvent {
                        Button(action: {
                            eventService.deleteEvent(id: ev.id)
                            dismiss()
                        }) {
                            HStack {
                                Image(systemName: "trash")
                                Text("Xóa sự kiện này")
                            }
                            .font(.headline)
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(UIColor.secondarySystemGroupedBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                        }
                        .padding(.horizontal, 16)
                    }
                }
                .padding(.bottom, 24)
            }
            .background(Color(UIColor.systemGroupedBackground))
            .navigationTitle(editingEvent == nil ? "Mới" : "Sửa Sự Kiện")
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
                            if let ev = editingEvent {
                                var updated = ev
                                updated.title = title
                                updated.notes = location
                                updated.solarDate = startDate
                                updated.isAllDay = isAllDay
                                updated.hasReminder = alertOption != "Không có"
                                eventService.updateEvent(updated)
                            } else {
                                let newEvent = UserEvent(
                                    title: title,
                                    notes: location,
                                    solarDate: startDate,
                                    isLunarBased: false,
                                    repeatType: .none,
                                    colorHex: "#2563EB",
                                    isAllDay: isAllDay,
                                    hasReminder: alertOption != "Không có"
                                )
                                eventService.addEvent(newEvent)
                            }
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
            .onAppear {
                if let ev = editingEvent {
                    title = ev.title
                    location = ev.notes
                    startDate = ev.solarDate
                    endDate = ev.solarDate.addingTimeInterval(3600)
                    isAllDay = ev.isAllDay
                } else {
                    startDate = initialDate
                    endDate = initialDate.addingTimeInterval(3600)
                }
            }
        }
    }
}
