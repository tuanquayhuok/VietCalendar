import Foundation

extension Date {
    public var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }
    
    public var startOfMonth: Date {
        let components = Calendar.current.dateComponents([.year, .month], from: self)
        return Calendar.current.date(from: components) ?? self
    }
    
    public var endOfMonth: Date {
        var components = DateComponents()
        components.month = 1
        components.day = -1
        return Calendar.current.date(byAdding: components, to: startOfMonth) ?? self
    }
    
    public func addingMonth(_ count: Int) -> Date {
        Calendar.current.date(byAdding: .month, value: count, to: self) ?? self
    }
    
    public func formattedVietnamese(dateStyle: DateFormatter.Style = .medium, timeStyle: DateFormatter.Style = .none) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "vi_VN")
        formatter.dateStyle = dateStyle
        formatter.timeStyle = timeStyle
        return formatter.string(from: self)
    }
}
