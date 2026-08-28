import SwiftUI

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
                    Button(action: {
                        if completedItems.contains(item) { completedItems.remove(item) }
                        else { completedItems.insert(item) }
                    }) {
                        HStack(spacing: 12) {
                            Image(systemName: completedItems.contains(item) ? "checkmark.circle.fill" : "circle")
                                .font(.title3)
                                .foregroundColor(completedItems.contains(item) ? .purple : .secondary)
                            Text(item)
                                .strikethrough(completedItems.contains(item), color: .secondary)
                                .foregroundColor(completedItems.contains(item) ? .secondary : .primary)
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
