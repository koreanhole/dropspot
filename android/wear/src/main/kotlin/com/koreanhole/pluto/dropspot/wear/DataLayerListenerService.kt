package com.koreanhole.pluto.dropspot.wear

import android.content.Context
import android.util.Log
import androidx.wear.tiles.TileService
import androidx.wear.watchface.complications.datasource.ComplicationDataSourceUpdateRequester
import com.google.android.gms.wearable.DataEvent
import com.google.android.gms.wearable.DataEventBuffer
import com.google.android.gms.wearable.DataMapItem
import com.google.android.gms.wearable.WearableListenerService

class DataLayerListenerService : WearableListenerService() {
    companion object {
        const val PREFS_NAME = "DropspotWearPrefs"
        const val KEY_MANUAL_ITEMS = "manualParkingItems"
        const val KEY_PARKED_LEVEL = "parkedLevel"
        const val TAG = "DataLayerListenerService"
    }

    override fun onDataChanged(dataEvents: DataEventBuffer) {
        super.onDataChanged(dataEvents)
        val prefs = getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
        var updated = false

        for (event in dataEvents) {
            if (event.type == DataEvent.TYPE_CHANGED && event.dataItem.uri.path == "/parking_data") {
                val dataMap = DataMapItem.fromDataItem(event.dataItem).dataMap
                val editor = prefs.edit()
                
                if (dataMap.containsKey("manualParkingItems")) {
                    val list = dataMap.getIntegerArrayList("manualParkingItems")
                    if (list != null) {
                        // Store as comma separated string
                        editor.putString(KEY_MANUAL_ITEMS, list.joinToString(","))
                        updated = true
                        Log.d(TAG, "Saved manualParkingItems: $list")
                    }
                }
                
                if (dataMap.containsKey("parkedLevel")) {
                    val parkedLevel = dataMap.getInt("parkedLevel")
                    editor.putInt(KEY_PARKED_LEVEL, parkedLevel)
                    updated = true
                    Log.d(TAG, "Saved parkedLevel: $parkedLevel")
                }
                
                editor.apply()
            }
        }

        if (updated) {
            // Update tile using standard TileService updater
            try {
                TileService.getUpdater(this)
                    .requestUpdate(ParkingTileService::class.java)
            } catch (e: Exception) {
                Log.e(TAG, "Failed to update tile", e)
            }
            
            // Update complications
            val componentName = android.content.ComponentName(this, ParkingComplicationService::class.java)
            ComplicationDataSourceUpdateRequester
                .create(this, componentName)
                .requestUpdateAll()
        }
    }
}
