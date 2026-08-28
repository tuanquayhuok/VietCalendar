import SwiftUI

public struct EventListView: View {
    @ObservedObject private var eventService = EventService.shared
    @State private var showingAddEvent = false
    @State private var searchText = ""
    
    public var body: some View {
        NavigationStack {
            List {
                if filteredEvents.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "calendar.badge.exclamationmark")
                            .font(.system(size: 40))
                            .foregroundColor(.secondary)
                        Text("Chưa có sự kiện hoặc ngày giỗ nào.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 32)
                    .listRowBackground(Color.clear)
                } else {
                    ForEach(filteredEvents) { event in
                        HStack(spacing: 12) {
                            RoundedRectangle(cornerRadius: 3)
                                .fill(Color(hex: event.colorHex))
                                .frame(width: 5, height: 44)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(event.title)
                                    .font(.headline)
                                
                                if event.isLunarBased {
                                    Text("Âm Lịch: Ngày \(event.lunarDay)/\(event.lunarMonth) • \(event.repeatType.rawValue)")
                                        .font(.caption)
                                        .foregroundColor(.vnGold)
                                } else {
                                    Text("\(event.solarDate.formattedVietnamese(dateStyle: .medium)) • \(event.repeatType.rawValue)")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                
                                if !event.notes.isEmpty {
                                    Text(event.notes)
                                        .font(.caption2)
                                        .foregroundColor(.secondary)
                                }
                            }
                            
                            Spacer()
                        }
                    }
                    .onDelete(perform: deleteItems)
                }
            }
            .searchable(text: $searchText, prompt: "Tìm kiếm sự kiện, ngày giỗ...")
            .navigationTitle("Sự Kiện & Ngày Giỗ")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddEvent = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddEvent) {
                AddEventView()
            }
        }
    }
    
    private var filteredEvents: [UserEvent] {
        if searchText.isEmpty {
            return eventService.events
        } else {
            return eventService.events.filter {
                $0.title.localizedCaseInsensitiveContains(searchText) ||
                $0.notes.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    private func deleteItems(at offsets: IndexSet) {
        for index in offsets {
            let event = filteredEvents[index]
            eventService.deleteEvent(id: event.id)
            NotificationService.shared.removeReminder(for: event.id)
        }
    }
}
