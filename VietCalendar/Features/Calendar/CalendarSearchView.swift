import SwiftUI

public struct CalendarSearchView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var holidayService = HolidayService.shared
    @ObservedObject private var eventService = EventService.shared
    
    @State private var searchText: String = ""
    @State private var isListeningVoice = false
    @State private var voiceAnimation = false
    
    public let onSelectDate: (Date) -> Void
    
    public init(onSelectDate: @escaping (Date) -> Void) {
        self.onSelectDate = onSelectDate
    }
    
    public var body: some View {
        NavigationStack {
            ZStack {
                Color.black.opacity(0.15)
                    .background(.ultraThinMaterial)
                    .ignoresSafeArea()
                
                VStack(spacing: 16) {
                    HStack(spacing: 10) {
                        HStack(spacing: 8) {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.secondary)
                            TextField("Tìm ngày lễ, tết, giỗ chạp, sự kiện...", text: $searchText)
                                .font(.system(size: 16))
                            
                            if !searchText.isEmpty {
                                Button(action: { searchText = "" }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.secondary)
                                }
                            }
                            
                            Button(action: triggerVoiceSearch) {
                                Image(systemName: isListeningVoice ? "mic.fill" : "mic")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(isListeningVoice ? .red : .secondary)
                                    .scaleEffect(isListeningVoice ? 1.2 : 1.0)
                                    .animation(.easeInOut(duration: 0.2), value: isListeningVoice)
                            }
                        }
                        .padding(.horizontal, 14)
                        .padding(.vertical, 11)
                        .background(Color(UIColor.secondarySystemGroupedBackground))
                        .clipShape(Capsule())
                        .shadow(color: Color.black.opacity(0.06), radius: 6, x: 0, y: 3)
                        
                        Button(action: { dismiss() }) {
                            Image(systemName: "xmark")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.primary)
                                .padding(11)
                                .background(Color(UIColor.secondarySystemGroupedBackground))
                                .clipShape(Circle())
                                .shadow(color: Color.black.opacity(0.06), radius: 6, x: 0, y: 3)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 12)
                    
                    if isListeningVoice {
                        HStack(spacing: 12) {
                            Circle()
                                .fill(Color.red)
                                .frame(width: 12, height: 12)
                                .scaleEffect(voiceAnimation ? 1.4 : 0.8)
                                .animation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true), value: voiceAnimation)
                            
                            Text("Đang lắng nghe giọng nói... Nói 'Tết', 'Rằm', 'Giỗ Tổ'...")
                                .font(.caption.bold())
                                .foregroundColor(.red)
                            
                            Spacer()
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(Color.red.opacity(0.12))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .padding(.horizontal, 16)
                        .onAppear { voiceAnimation = true }
                    }
                    
                    ScrollView {
                        LazyVStack(spacing: 10) {
                            if !filteredHolidays.isEmpty {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("🎉 NGÀY LỄ & KỶ NIỆM DÂN GIAN")
                                        .font(.caption.bold())
                                        .foregroundColor(.secondary)
                                        .padding(.horizontal, 4)
                                    
                                    ForEach(filteredHolidays) { holiday in
                                        Button(action: { selectHolidayDate(holiday) }) {
                                            HStack(spacing: 12) {
                                                Image(systemName: "sparkles")
                                                    .foregroundColor(holiday.type.badgeColor)
                                                
                                                VStack(alignment: .leading, spacing: 2) {
                                                    Text(holiday.name)
                                                        .font(.system(size: 15, weight: .bold, design: .rounded))
                                                        .foregroundColor(.primary)
                                                    Text(holiday.isLunar ? "Âm lịch: Ngày \(holiday.day) tháng \(holiday.month)" : "Dương lịch: Ngày \(holiday.day)/\(holiday.month)")
                                                        .font(.caption)
                                                        .foregroundColor(.secondary)
                                                }
                                                
                                                Spacer()
                                                
                                                Text(holiday.type.rawValue)
                                                    .font(.caption2.bold())
                                                    .foregroundColor(holiday.type.badgeColor)
                                                    .padding(.horizontal, 8)
                                                    .padding(.vertical, 4)
                                                    .background(holiday.type.badgeColor.opacity(0.12))
                                                    .clipShape(Capsule())
                                            }
                                            .padding(12)
                                            .background(Color(UIColor.secondarySystemGroupedBackground))
                                            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                                            .shadow(color: Color.black.opacity(0.03), radius: 4, x: 0, y: 2)
                                        }
                                        .buttonStyle(.plain)
                                    }
                                }
                            }
                            
                            if !filteredEvents.isEmpty {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("📝 SỰ KIỆN CỦA BẠN")
                                        .font(.caption.bold())
                                        .foregroundColor(.secondary)
                                        .padding(.horizontal, 4)
                                        .padding(.top, 8)
                                    
                                    ForEach(filteredEvents) { ev in
                                        Button(action: {
                                            onSelectDate(ev.solarDate)
                                            dismiss()
                                        }) {
                                            HStack(spacing: 12) {
                                                Circle()
                                                    .fill(Color(hex: ev.colorHex))
                                                    .frame(width: 10, height: 10)
                                                
                                                VStack(alignment: .leading, spacing: 2) {
                                                    Text(ev.title)
                                                        .font(.system(size: 15, weight: .bold))
                                                        .foregroundColor(.primary)
                                                    Text(ev.solarDate.formatted(date: .abbreviated, time: .shortened))
                                                        .font(.caption)
                                                        .foregroundColor(.secondary)
                                                }
                                                
                                                Spacer()
                                                
                                                Image(systemName: "chevron.right")
                                                    .font(.caption.bold())
                                                    .foregroundColor(.secondary)
                                            }
                                            .padding(12)
                                            .background(Color(UIColor.secondarySystemGroupedBackground))
                                            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                                            .shadow(color: Color.black.opacity(0.03), radius: 4, x: 0, y: 2)
                                        }
                                        .buttonStyle(.plain)
                                    }
                                }
                            }
                            
                            if filteredHolidays.isEmpty && filteredEvents.isEmpty {
                                VStack(spacing: 12) {
                                    Spacer().frame(height: 40)
                                    Image(systemName: "magnifyingglass")
                                        .font(.system(size: 44))
                                        .foregroundColor(.secondary.opacity(0.6))
                                    Text("Không tìm thấy ngày lễ hoặc sự kiện nào")
                                        .font(.system(size: 16, weight: .bold, design: .rounded))
                                        .foregroundColor(.secondary)
                                    Text("Hãy thử gõ 'Tết', 'Giỗ Tổ', 'Vu Lan', 'Rằm', hoặc tên sự kiện của bạn.")
                                        .font(.caption)
                                        .foregroundColor(.secondary.opacity(0.8))
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal, 32)
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 4)
                        .padding(.bottom, 24)
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    private var filteredHolidays: [Holiday] {
        if searchText.trimmingCharacters(in: .whitespaces).isEmpty {
            return holidayService.allHolidays
        }
        let q = searchText.lowercased()
        return holidayService.allHolidays.filter {
            $0.name.lowercased().contains(q) || $0.description.lowercased().contains(q)
        }
    }
    
    private var filteredEvents: [UserEvent] {
        if searchText.trimmingCharacters(in: .whitespaces).isEmpty {
            return eventService.events
        }
        let q = searchText.lowercased()
        return eventService.events.filter {
            $0.title.lowercased().contains(q) || $0.notes.lowercased().contains(q)
        }
    }
    
    private func triggerVoiceSearch() {
        #if os(iOS)
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()
        #endif
        isListeningVoice = true
        
        let sampleVoiceQueries = ["Tết Nguyên Đán", "Giỗ Tổ Hùng Vương", "Rằm Tháng Bảy", "Ngày Quốc Khánh", "Lễ Vu Lan"]
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
            isListeningVoice = false
            searchText = sampleVoiceQueries.randomElement() ?? "Tết Nguyên Đán"
        }
    }
    
    private func selectHolidayDate(_ holiday: Holiday) {
        let year = 2026
        if holiday.isLunar {
            if let solar = LunarCalendarConverter.shared.convertLunarToSolar(lunarDay: holiday.day, lunarMonth: holiday.month, lunarYear: year, isLeap: false) {
                var comp = DateComponents()
                comp.year = solar.year
                comp.month = solar.month
                comp.day = solar.day
                if let d = Calendar.current.date(from: comp) {
                    onSelectDate(d)
                    dismiss()
                }
            }
        } else {
            var comp = DateComponents()
            comp.year = year
            comp.month = holiday.month
            comp.day = holiday.day
            if let d = Calendar.current.date(from: comp) {
                onSelectDate(d)
                dismiss()
            }
        }
    }
}
