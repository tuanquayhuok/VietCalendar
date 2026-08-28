package com.vietcalendar.app.core.services

import com.vietcalendar.app.core.models.Holiday
import com.vietcalendar.app.core.models.HolidayType
import com.vietcalendar.app.core.models.UserEvent

object HolidayService {
    val allHolidays = listOf(
        // Dương Lịch
        Holiday(name = "Tết Dương Lịch", isLunar = false, day = 1, month = 1, type = HolidayType.NATIONAL, isDayOff = true),
        Holiday(name = "Ngày Thầy Thuốc VN", isLunar = false, day = 27, month = 2, type = HolidayType.CULTURAL),
        Holiday(name = "Quốc Tế Phụ Nữ", isLunar = false, day = 8, month = 3, type = HolidayType.CULTURAL),
        Holiday(name = "Giải Phóng Miền Nam", isLunar = false, day = 30, month = 4, type = HolidayType.NATIONAL, isDayOff = true),
        Holiday(name = "Quốc Tế Lao Động", isLunar = false, day = 1, month = 5, type = HolidayType.NATIONAL, isDayOff = true),
        Holiday(name = "Quốc Tế Thiếu Nhi", isLunar = false, day = 1, month = 6, type = HolidayType.CULTURAL),
        Holiday(name = "Thương Binh Liệt Sĩ", isLunar = false, day = 27, month = 7, type = HolidayType.CULTURAL),
        Holiday(name = "Quốc Khánh Nước CHXHCNVN", isLunar = false, day = 2, month = 9, type = HolidayType.NATIONAL, isDayOff = true),
        Holiday(name = "Phụ Nữ Việt Nam", isLunar = false, day = 20, month = 10, type = HolidayType.CULTURAL),
        Holiday(name = "Nhà Giáo Việt Nam", isLunar = false, day = 20, month = 11, type = HolidayType.CULTURAL),
        Holiday(name = "Quân Đội Nhân Dân VN", isLunar = false, day = 22, month = 12, type = HolidayType.CULTURAL),
        
        // Âm Lịch
        Holiday(name = "Tết Ông Công Ông Táo", isLunar = true, day = 23, month = 12, type = HolidayType.TRADITIONAL),
        Holiday(name = "Tất Niên", isLunar = true, day = 30, month = 12, type = HolidayType.TRADITIONAL),
        Holiday(name = "Mùng 1 Tết Nguyên Đán", isLunar = true, day = 1, month = 1, type = HolidayType.NATIONAL, isDayOff = true),
        Holiday(name = "Mùng 2 Tết", isLunar = true, day = 2, month = 1, type = HolidayType.NATIONAL, isDayOff = true),
        Holiday(name = "Mùng 3 Tết", isLunar = true, day = 3, month = 1, type = HolidayType.NATIONAL, isDayOff = true),
        Holiday(name = "Tết Nguyên Tiêu", isLunar = true, day = 15, month = 1, type = HolidayType.TRADITIONAL),
        Holiday(name = "Giỗ Tổ Hùng Vương", isLunar = true, day = 10, month = 3, type = HolidayType.NATIONAL, isDayOff = true),
        Holiday(name = "Tết Đoan Ngọ", isLunar = true, day = 5, month = 5, type = HolidayType.TRADITIONAL),
        Holiday(name = "Lễ Vu Lan (Báo Hiếu)", isLunar = true, day = 15, month = 7, type = HolidayType.TRADITIONAL),
        Holiday(name = "Tết Trung Thu", isLunar = true, day = 15, month = 8, type = HolidayType.TRADITIONAL),
        Holiday(name = "Tết Trùng Cửu", isLunar = true, day = 9, month = 9, type = HolidayType.TRADITIONAL)
    )
}
