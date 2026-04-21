package com.koreanhole.pluto.dropspot.wear

import android.content.Context
import android.util.Log
import androidx.wear.protolayout.ActionBuilders
import androidx.wear.protolayout.DeviceParametersBuilders
import androidx.wear.protolayout.LayoutElementBuilders
import androidx.wear.protolayout.ModifiersBuilders
import androidx.wear.protolayout.ResourceBuilders
import androidx.wear.protolayout.TimelineBuilders
import androidx.wear.protolayout.material.Button
import androidx.wear.protolayout.material.ButtonColors
import androidx.wear.protolayout.material.Colors
import androidx.wear.protolayout.material.Text
import androidx.wear.protolayout.material.Typography
import androidx.wear.protolayout.material.layouts.MultiButtonLayout
import androidx.wear.protolayout.material.layouts.PrimaryLayout
import androidx.wear.tiles.RequestBuilders
import androidx.wear.tiles.TileBuilders
import androidx.wear.tiles.TileService
import com.google.android.gms.wearable.PutDataMapRequest
import com.google.android.gms.wearable.Wearable
import com.google.android.horologist.annotations.ExperimentalHorologistApi
import com.google.android.horologist.tiles.SuspendingTileService

@OptIn(ExperimentalHorologistApi::class)
class ParkingTileService : SuspendingTileService() {
    companion object {
        const val RESOURCES_VERSION = "1"
        const val ACTION_PARK_PREFIX = "action_park:"
    }

    override suspend fun resourcesRequest(
        requestParams: RequestBuilders.ResourcesRequest
    ): ResourceBuilders.Resources {
        return ResourceBuilders.Resources.Builder()
            .setVersion(RESOURCES_VERSION)
            .build()
    }

    override suspend fun tileRequest(
        requestParams: RequestBuilders.TileRequest
    ): TileBuilders.Tile {
        val state = requestParams.currentState
        val clickableId = state.lastClickableId
        
        if (clickableId.startsWith(ACTION_PARK_PREFIX)) {
            val levelStr = clickableId.removePrefix(ACTION_PARK_PREFIX)
            val level = levelStr.toIntOrNull()
            if (level != null) {
                saveParkedLevel(level)
            }
        }

        val prefs = getSharedPreferences(DataLayerListenerService.PREFS_NAME, Context.MODE_PRIVATE)
        val itemsStr = prefs.getString(DataLayerListenerService.KEY_MANUAL_ITEMS, "-5,-4,-3,-2,-1,0,1,2,3,4") ?: "-5,-4,-3,-2,-1,0,1,2,3,4"
        val parkedLevel = prefs.getInt(DataLayerListenerService.KEY_PARKED_LEVEL, -999)
        
        val items = itemsStr.split(",").mapNotNull { it.toIntOrNull() }.take(5)

        val deviceParams = requestParams.deviceConfiguration

        return TileBuilders.Tile.Builder()
            .setResourcesVersion(RESOURCES_VERSION)
            .setTileTimeline(
                TimelineBuilders.Timeline.Builder()
                    .addTimelineEntry(
                        TimelineBuilders.TimelineEntry.Builder()
                            .setLayout(
                                LayoutElementBuilders.Layout.Builder()
                                    .setRoot(tileLayout(items, parkedLevel, deviceParams))
                                    .build()
                            )
                            .build()
                    )
                    .build()
            )
            .build()
    }

    private fun getReadableLevel(level: Int): String {
        return if (level >= 0) "${level}F" else "B${-level}"
    }

    private fun tileLayout(
        items: List<Int>, 
        currentParkedLevel: Int, 
        deviceParams: DeviceParametersBuilders.DeviceParameters
    ): LayoutElementBuilders.LayoutElement {
        val multiButtonLayout = MultiButtonLayout.Builder()

        items.forEach { level ->
            val isSelected = level == currentParkedLevel
            val colors = if (isSelected) {
                ButtonColors.primaryButtonColors(Colors.DEFAULT)
            } else {
                ButtonColors.secondaryButtonColors(Colors.DEFAULT)
            }

            // Simplified: Use unique ID per level instead of ActionExtras
            val clickable = ModifiersBuilders.Clickable.Builder()
                .setId(ACTION_PARK_PREFIX + level)
                .setOnClick(ActionBuilders.LoadAction.Builder().build())
                .build()

            val button = Button.Builder(this, clickable)
                .setTextContent(getReadableLevel(level))
                .setButtonColors(colors)
                .build()

            multiButtonLayout.addButtonContent(button)
        }

        return PrimaryLayout.Builder(deviceParams)
            .setPrimaryLabelTextContent(
                Text.Builder(this, "Dropspot")
                    .setTypography(Typography.TYPOGRAPHY_CAPTION1)
                    .build()
            )
            .setContent(multiButtonLayout.build())
            .build()
    }

    private fun saveParkedLevel(level: Int) {
        val prefs = getSharedPreferences(DataLayerListenerService.PREFS_NAME, Context.MODE_PRIVATE)
        prefs.edit().putInt(DataLayerListenerService.KEY_PARKED_LEVEL, level).apply()

        // Sync back to phone
        try {
            val dataClient = Wearable.getDataClient(this)
            val putDataMapReq = PutDataMapRequest.create("/watch_parking_update")
            putDataMapReq.dataMap.putLong("timestamp", System.currentTimeMillis())
            putDataMapReq.dataMap.putInt("parkedLevel", level)
            dataClient.putDataItem(putDataMapReq.asPutDataRequest().setUrgent())
        } catch (e: Exception) {
            Log.e("DropspotWear", "Failed to sync wear update", e)
        }

        // Update tile
        try {
            TileService.getUpdater(this)
                .requestUpdate(ParkingTileService::class.java)
        } catch (e: Exception) {
            Log.e("DropspotWear", "Failed to request tile update", e)
        }
        
        // Update complications
        val componentName = android.content.ComponentName(this, ParkingComplicationService::class.java)
        androidx.wear.watchface.complications.datasource.ComplicationDataSourceUpdateRequester
            .create(this, componentName)
            .requestUpdateAll()
    }
}
