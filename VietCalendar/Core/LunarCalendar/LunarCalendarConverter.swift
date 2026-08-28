import Foundation

/// Bộ chuyển đổi Âm Dương Lịch Việt Nam theo thuật toán thiên văn học Hồ Ngọc Đức (Múi giờ GMT+7)
public final class LunarCalendarConverter {
    
    public static let shared = LunarCalendarConverter()
    private let timeZoneOffset: Double = 7.0 // GMT+7 cho Việt Nam
    
    public static let canNames = ["Giáp", "Ất", "Bính", "Đinh", "Mậu", "Kỷ", "Canh", "Tân", "Nhâm", "Quý"]
    public static let chiNames = ["Tý", "Sửu", "Dần", "Mão", "Thìn", "Tỵ", "Ngọ", "Mùi", "Thân", "Dậu", "Tuất", "Hợi"]
    
    private init() {}
    
    public func getYearCanChi(year: Int) -> String {
        let can = Self.canNames[(year + 6) % 10]
        let chi = Self.chiNames[(year + 8) % 12]
        return "\(can) \(chi)"
    }
    
    // MARK: - 1. Julian Day Calculations
    
    /// Tính số ngày Julius (Julian Day Number) từ ngày/tháng/năm dương lịch
    public func jdFromDate(day: Int, month: Int, year: Int) -> Double {
        var y = year
        var m = month
        if m <= 2 {
            y -= 1
            m += 12
        }
        let a = floor(Double(y) / 100.0)
        let b = 2.0 - a + floor(a / 4.0)
        let jd = floor(365.25 * Double(y + 4716)) + floor(30.6001 * Double(m + 1)) + Double(day) + b - 1524.5
        return jd
    }
    
    /// Đổi từ Julian Day Number sang ngày/tháng/năm dương lịch
    public func jdToDate(jd: Double) -> (day: Int, month: Int, year: Int) {
        let z = floor(jd + 0.5)
        let f = (jd + 0.5) - z
        var a = z
        if z >= 2299161.0 {
            let alpha = floor((z - 1867216.25) / 36524.25)
            a = z + 1.0 + alpha - floor(alpha / 4.0)
        }
        let b = a + 1524.0
        let c = floor((b - 122.1) / 365.25)
        let d = floor(365.25 * c)
        let e = floor((b - d) / 30.6001)
        
        let day = Int(b - d - floor(30.6001 * e) + f)
        let month = Int(e < 14.0 ? e - 1.0 : e - 13.0)
        let year = Int(month > 2 ? c - 4716.0 : c - 4715.0)
        
        return (day, month, year)
    }
    
    // MARK: - 2. Astronomical Formulas (Sun & Moon)
    
    private func getNewMoonDay(k: Int, timeZone: Double) -> Double {
        let T = Double(k) / 1236.85
        let T2 = T * T
        let T3 = T2 * T
        let dr = Double.pi / 180.0
        
        var Jd1 = 2415020.75933 + 29.53058868 * Double(k) + 0.0001178 * T2 - 0.000000155 * T3
        Jd1 += 0.00033 * sin((166.56 + 132.87 * T - 0.009173 * T2) * dr)
        
        let M = 359.2242 + 29.10535608 * Double(k) - 0.0000333 * T2 - 0.00000347 * T3
        let Mpr = 306.0253 + 385.81691806 * Double(k) + 0.0107306 * T2 + 0.00001236 * T3
        let F = 21.2964 + 390.67050646 * Double(k) - 0.0016528 * T2 - 0.00000239 * T3
        
        var C1 = (0.1734 - 0.000393 * T) * sin(M * dr) + 0.0021 * sin(2.0 * M * dr)
        C1 -= 0.4068 * sin(Mpr * dr) + 0.0161 * sin(2.0 * Mpr * dr)
        C1 -= 0.0004 * sin(3.0 * Mpr * dr)
        C1 += 0.0104 * sin(2.0 * F * dr) - 0.0051 * sin((M + Mpr) * dr)
        C1 -= 0.0074 * sin((M - Mpr) * dr) + 0.0004 * sin((2.0 * F + M) * dr)
        C1 -= 0.0004 * sin((2.0 * F - M) * dr) - 0.0006 * sin((2.0 * F + Mpr) * dr)
        C1 += 0.0010 * sin((2.0 * F - Mpr) * dr) + 0.0005 * sin((M + 2.0 * Mpr) * dr)
        
        var deltat: Double = 0
        if T < -11.0 {
            deltat = 0.001 + 0.000839 * T + 0.0002261 * T2 - 0.00000845 * T3 - 0.00000061 * T * T3
        } else {
            deltat = -0.000078 + 0.000287 * T + 0.000149 * T2 - 0.000000238 * T3 - 0.00000123 * T * T3
        }
        
        let JdNew = Jd1 + C1 - deltat
        return floor(JdNew + 0.5 + timeZone / 24.0)
    }
    
