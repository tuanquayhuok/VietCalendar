import SwiftUI

public struct DayCellView: View {
    public let day: CalendarDay
    public let isSelected: Bool
    public let onSelect: () -> Void
    
    public var body: some View {
        Button(action: onSelect) {
            VStack(spacing: 3) {
                // Dương Lịch (Solar Day)
                Text("\(day.solarDay)")
                    .font(.system(size: 17, weight: day.isToday || isSelected ? .bold : .medium))
                    .foregroundColor(solarDayTextColor)
                
                // Âm Lịch (Lunar Day)
                Text(lunarText)
                    .font(.system(size: 11, weight: day.isFirstDayOfLunarMonth || day.isFullMoon ? .semibold : .regular))
                    .foregroundColor(lunarDayTextColor)
                
                // Indicators (Dấu chấm ngày lễ & sự kiện)
                HStack(spacing: 3) {
                    if day.hasHoliday {
                        Circle()
                            .fill(day.hasDayOff ? Color.vnRed : Color.vnGold)
                            .frame(width: 4, height: 4)
                    }
                    if day.hasEvent {
                        Circle()
                            .fill(Color.vnBlue)
                            .frame(width: 4, height: 4)
                    }
                    if !day.hasHoliday && !day.hasEvent {
                        Spacer().frame(height: 4)
                    }
                }
            }
            .frame(maxWidth: .infinity, minHeight: 52)
            .padding(.vertical, 4)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(backgroundFill)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isSelected ? Color.vnRed : Color.clear, lineWidth: 2)
                    )
            )
            .opacity(day.isCurrentMonth ? 1.0 : 0.35)
        }
        .buttonStyle(.plain)
    }
    
    private var lunarText: String {
        if day.isFirstDayOfLunarMonth {
            return "\(day.lunarDate.day)/\(day.lunarDate.month)"
        } else if day.isFullMoon {
            return "15 (Rằm)"
        } else {
            return "\(day.lunarDate.day)"
        }
    }
    
    private var solarDayTextColor: Color {
        if day.isToday {
            return .white
        }
        if day.hasDayOff {
            return .vnRed
        }
        if day.isWeekend {
            return .red.opacity(0.85)
        }
        return .primary
    }
    
    private var lunarDayTextColor: Color {
        if day.isToday {
            return .white.opacity(0.9)
        }
        if day.isFirstDayOfLunarMonth || day.isFullMoon {
            return .vnGold
        }
        return .secondary
    }
    
    private var backgroundFill: Color {
        if day.isToday {
            return Color.vnRed
        }
        if isSelected {
            return Color.vnRed.opacity(0.12)
        }
        return Color.clear
    }
}
