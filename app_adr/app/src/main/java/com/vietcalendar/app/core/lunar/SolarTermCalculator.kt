package com.vietcalendar.app.core.lunar

object SolarTermCalculator {
    private val SOLAR_TERMS = listOf(
        "Xuân Phân", "Thanh Minh", "Cốc Vũ", "Lập Hạ", "Tiểu Mãn", "Mang Chủng",
        "Hạ Chí", "Tiểu Thử", "Đại Thử", "Lập Thu", "Xử Thử", "Bạch Lộ",
        "Thu Phân", "Hàn Lộ", "Sương Giáng", "Lập Đông", "Tiểu Tuyết", "Đại Tuyết",
        "Đông Chí", "Tiểu Hàn", "Đại Hàn", "Lập Xuân", "Vũ Thủy", "Kinh Trập"
    )
    
    fun getSolarTerm(day: Int, month: Int, year: Int): String? {
        val jd = LunarCalendarConverter.jdFromDate(day, month, year)
        val t = (jd - 2451545.0) / 36525.0
        val l0 = 280.46645 + 36000.76983 * t
        val m = 357.52910 + 35999.05030 * t
        val c = 1.914600 * kotlin.math.sin(m * Math.PI / 180)
        val sunLong = (l0 + c) % 360.0
        val index = kotlin.math.floor(sunLong / 15.0).toInt()
        return if (index in SOLAR_TERMS.indices) SOLAR_TERMS[index] else null
    }
}