    public func getSunLongitude(dayNumber: Double, timeZone: Double) -> Double {
        let T = (dayNumber - 2451545.5 - timeZone / 24.0) / 36525.0
        let T2 = T * T
        let dr = Double.pi / 180.0
        let M = 357.52910 + 35999.05030 * T - 0.0001559 * T2 - 0.00000048 * T * T2
        let L0 = 280.46645 + 36000.76983 * T + 0.0003032 * T2
        var DL = (1.914600 - 0.004817 * T - 0.000014 * T2) * sin(M * dr)
        DL += (0.019993 - 0.000101 * T) * sin(2.0 * M * dr) + 0.000290 * sin(3.0 * M * dr)
        var L = L0 + DL
        L = L * dr
        L = L - Double.pi * 2.0 * floor(L / (Double.pi * 2.0))
        return L
    }
    
    private func getLunarMonth11(year: Int, timeZone: Double) -> Double {
        let off = jdFromDate(day: 31, month: 12, year: year) - 2415021.076998695
        var k = Int(floor(off / 29.530588853))
        var nm = getNewMoonDay(k: k, timeZone: timeZone)
        var sunLong = getSunLongitude(dayNumber: nm, timeZone: timeZone)
        let sunLongDeg = sunLong * 180.0 / Double.pi
        
        if sunLongDeg >= 270.0 && sunLongDeg < 360.0 {
            // Sau Đông Chí
        } else if sunLongDeg >= 0.0 && sunLongDeg < 90.0 {
            // Sau Xuân Phân
        } else {
            k -= 1
            nm = getNewMoonDay(k: k, timeZone: timeZone)
            sunLong = getSunLongitude(dayNumber: nm, timeZone: timeZone)
        }
        return nm
    }
    
    private func getLeapMonthOffset(a11: Double, timeZone: Double) -> Int {
        var k = Int(floor((a11 - 2415021.076998695) / 29.530588853 + 0.5))
        var last = 0
        var i = 1
        var arc = getSunLongitude(dayNumber: a11, timeZone: timeZone)
        var arcDeg = Int(floor(arc * 180.0 / Double.pi / 30.0))
        
        while i <= 14 {
            k += 1
            let nm = getNewMoonDay(k: k, timeZone: timeZone)
            let sunLong = getSunLongitude(dayNumber: nm, timeZone: timeZone)
            let sunDeg = Int(floor(sunLong * 180.0 / Double.pi / 30.0))
            if sunDeg == arcDeg {
                last = i
                break
            }
            arcDeg = sunDeg
            i += 1
        }
        return last
    }
    
    // MARK: - 3. Can Chi & Sexagenary Cycle Calculations
    
    public func calculateCanChi(jd: Double, lunarYear: Int, lunarMonth: Int) -> (canDay: String, chiDay: String, canMonth: String, chiMonth: String, canYear: String, chiYear: String) {
        let canDay = Self.canNames[Int(floor(jd + 9.5)) % 10]
        let chiDay = Self.chiNames[Int(floor(jd + 1.5)) % 12]
        
        let canYear = Self.canNames[(lunarYear + 6) % 10]
        let chiYear = Self.chiNames[(lunarYear + 8) % 12]
        
        let canMonth = Self.canNames[(lunarYear * 12 + lunarMonth + 3) % 10]
        let chiMonth = Self.chiNames[(lunarMonth + 1) % 12]
        
        return (canDay, chiDay, canMonth, chiMonth, canYear, chiYear)
    }
    
    // MARK: - 4. Public API: Solar -> Lunar
    
