package com.koreanhole.pluto.dropspot.wear

import android.content.Context
import android.os.Bundle
import android.util.Log
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.layout.*
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.wear.compose.foundation.lazy.AutoCenteringParams
import androidx.wear.compose.foundation.lazy.ScalingLazyColumn
import androidx.wear.compose.foundation.lazy.items
import androidx.wear.compose.foundation.lazy.rememberScalingLazyListState
import androidx.wear.compose.material.*
import com.google.android.gms.wearable.PutDataMapRequest
import com.google.android.gms.wearable.Wearable

class MainActivity : ComponentActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        
        setContent {
            DropspotWearApp(this)
        }
    }

    fun syncParkedLevelToPhone(parkedLevel: Int) {
        val dataClient = Wearable.getDataClient(this)
        val putDataMapReq = PutDataMapRequest.create("/watch_parking_update")
        
        // Add timestamp to ensure data item is always considered "changed"
        putDataMapReq.dataMap.putLong("timestamp", System.currentTimeMillis())
        putDataMapReq.dataMap.putInt("parkedLevel", parkedLevel)
        
        val putDataReq = putDataMapReq.asPutDataRequest().setUrgent()
        dataClient.putDataItem(putDataReq).addOnSuccessListener {
            Log.d("DropspotWear", "Successfully synced parked level $parkedLevel to phone")
        }.addOnFailureListener { e ->
            Log.e("DropspotWear", "Failed to sync parked level to phone", e)
        }
        
        // Also update local prefs for consistency
        val prefs = getSharedPreferences(DataLayerListenerService.PREFS_NAME, Context.MODE_PRIVATE)
        prefs.edit().putInt(DataLayerListenerService.KEY_PARKED_LEVEL, parkedLevel).apply()
    }
}

@Composable
fun DropspotWearApp(activity: MainActivity) {
    val prefs = activity.getSharedPreferences(DataLayerListenerService.PREFS_NAME, Context.MODE_PRIVATE)
    
    // State for parked level
    var parkedLevel by remember { 
        mutableStateOf(prefs.getInt(DataLayerListenerService.KEY_PARKED_LEVEL, -999)) 
    }
    
    // State for manual items
    val manualItemsString = prefs.getString(DataLayerListenerService.KEY_MANUAL_ITEMS, "") ?: ""
    val manualItems = remember(manualItemsString) {
        if (manualItemsString.isEmpty()) {
            listOf(-5, -4, -3, -2, -1, 0, 1, 2, 3, 4) // Default fallback
        } else {
            manualItemsString.split(",").mapNotNull { it.toIntOrNull() }
        }
    }

    val listState = rememberScalingLazyListState()

    MaterialTheme(
        colors = Colors(
            primary = Color(0xFF0051A2), // Match phone primaryColor
            secondary = Color(0xFFE3F2Fd), // Match phone secondaryColor
            background = Color.Black,
            onPrimary = Color.White,
            onSecondary = Color.Black,
        )
    ) {
        Scaffold(
            timeText = { TimeText() },
            vignette = { Vignette(vignettePosition = VignettePosition.TopAndBottom) },
            positionIndicator = { PositionIndicator(scalingLazyListState = listState) }
        ) {
            ScalingLazyColumn(
                modifier = Modifier.fillMaxSize(),
                state = listState,
                autoCentering = AutoCenteringParams(itemIndex = 1), // Center the first actual item
                contentPadding = PaddingValues(horizontal = 8.dp, vertical = 32.dp)
            ) {
                item {
                    ListHeader {
                        Text(
                            text = "현재 주차 위치",
                            textAlign = TextAlign.Center,
                            style = MaterialTheme.typography.caption1,
                            color = MaterialTheme.colors.secondary
                        )
                    }
                }

                // Current Status section
                item {
                    val statusText = if (parkedLevel == -999) "주차 정보 없음" else formatLevelText(parkedLevel)
                    Chip(
                        onClick = { /* No-op */ },
                        label = { 
                            Text(
                                text = statusText,
                                fontWeight = FontWeight.Bold
                            ) 
                        },
                        secondaryLabel = { Text("현재 상태") },
                        colors = ChipDefaults.secondaryChipColors(),
                        modifier = Modifier.fillMaxWidth().padding(bottom = 8.dp),
                        enabled = false
                    )
                }

                item {
                    Text(
                        text = "목록에서 선택",
                        style = MaterialTheme.typography.caption2,
                        modifier = Modifier.padding(vertical = 8.dp),
                        color = Color.Gray,
                        textAlign = TextAlign.Center
                    )
                }

                items(manualItems) { item ->
                    val isSelected = item == parkedLevel
                    Chip(
                        onClick = {
                            parkedLevel = item
                            activity.syncParkedLevelToPhone(item)
                        },
                        label = { 
                            Text(
                                text = formatLevelText(item),
                                textAlign = TextAlign.Center,
                                modifier = Modifier.fillMaxWidth()
                            ) 
                        },
                        colors = if (isSelected) {
                            ChipDefaults.primaryChipColors()
                        } else {
                            ChipDefaults.secondaryChipColors()
                        },
                        modifier = Modifier.fillMaxWidth()
                    )
                }
                
                item {
                    Spacer(modifier = Modifier.height(20.dp))
                }
                
                item {
                    // Reset button
                    Chip(
                        onClick = {
                            parkedLevel = -999
                            activity.syncParkedLevelToPhone(-999)
                        },
                        label = { 
                            Text(
                                "정보 초기화",
                                textAlign = TextAlign.Center,
                                modifier = Modifier.fillMaxWidth()
                            ) 
                        },
                        colors = ChipDefaults.chipColors(backgroundColor = Color.DarkGray, contentColor = Color.White),
                        modifier = Modifier.fillMaxWidth()
                    )
                }
            }
        }
    }
}

fun formatLevelText(level: Int): String {
    return if (level >= 0) {
        "지상 ${level}층"
    } else {
        "지하 ${-level}층"
    }
}
