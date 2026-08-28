package com.vietcalendar.app.core.models

import com.vietcalendar.app.core.lunar.LunarDate
import java.util.UUID

enum class HolidayType(val displayName: String) {
    NATIONAL("Quốc Gia"),
    TRADITIONAL("Truyền Thống"),
    CULTURAL("Văn Hóa")
}

data class Holiday(
    val id: String = UUID.randomUUID().toString(),
    val name: String,
    val isLunar: Boolean,
    val day: Int,
    val month: Int,
    val type: HolidayType,
    val isDayOff: Boolean = false
)

enum class EventRepeatType(val displayName: String) {
    NONE("Không lặp lại"),
    YEARLY_SOLAR("Hàng năm (Dương Lịch)"),
    YEARLY_LUNAR("Hàng năm (Âm Lịch - Giỗ chạp)")
}

data class UserEvent(
    val id: String = UUID.randomUUID().toString(),
    val title: String,
    val notes: String = "",
    val day: Int,
    val month: Int,
    val year: Int,
    val isLunarBased: Boolean = false,
    val repeatType: EventRepeatType = EventRepeatType.NONE,
    val colorHex: String = "#DC2626",
    val hasReminder: Boolean = false
)

data class CalendarDay(
    val day: Int,
    val month: Int,
    val year: Int,
    val isCurrentMonth: Boolean,
    val isToday: Boolean,
    val lunarDate: LunarDate,
    val holidays: List<Holiday> = emptyList(),
    val events: List<UserEvent> = emptyList(),
    val solarTerm: String? = null
)
