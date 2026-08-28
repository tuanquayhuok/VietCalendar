import SwiftUI

public struct YearGridView: View {
    @Binding var selectedYear: Int
    public let onSelectMonth: (Int) -> Void
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var themeManager = ThemeManager.shared
    
    public init(selectedYear: Binding<Int>, onSelectMonth: @escaping (Int) -> Void) {
        self._selectedYear = selectedYear
        self.onSelectMonth = onSelectMonth
    }
    
    private let columns = [
        GridItem(.flexible(), spacing: 14),
        GridItem(.flexible(), spacing: 14),
        GridItem(.flexible(), spacing: 14)
    ]
    
    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    HStack {
                        Button(action: {
                            selectedYear -= 1
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.headline.bold())
                                .padding(10)
                                .background(Color.vnSurface)
                                .clipShape(Circle())
                        }
                        
                        Spacer()
                        
                        Text("Năm \(selectedYear)")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                        
                        Spacer()
                        
                        Button(action: {
                            selectedYear += 1
                        }) {
                            Image(systemName: "chevron.right")
                                .font(.headline.bold())
                                .padding(10)
                                .background(Color.vnSurface)
                                .clipShape(Circle())
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(1...12, id: \.self) { month in
                            Button(action: {
                                onSelectMonth(month)
                                dismiss()
                            }) {
                                VStack(spacing: 8) {
                                    Text("Tháng \(month)")
                                        .font(.system(size: 16, weight: .bold, design: .rounded))
                                        .foregroundColor(themeManager.selectedAccent.color)
                                    
                                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                                        .fill(Color.vnSurface)
                                        .frame(height: 75)
                                        .overlay(
                                            VStack(spacing: 4) {
                                                Image(systemName: "calendar")
                                                    .font(.title3)
                                                    .foregroundColor(themeManager.selectedAccent.color.opacity(0.8))
                                                Text("30 ngày")
                                                    .font(.caption2)
                                                    .foregroundColor(.secondary)
                                            }
                                        )
                                }
                                .padding(8)
                                .background(Color(UIColor.secondarySystemGroupedBackground))
                                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                                .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 2)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 16)
                }
            }
            .navigationTitle("Tổng Quan Năm")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Đóng") { dismiss() }
                }
            }
        }
    }
}
