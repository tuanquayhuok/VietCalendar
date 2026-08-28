package com.vietcalendar.app

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.grid.*
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.DateRange
import androidx.compose.material.icons.filled.Settings
import androidx.compose.material.icons.filled.SwapHoriz
import androidx.compose.material.icons.filled.ChevronLeft
import androidx.compose.material.icons.filled.ChevronRight
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.vietcalendar.app.core.lunar.LunarCalendarConverter
import com.vietcalendar.app.core.lunar.SolarTermCalculator
import com.vietcalendar.app.ui.screens.SplashWelcomeScreen
import java.util.Calendar

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            VietCalendarApp()
        }
    }
}

@Composable
fun VietCalendarApp() {
    var showSplash by remember { mutableStateOf(true) }
    var selectedTab by remember { mutableStateOf(0) }
    
    if (showSplash) {
        SplashWelcomeScreen(onFinished = { showSplash = false })
    } else {
        Scaffold(
            bottomBar = {
                NavigationBar(containerColor = MaterialTheme.colorScheme.surface) {
                    val items = listOf(
                        Triple("Lịch Tháng", Icons.Default.DateRange, 0),
                        Triple("Đổi Ngày", Icons.Default.SwapHoriz, 1),
                        Triple("Cài Đặt", Icons.Default.Settings, 2)
                    )
                    items.forEach { (title, icon, index) ->
                        NavigationBarItem(
                            selected = selectedTab == index,
                            onClick = { selectedTab = index },
                            icon = { Icon(icon, contentDescription = title) },
                            label = { Text(title) },
                            colors = NavigationBarItemDefaults.colors(
                                selectedIconColor = Color(0xFFDC2626),
                                selectedTextColor = Color(0xFFDC2626),
                                indicatorColor = Color(0xFFDC2626).copy(alpha = 0.12f)
                            )
                        )
                    }
                }
            }
        ) { padding ->
            Box(modifier = Modifier.padding(padding).fillMaxSize()) {
                when (selectedTab) {
                    0 -> CalendarScreen()
                    1 -> ConvertDateScreen()
                    2 -> SettingsScreen()
                }
            }
        }
    }
}

@Composable
fun CalendarScreen() {
    val cal = Calendar.getInstance()
    var currentYear by remember { mutableStateOf(cal.get(Calendar.YEAR)) }
    var currentMonth by remember { mutableStateOf(cal.get(Calendar.MONTH) + 1) }
    var selectedDay by remember { mutableStateOf(cal.get(Calendar.DAY_OF_MONTH)) }
    
    val lunarDate = remember(selectedDay, currentMonth, currentYear) {
        LunarCalendarConverter.convertSolarToLunar(selectedDay, currentMonth, currentYear)
    }
    val solarTerm = remember(selectedDay, currentMonth, currentYear) {
        SolarTermCalculator.getSolarTerm(selectedDay, currentMonth, currentYear)
    }
    
    Column(modifier = Modifier.fillMaxSize().padding(16.dp)) {
        // Month Navigation Header
        Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.SpaceBetween,
            verticalAlignment = Alignment.CenterVertically
        ) {
            Column {
                Text(
                    text = "Tháng $currentMonth, $currentYear",
                    fontSize = 22.sp,
                    fontWeight = FontWeight.Bold
                )
                Text(
                    text = "Năm ${lunarDate.yearName} (${lunarDate.monthName})",
                    fontSize = 13.sp,
                    color = Color.Gray
                )
            }
            Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                IconButton(onClick = {
                    if (currentMonth == 1) { currentMonth = 12; currentYear-- } else { currentMonth-- }
                }) {
                    Icon(Icons.Default.ChevronLeft, contentDescription = "Tháng trước")
                }
                IconButton(onClick = {
                    if (currentMonth == 12) { currentMonth = 1; currentYear++ } else { currentMonth++ }
                }) {
                    Icon(Icons.Default.ChevronRight, contentDescription = "Tháng sau")
                }
            }
        }
        
        Spacer(modifier = Modifier.height(12.dp))
        
        // Weekday Header
        val weekdays = listOf("T2", "T3", "T4", "T5", "T6", "T7", "CN")
        Row(modifier = Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceAround) {
            weekdays.forEachIndexed { idx, w ->
                Text(
                    text = w,
                    fontWeight = FontWeight.Bold,
                    fontSize = 12.sp,
                    color = if (idx >= 5) Color(0xFFDC2626) else Color.Gray
                )
            }
        }
        
        Spacer(modifier = Modifier.height(8.dp))
        
        // Month Days Grid (1..30)
        LazyVerticalGrid(columns = GridCells.Fixed(7), modifier = Modifier.fillMaxWidth()) {
            items((1..30).toList()) { d ->
                val isSelected = d == selectedDay
                val cellLunar = LunarCalendarConverter.convertSolarToLunar(d, currentMonth, currentYear)
                
                Card(
                    onClick = { selectedDay = d },
                    shape = RoundedCornerShape(10.dp),
                    colors = CardDefaults.cardColors(
                        containerColor = if (isSelected) Color(0xFFDC2626) else Color.Transparent
                    ),
                    modifier = Modifier.padding(2.dp).height(54.dp)
                ) {
                    Column(
                        modifier = Modifier.fillMaxSize(),
                        horizontalAlignment = Alignment.CenterHorizontally,
                        verticalArrangement = Arrangement.Center
                    ) {
                        Text(
                            text = "$d",
                            fontWeight = FontWeight.Bold,
                            fontSize = 16.sp,
                            color = if (isSelected) Color.White else Color.Black
                        )
                        Text(
                            text = cellLunar.formattedShort,
                            fontSize = 10.sp,
                            color = if (isSelected) Color(0xFFFEF08A) else Color(0xFFD97706)
                        )
                    }
                }
            }
        }
        
        Spacer(modifier = Modifier.height(16.dp))
        
        // Day Details Card
        Card(
            shape = RoundedCornerShape(16.dp),
            colors = CardDefaults.cardColors(containerColor = Color(0xFFF8FAFC)),
            modifier = Modifier.fillMaxWidth()
        ) {
            Column(modifier = Modifier.padding(16.dp)) {
                Text(
                    text = "Dương Lịch: Ngày $selectedDay tháng $currentMonth năm $currentYear",
                    fontWeight = FontWeight.Bold,
                    fontSize = 16.sp
                )
                Spacer(modifier = Modifier.height(4.dp))
                Text(
                    text = "Âm Lịch: ${lunarDate.formattedFull}",
                    fontWeight = FontWeight.SemiBold,
                    color = Color(0xFFD97706),
                    fontSize = 14.sp
                )
                Spacer(modifier = Modifier.height(4.dp))
                Text(
                    text = "Can Chi: Ngày ${lunarDate.dayName}, Giờ Hoàng Đạo trong ngày",
                    fontSize = 13.sp,
                    color = Color(0xFF64748B)
                )
                if (solarTerm != null) {
                    Spacer(modifier = Modifier.height(4.dp))
                    Text(
                        text = "Tiết Khí: $solarTerm",
                        fontSize = 13.sp,
                        color = Color(0xFF059669),
                        fontWeight = FontWeight.SemiBold
                    )
                }
            }
        }
    }
}

