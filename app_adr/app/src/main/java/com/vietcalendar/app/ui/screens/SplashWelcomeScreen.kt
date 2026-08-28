package com.vietcalendar.app.ui.screens

import androidx.compose.animation.core.*
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.draw.shadow
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.graphicsLayer
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import kotlinx.coroutines.delay

@Composable
fun SplashWelcomeScreen(onFinished: () -> Unit) {
    var pageNumber by remember { mutableStateOf(1) }
    var flipAngle by remember { mutableStateOf(0f) }
    
    val flipDays = listOf(
        Triple("26", "15/7", "THỨ HAI"),
        Triple("27", "16/7", "THỨ BA"),
        Triple("28", "17/7", "THỨ TƯ"),
        Triple("29", "18/7", "THỨ NĂM"),
        Triple("01", "MÙNG 1", "HÔM NAY")
    )
    
    LaunchedEffect(Unit) {
        val intervals = listOf(500L, 500L, 500L, 500L, 400L)
        for (i in intervals.indices) {
            delay(intervals[i])
            flipAngle = -25f
            delay(100L)
            pageNumber = i + 1
            flipAngle = 0f
        }
        delay(500L)
        onFinished()
    }
    
    val currentDay = flipDays[minOf(pageNumber - 1, flipDays.size - 1)]
    
    Box(
        modifier = Modifier
            .fillMaxSize()
            .background(Color(0xFF0F172A)),
        contentAlignment = Alignment.Center
    ) {
        Column(
            horizontalAlignment = Alignment.CenterHorizontally,
            verticalArrangement = Arrangement.Center,
            modifier = Modifier.padding(24.dp)
        ) {
            Spacer(modifier = Modifier.weight(1f))
            
            // 3D Bloc Calendar
            Card(
                shape = RoundedCornerShape(20.dp),
                elevation = CardDefaults.cardElevation(defaultElevation = 16.dp),
                modifier = Modifier
                    .width(200.dp)
                    .height(220.dp)
                    .graphicsLayer {
                        rotationX = flipAngle
                        cameraDistance = 12f * density
                    }
            ) {
                Column(modifier = Modifier.fillMaxSize()) {
                    // Red Bloc Header
                    Box(
                        modifier = Modifier
                            .fillMaxWidth()
                            .height(54.dp)
                            .background(
                                Brush.verticalGradient(
                                    colors = listOf(Color(0xFF991B1B), Color(0xFFDC2626))
                                )
                            ),
                        contentAlignment = Alignment.Center
                    ) {
                        Row(
                            horizontalArrangement = Arrangement.SpaceEvenly,
                            modifier = Modifier.fillMaxWidth(0.7f)
                        ) {
                            Box(
                                modifier = Modifier
                                    .size(14.dp)
                                    .clip(CircleShape)
                                    .background(Color(0xFFFDE047))
                            )
                            Box(
                                modifier = Modifier
                                    .size(14.dp)
                                    .clip(CircleShape)
                                    .background(Color(0xFFFDE047))
                            )
                        }
                    }
                    
                    // White Calendar Sheet
                    Column(
                        horizontalAlignment = Alignment.CenterHorizontally,
                        verticalArrangement = Arrangement.Center,
                        modifier = Modifier
                            .fillMaxSize()
                            .background(Color(0xFFF8FAFC))
                            .padding(8.dp)
                    ) {
                        Text(
                            text = currentDay.third,
                            color = Color(0xFFDC2626),
                            fontSize = 12.sp,
                            fontWeight = FontWeight.Bold,
                            fontFamily = FontFamily.Monospace
                        )
                        Text(
                            text = currentDay.first,
                            color = Color(0xFF0F172A),
                            fontSize = 62.sp,
                            fontWeight = FontWeight.ExtraBold,
                            lineHeight = 62.sp
                        )
                        Text(
                            text = "Âm lịch: ${currentDay.second}",
                            color = Color(0xFF64748B),
                            fontSize = 12.sp,
                            fontWeight = FontWeight.SemiBold
                        )
                    }
                }
            }
            
            Spacer(modifier = Modifier.height(28.dp))
            
            // Typography
            Text(
                text = "LỊCH VIỆT NAM",
                color = Color.White,
                fontSize = 24.sp,
                fontWeight = FontWeight.Bold,
                letterSpacing = 3.sp
            )
            
            Spacer(modifier = Modifier.height(6.dp))
            
            Text(
                text = "by trongtuandev",
                color = Color(0xFF94A3B8),
                fontSize = 14.sp,
                fontWeight = FontWeight.Medium,
                fontFamily = FontFamily.Monospace
            )
            
            Spacer(modifier = Modifier.weight(1.5f))
        }
    }
}
