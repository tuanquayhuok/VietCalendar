import Foundation
import SwiftUI

public enum HolidayType: String, Codable, Sendable {
    case national = "Quốc gia (Nghỉ lễ)"
    case traditional = "Truyền thống Dân gian"
    case international = "Quốc tế / Kỷ niệm"
    case religious = "Tôn giáo / Văn hóa"
    
    public var badgeColor: Color {
        switch self {
        case .national:
            return .red
        case .traditional:
            return .orange
        case .international:
            return .blue
        case .religious:
            return .purple
        }
    }
}

public struct Holiday: Identifiable, Codable, Hashable, Sendable {
    public let id: String
    public let name: String
    public let type: HolidayType
    public let isLunar: Bool
    public let day: Int
    public let month: Int
    public let isDayOff: Bool // Được nghỉ làm/học
    public let description: String
    
    public init(
        id: String = UUID().uuidString,
        name: String,
        type: HolidayType,
        isLunar: Bool,
        day: Int,
        month: Int,
        isDayOff: Bool = false,
        description: String = ""
    ) {
        self.id = id
        self.name = name
        self.type = type
        self.isLunar = isLunar
        self.day = day
        self.month = month
        self.isDayOff = isDayOff
        self.description = description
    }
}