@Composable
fun ConvertDateScreen() {
    var dayInput by remember { mutableStateOf("1") }
    var monthInput by remember { mutableStateOf("1") }
    var yearInput by remember { mutableStateOf("2026") }
    
    val d = dayInput.toIntOrNull() ?: 1
    val m = monthInput.toIntOrNull() ?: 1
    val y = yearInput.toIntOrNull() ?: 2026
    val result = remember(d, m, y) { LunarCalendarConverter.convertSolarToLunar(d, m, y) }
    
    Column(modifier = Modifier.fillMaxSize().padding(16.dp)) {
        Text(text = "Chuyển Đổi Ngày Âm ↔ Dương", fontSize = 20.sp, fontWeight = FontWeight.Bold)
        Spacer(modifier = Modifier.height(16.dp))
        Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
            OutlinedTextField(value = dayInput, onValueChange = { dayInput = it }, label = { Text("Ngày") }, modifier = Modifier.weight(1f))
            OutlinedTextField(value = monthInput, onValueChange = { monthInput = it }, label = { Text("Tháng") }, modifier = Modifier.weight(1f))
            OutlinedTextField(value = yearInput, onValueChange = { yearInput = it }, label = { Text("Năm") }, modifier = Modifier.weight(1.5f))
        }
        Spacer(modifier = Modifier.height(20.dp))
        Card(shape = RoundedCornerShape(16.dp), modifier = Modifier.fillMaxWidth()) {
            Column(modifier = Modifier.padding(16.dp)) {
                Text(text = "Kết quả Âm Lịch:", fontWeight = FontWeight.Bold, color = Color(0xFFDC2626))
                Spacer(modifier = Modifier.height(6.dp))
                Text(text = result.formattedFull, fontSize = 16.sp)
                Text(text = "Can Chi: ${result.dayName} - ${result.monthName} - ${result.yearName}", color = Color.Gray, fontSize = 14.sp)
            }
        }
    }
}

@Composable
fun SettingsScreen() {
    Column(modifier = Modifier.fillMaxSize().padding(16.dp)) {
        Text(text = "Cài Đặt", fontSize = 20.sp, fontWeight = FontWeight.Bold)
        Spacer(modifier = Modifier.height(16.dp))
        Card(shape = RoundedCornerShape(16.dp), modifier = Modifier.fillMaxWidth()) {
            Column(modifier = Modifier.padding(16.dp)) {
                Text(text = "by trongtuandev", fontWeight = FontWeight.Bold, fontSize = 16.sp)
                Text(text = "Tác giả & Nhà phát triển ứng dụng", fontSize = 13.sp, color = Color.Gray)
                Spacer(modifier = Modifier.height(12.dp))
                Text(text = "Phiên bản: 1.3.1 Android Native (Kotlin)", fontSize = 13.sp)
                Text(text = "Thuật toán: Hồ Ngọc Đức (GMT+7)", fontSize = 13.sp)
            }
        }
    }
}
