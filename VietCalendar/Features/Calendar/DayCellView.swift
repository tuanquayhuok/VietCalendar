import SwiftUI

public struct DayCellView: View {
    public let day: CalendarDay
    public let isSelected: Bool
    public let onSelect: () -> Void
    
    @ObservedObject private var themeManager = ThemeManager.shared
    
    public init(day: CalendarDay, isSelected: Bool, onSelect: @escaping () -> Void) {
        self.day = day
        self.isSelected = isSelected
        self.onSelect = onSelect
    }
    
    public var body: some View {
        Button(action: {
            #if os(iOS)
            let impact = UIImpactFeedbackGenerator(style: .light)
            impact.impactOccurred()
            #endif
            onSelect()
        }) {
            VStack(spacing: 3) {
                // Solar Day Number (Dương Lịch)
                Text("\(day.solarDay)")
                    .font(.system(size: 17, weight: day.isToday || isSelected ? .bold : .medium, design: .rounded))
                    .foregroundColor(solarDayColor)
                
                // Lunar Day (Âm Lịch)
                Text(day.lunarDate.formattedShort)
                    .font(.system(size: 10, weight: day.lunarDate.day == 1 || day.lunarDate.day == 15 ? .bold : .regular))
                    .foregroundColor(lunarDayColor)
                
                // Dots / Indicators
                HStack(spacing: 3) {
                    if !day.holidays.isEmpty {
                        Circle()
                            .fill(Color.vnRed)
                            .frame(width: 4, height: 4)
                    }
                    if !day.events.isEmpty {
                        Circle()
                            .fill(Color.vnGold)
                            .frame(width: 4, height: 4)
                    }
                    if day.solarTerm != nullTermPlaceholder {
                        Circle()
                            .fill(Color.vnEmerald)
                            .frame(width: 3.5, height: 3.5)
                    }
                }
                .frame(height: 5)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .background(cellBackground)
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .overlay(cellBorder)
        }
        .buttonStyle(.plain)
    }
    
    private var nullTermPlaceholder: String { "" }
    
    private var solarDayColor: Color {
        if isSelected {
            return .white
        }
        if day.isToday {
            return themeManager.selectedAccent.color
        }
        if !day.isCurrentMonth {
            return Color.secondary.opacity(0.35)
        }
        return .primary
    }
    
    private var lunarDayColor: Color {
        if isSelected {
            return Color(hex: "#FEF08A")
        }
        if !day.isCurrentMonth {
            return Color.secondary.opacity(0.3)
        }
        if day.lunarDate.day == 1 || day.lunarDate.day == 15 {
            return Color.vnRed
        }
        return Color.vnGold
    }
    
    @ViewBuilder
    private var cellBackground: some View {
        if isSelected {
            themeManager.selectedAccent.color
                .shadow(color: themeManager.selectedAccent.color.opacity(0.35), radius: 6, x: 0, y: 3)
        } else if day.isToday {
            themeManager.selectedAccent.color.opacity(0.12)
        } else {
            Color.clear
        }
    }
    
    @ViewBuilder
    private var cellBorder: some View {
        if day.isToday && !isSelected {
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(themeManager.selectedAccent.color.opacity(0.6), lineWidth: 1.5)
        }
    }
}
