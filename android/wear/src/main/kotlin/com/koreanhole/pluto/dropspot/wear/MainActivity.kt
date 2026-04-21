package com.koreanhole.pluto.dropspot.wear

import android.content.Context
import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.wear.compose.material.MaterialTheme
import androidx.wear.compose.material.Text
import androidx.wear.compose.material.Typography

class MainActivity : ComponentActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        
        val prefs = getSharedPreferences(DataLayerListenerService.PREFS_NAME, Context.MODE_PRIVATE)
        val parkedLevel = prefs.getInt(DataLayerListenerService.KEY_PARKED_LEVEL, -999)
        
        val levelText = if (parkedLevel == -999) {
            "알 수 없음"
        } else if (parkedLevel >= 0) {
            "지상 ${parkedLevel}층"
        } else {
            "지하 ${-parkedLevel}층"
        }

        setContent {
            MaterialTheme {
                Box(
                    modifier = Modifier
                        .fillMaxSize()
                        .background(MaterialTheme.colors.background),
                    contentAlignment = Alignment.Center
                ) {
                    Text(
                        text = levelText,
                        style = MaterialTheme.typography.display1,
                        color = MaterialTheme.colors.primary
                    )
                }
            }
        }
    }
}
