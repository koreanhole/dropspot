package com.koreanhole.pluto.dropspot.wear

import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import androidx.wear.watchface.complications.data.ComplicationData
import androidx.wear.watchface.complications.data.ComplicationType
import androidx.wear.watchface.complications.data.PlainComplicationText
import androidx.wear.watchface.complications.data.ShortTextComplicationData
import androidx.wear.watchface.complications.datasource.ComplicationRequest
import androidx.wear.watchface.complications.datasource.SuspendingComplicationDataSourceService

class ParkingComplicationService : SuspendingComplicationDataSourceService() {

    override fun getPreviewData(type: ComplicationType): ComplicationData? {
        if (type != ComplicationType.SHORT_TEXT) {
            return null
        }
        return createComplicationData("B2")
    }

    override suspend fun onComplicationRequest(request: ComplicationRequest): ComplicationData? {
        if (request.complicationType != ComplicationType.SHORT_TEXT) {
            return null
        }

        val prefs = getSharedPreferences(DataLayerListenerService.PREFS_NAME, Context.MODE_PRIVATE)
        val parkedLevel = prefs.getInt(DataLayerListenerService.KEY_PARKED_LEVEL, -999)
        
        val text = if (parkedLevel == -999) {
            "--"
        } else if (parkedLevel >= 0) {
            "${parkedLevel}F"
        } else {
            "B${-parkedLevel}"
        }

        return createComplicationData(text)
    }

    private fun createComplicationData(text: String): ComplicationData {
        val intent = Intent(this, MainActivity::class.java).apply {
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK
        }
        val pendingIntent = PendingIntent.getActivity(
            this,
            0,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        return ShortTextComplicationData.Builder(
            PlainComplicationText.Builder(text).build(),
            PlainComplicationText.Builder("Dropspot").build()
        )
        .setTapAction(pendingIntent)
        .build()
    }
}