    /// Chuyển đổi Ngày/Tháng/Năm Dương Lịch sang Âm Lịch (LunarDate)
    public func convertSolarToLunar(day: Int, month: Int, year: Int) -> LunarDate {
        let currentJd = jdFromDate(day: day, month: month, year: year)
        let k = Int(floor((currentJd - 2415021.076998695) / 29.530588853))
        var monthStart = getNewMoonDay(k: k + 1, timeZone: timeZoneOffset)
        
        if monthStart > currentJd {
            monthStart = getNewMoonDay(k: k, timeZone: timeZoneOffset)
        }
        
        let a11 = getLunarMonth11(year: year, timeZone: timeZoneOffset)
        let b11 = getLunarMonth11(year: year + 1, timeZone: timeZoneOffset)
        
        var lunarYear = year
        if currentJd >= a11 {
            lunarYear = year
        } else {
            lunarYear = year - 1
        }
        
        var totalMonths = Int(floor((b11 - a11) / 29.0))
        var leapMonthIndex = 0
        if totalMonths > 12 {
            leapMonthIndex = getLeapMonthOffset(a11: a11, timeZone: timeZoneOffset)
        }
        
        let lunarDay = Int(currentJd - monthStart + 1)
        let diff = Int(floor((monthStart - a11) / 29.0))
        var lunarMonth = diff + 11
        var isLeap = false
        
        if totalMonths > 12 && diff >= leapMonthIndex {
            if diff == leapMonthIndex {
                isLeap = true
                lunarMonth = leapMonthIndex + 10
            } else {
                let monthIndex = diff - 1
                lunarMonth = monthIndex + 10
                if monthIndex == leapMonthIndex {
                    isLeap = true
                }
            }
        }
        
        if lunarMonth > 12 {
            lunarMonth -= 12
        }
        if lunarMonth >= 11 && diff < 4 {
            // Tháng 11 hoặc 12 của năm âm lịch trước
        }
        
        let canChi = calculateCanChi(jd: currentJd, lunarYear: lunarYear, lunarMonth: lunarMonth)
        
        return LunarDate(
            day: lunarDay,
            month: lunarMonth,
            year: lunarYear,
            isLeapMonth: isLeap,
            jd: currentJd,
            canDay: canChi.canDay,
            chiDay: canChi.chiDay,
            canMonth: canChi.canMonth,
            chiMonth: canChi.chiMonth,
            canYear: canChi.canYear,
            chiYear: canChi.chiYear
        )
    }
    
    public func convertSolarToLunar(date: Date) -> LunarDate {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 7 * 3600) ?? .current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        return convertSolarToLunar(
            day: components.day ?? 1,
            month: components.month ?? 1,
            year: components.year ?? 2026
        )
    }
    
    // MARK: - 5. Public API: Lunar -> Solar
    
    /// Chuyển ngày Âm Lịch thành Dương Lịch (day, month, year)
    public func convertLunarToSolar(lunarDay: Int, lunarMonth: Int, lunarYear: Int, isLeap: Bool) -> (day: Int, month: Int, year: Int)? {
        var a11: Double = 0
        if lunarMonth < 11 {
            a11 = getLunarMonth11(year: lunarYear - 1, timeZone: timeZoneOffset)
        } else {
            a11 = getLunarMonth11(year: lunarYear, timeZone: timeZoneOffset)
        }
        
        let b11 = getLunarMonth11(year: lunarMonth < 11 ? lunarYear : lunarYear + 1, timeZone: timeZoneOffset)
        var offset = lunarMonth - 11
        if offset < 0 { offset += 12 }
        
        var totalMonths = Int(floor((b11 - a11) / 29.0))
        var leap = 0
        if totalMonths > 12 {
            leap = getLeapMonthOffset(a11: a11, timeZone: timeZoneOffset)
        }
        
        var k = Int(floor((a11 - 2415021.076998695) / 29.530588853 + 0.5))
        var monthIndex = offset
        if totalMonths > 12 && offset >= leap {
            if isLeap && offset == leap - 1 {
                monthIndex = leap
            } else if offset >= leap {
                monthIndex = offset + 1
            }
        }
        
        let monthStart = getNewMoonDay(k: k + monthIndex, timeZone: timeZoneOffset)
        let targetJd = monthStart + Double(lunarDay - 1)
        return jdToDate(jd: targetJd)
    }
}
