import SwiftUI

public enum ConversionMode: String, CaseIterable {
    case solarToLunar = "Dương ➔ Âm"
    case lunarToSolar = "Âm ➔ Dương"
}

public struct ConvertDateView: View {
    @State private var mode: ConversionMode = .solarToLunar
    
    // Solar -> Lunar state
    @State private var inputSolarDate = Date()
    
    // Lunar -> Solar state
    @State private var inputLunarDay = 1
    @State private var inputLunarMonth = 1
    @State private var inputLunarYear = 2026
    @State private var isLeap = false
    
    private let converter = LunarCalendarConverter.shared
    
    public init() {}
    
    private var convertedLunar: LunarDate {
        converter.convertSolarToLunar(date: inputSolarDate)
    }
    
    public var body: some View {
        NavigationStack {
            Form {
                Section {
                    Picker("Chế độ chuyển đổi", selection: $mode) {
                        ForEach(ConversionMode.allCases, id: \.self) { item in
                            Text(item.rawValue).tag(item)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                if mode == .solarToLunar {
                    Section(header: Text("Chọn Ngày Dương Lịch")) {
                        DatePicker("Ngày Dương Lịch", selection: $inputSolarDate, displayedComponents: [.date])
                    }
                    
                    Section(header: Text("Kết Quả Âm Lịch")) {
                        resultRow(title: "Ngày Âm Lịch", value: "\(convertedLunar.day)/\(convertedLunar.month)\(convertedLunar.isLeapMonth ? " (Nhuận)" : "")")
                        resultRow(title: "Năm Âm Lịch", value: convertedLunar.yearName)
                        resultRow(title: "Tháng", value: convertedLunar.monthName)
                        resultRow(title: "Ngày (Can Chi)", value: convertedLunar.dayName)
                    }
                } else {
                    Section(header: Text("Nhập Ngày Âm Lịch")) {
                        Picker("Ngày", selection: $inputLunarDay) {
                            ForEach(1...30, id: \.self) { d in
                                Text("Ngày \(d)").tag(d)
                            }
                        }
                        Picker("Tháng", selection: $inputLunarMonth) {
                            ForEach(1...12, id: \.self) { m in
                                Text("Tháng \(m)").tag(m)
                            }
                        }
                        Picker("Năm", selection: $inputLunarYear) {
                            ForEach(1950...2050, id: \.self) { y in
                                Text("Năm \(y)").tag(y)
                            }
                        }
                        Toggle("Tháng Nhuận", isOn: $isLeap)
                    }
                    
                    Section(header: Text("Kết Quả Dương Lịch")) {
                        if let solar = converter.convertLunarToSolar(lunarDay: inputLunarDay, lunarMonth: inputLunarMonth, lunarYear: inputLunarYear, isLeap: isLeap) {
                            resultRow(title: "Ngày Dương Lịch", value: "\(solar.day)/\(solar.month)/\(solar.year)")
                        } else {
                            Text("Ngày âm lịch không hợp lệ")
                                .foregroundColor(.red)
                        }
                    }
                }
            }
            .navigationTitle("Chuyển Đổi Âm/Dương")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func resultRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .bold()
                .foregroundColor(.primary)
        }
    }
}
