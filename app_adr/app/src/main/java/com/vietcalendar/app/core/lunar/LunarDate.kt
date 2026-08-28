package com.vietcalendar.app.core.lunar

data class LunarDate(
    val day: Int,
    val month: Int,
    val year: Int,
    val isLeapMonth: Boolean,
    val jd: Double = 0.0,
    val canDay: String = "",
    val chiDay: String = "",
    val canMonth: String = "",
    val chiMonth: String = "",
    val canYear: String = "",
    val chiYear: String = ""
) {
    val dayName: String get() = "$canDay $chiDay"
    val monthName: String get() = "$canMonth $chiMonth" + if (isLeapMonth) " (Nhuận)" else ""
    val yearName: String get() = "$canYear $chiYear"
    val formattedShort: String get() = "$day/$month" + if (isLeapMonth) "N" else ""
    val formattedFull: String get() = "Ngày $day tháng $month" + (if (isLeapMonth) " nhuận" else "") + " năm $yearName"
}
