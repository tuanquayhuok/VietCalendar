package com.vietcalendar.app.core.lunar

import java.util.Calendar
import java.util.Date
import kotlin.math.*

object LunarCalendarConverter {
    private const val TIME_ZONE = 7.0
    
    private val CAN = listOf("Giáp", "Ất", "Bính", "Đinh", "Mậu", "Kỷ", "Canh", "Tân", "Nhâm", "Quý")
    private val CHI = listOf("Tý", "Sửu", "Dần", "Mão", "Thìn", "Tỵ", "Ngọ", "Mùi", "Thân", "Dậu", "Tuất", "Hợi")
    
    fun jdFromDate(dd: Int, mm: Int, yy: Int): Double {
        val a = (14 - mm) / 12
        val y = yy + 4800 - a
        val m = mm + 12 * a - 3
        var jd = dd + (153 * m + 2) / 5 + 365 * y + y / 4 - y / 100 + y / 400 - 32045.0
        if (jd < 2299161) {
            jd = dd + (153 * m + 2) / 5 + 365 * y + y / 4 - 32083.0
        }
        return jd
    }
    
    fun jdToDate(jd: Double): Triple<Int, Int, Int> {
        val z = floor(jd + 0.5).toInt()
        var a = z
        if (z >= 2299161) {
            val alpha = floor((z - 1867216.25) / 36524.25).toInt()
            a = z + 1 + alpha - alpha / 4
        }
        val b = a + 1524
        val c = floor((b - 122.1) / 365.25).toInt()
        val d = floor(365.25 * c).toInt()
        val e = floor((b - d) / 30.6001).toInt()
        val day = b - d - floor(30.6001 * e).toInt()
        val month = if (e < 14) e - 1 else e - 13
        val year = if (month > 2) c - 4716 else c - 4715
        return Triple(day, month, year)
    }
    
    private fun getNewMoonDay(k: Int, timeZone: Double): Double {
        val t = k / 1236.85
        val t2 = t * t
        val t3 = t2 * t
        val dr = Math.PI / 180
        var jd1 = 2415020.75933 + 29.53058868 * k + 0.0001178 * t2 - 0.000000155 * t3
        jd1 += 0.00033 * sin((166.56 + 132.87 * t - 0.009173 * t2) * dr)
        val m = 359.2242 + 29.10535608 * k - 0.0000333 * t2 - 0.00000347 * t3
        val mpr = 306.0253 + 385.81691806 * k + 0.0107306 * t2 + 0.00001236 * t3
        val f = 21.2964 + 390.67050646 * k - 0.0016528 * t2 - 0.00000239 * t3
        var c1 = (0.1734 - 0.000393 * t) * sin(m * dr) + 0.0021 * sin(2 * m * dr)
        c1 -= 0.4068 * sin(mpr * dr) + 0.0161 * sin(2 * mpr * dr)
        c1 -= 0.0004 * sin(3 * mpr * dr)
        c1 += 0.0104 * sin(2 * f * dr) - 0.0051 * sin((m + mpr) * dr)
        c1 -= 0.0074 * sin((m - mpr) * dr) + 0.0004 * sin((2 * f + m) * dr)
        c1 -= 0.0004 * sin((2 * f - m) * dr) - 0.0006 * sin((2 * f + mpr) * dr)
        c1 += 0.0010 * sin((2 * f - mpr) * dr) + 0.0005 * sin((m + 2 * mpr) * dr)
        val jd = jd1 + c1
        return floor(jd + 0.5 + timeZone / 24.0)
    }
    
    private fun getSunLongitude(jdn: Double, timeZone: Double): Double {
        val t = (jdn - 0.5 - timeZone / 24.0 - 2451545.0) / 36525.0
        val t2 = t * t
        val dr = Math.PI / 180
        val l0 = 280.46645 + 36000.76983 * t + 0.0003032 * t2
        val m = 357.52910 + 35999.05030 * t - 0.0001559 * t2 - 0.00000048 * t * t2
        val c = (1.914600 - 0.004817 * t - 0.000014 * t2) * sin(m * dr) +
                (0.019993 - 0.000101 * t) * sin(2 * m * dr) +
                0.000290 * sin(3 * m * dr)
        var theta = l0 + c
        theta = (theta % 360 + 360) % 360
        return floor(theta / 30.0)
    }
    
    private fun getLunarMonth11(yy: Int, timeZone: Double): Double {
        val off = jdFromDate(31, 12, yy) - 2415021.076998695
        val k = floor(off / 29.530588853).toInt()
        var nm = getNewMoonDay(k, timeZone)
        val sunLong = getSunLongitude(nm, timeZone)
        if (sunLong >= 9.0) {
            nm = getNewMoonDay(k - 1, timeZone)
        }
        return nm
    }
    
    fun convertSolarToLunar(day: Int, month: Int, year: Int): LunarDate {
        val dayNumber = jdFromDate(day, month, year)
        val k = floor((dayNumber - 2415021.076998695) / 29.530588853).toInt()
        var monthStart = getNewMoonDay(k + 1, TIME_ZONE)
        if (monthStart > dayNumber) {
            monthStart = getNewMoonDay(k, TIME_ZONE)
        }
        var a11 = getLunarMonth11(year, TIME_ZONE)
        var b11 = a11
        val lunarYear: Int
        if (a11 >= monthStart) {
            lunarYear = year
            a11 = getLunarMonth11(year - 1, TIME_ZONE)
        } else {
            lunarYear = year + 1
            b11 = getLunarMonth11(year + 1, TIME_ZONE)
        }
        val lunarDay = (dayNumber - monthStart + 1).toInt()
        val diff = floor((monthStart - a11) / 29.0).toInt()
        var isLeap = false
        var lunarMonth = diff + 11
        if (b11 - a11 > 365.0) {
            val leapMonthDiff = getLeapMonthOffset(a11, TIME_ZONE)
            if (diff >= leapMonthDiff) {
                lunarMonth = diff + 10
                if (diff == leapMonthDiff) {
                    isLeap = true
                }
            }
        }
        if (lunarMonth > 12) {
            lunarMonth -= 12
        }
        if (lunarMonth >= 11 && diff < 4) {
            // keep year
        }
        
        val canDay = CAN[((dayNumber + 9) % 10).toInt()]
        val chiDay = CHI[((dayNumber + 1) % 12).toInt()]
        val canMonth = CAN[(lunarYear * 12 + lunarMonth + 3) % 10]
        val chiMonth = CHI[(lunarMonth + 1) % 12]
        val canYear = CAN[(lunarYear + 6) % 10]
        val chiYear = CHI[(lunarYear + 8) % 12]
        
        return LunarDate(
            day = lunarDay,
            month = lunarMonth,
            year = lunarYear,
            isLeapMonth = isLeap,
            jd = dayNumber,
            canDay = canDay,
            chiDay = chiDay,
            canMonth = canMonth,
            chiMonth = chiMonth,
            canYear = canYear,
            chiYear = chiYear
        )
    }
    
    private fun getLeapMonthOffset(a11: Double, timeZone: Double): Int {
        val k = floor((a11 - 2415021.076998695) / 29.530588853 + 0.5).toInt()
        var last = 0.0
        var i = 1
        var arc = getSunLongitude(getNewMoonDay(k + i, timeZone), timeZone)
        do {
            last = arc
            i++
            arc = getSunLongitude(getNewMoonDay(k + i, timeZone), timeZone)
        } while (arc != last && i < 14)
        return i - 1
    }
}
