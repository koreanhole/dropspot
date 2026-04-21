package com.koreanhole.pluto.dropspot

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import com.google.android.gms.wearable.PutDataMapRequest
import com.google.android.gms.wearable.Wearable
import com.google.android.gms.wearable.DataClient
import com.google.android.gms.wearable.DataEventBuffer
import com.google.android.gms.wearable.DataEvent
import com.google.android.gms.wearable.DataMapItem
import android.util.Log

class MainActivity: FlutterActivity(), DataClient.OnDataChangedListener {
    private val CHANNEL = "com.koreanhole.pluto.dropspot/wear"
    private var methodChannel: MethodChannel? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        methodChannel?.setMethodCallHandler { call, result ->
            if (call.method == "syncParkingData") {
                val manualItems = call.argument<List<Int>>("manualParkingItems")
                val parkedLevel = call.argument<Int>("parkedLevel")
                
                syncToWear(manualItems, parkedLevel)
                result.success(true)
            } else {
                result.notImplemented()
            }
        }
    }

    override fun onResume() {
        super.onResume()
        try {
            Wearable.getDataClient(this).addListener(this)
        } catch (e: Exception) {
            Log.e("DropspotWear", "Failed to add wear data listener", e)
        }
    }

    override fun onPause() {
        super.onPause()
        try {
            Wearable.getDataClient(this).removeListener(this)
        } catch (e: Exception) {
            Log.e("DropspotWear", "Failed to remove wear data listener", e)
        }
    }

    private fun syncToWear(manualItems: List<Int>?, parkedLevel: Int?) {
        try {
            val dataClient = Wearable.getDataClient(this)
            val putDataMapReq = PutDataMapRequest.create("/parking_data")
            
            // Add a timestamp so that the data item is always considered "changed"
            putDataMapReq.dataMap.putLong("timestamp", System.currentTimeMillis())
            
            if (manualItems != null) {
                putDataMapReq.dataMap.putIntegerArrayList("manualParkingItems", ArrayList(manualItems))
            }
            if (parkedLevel != null) {
                putDataMapReq.dataMap.putInt("parkedLevel", parkedLevel)
            }

            val putDataReq = putDataMapReq.asPutDataRequest().setUrgent()
            dataClient.putDataItem(putDataReq).addOnSuccessListener {
                Log.d("DropspotWear", "Successfully queued data for wear!")
            }.addOnFailureListener { e ->
                Log.e("DropspotWear", "Failed to queue data for wear", e)
            }
        } catch (e: Exception) {
            Log.e("DropspotWear", "Wearable API not available", e)
        }
    }

    // This handles data coming FROM the watch
    override fun onDataChanged(dataEvents: DataEventBuffer) {
        for (event in dataEvents) {
            if (event.type == DataEvent.TYPE_CHANGED && event.dataItem.uri.path == "/watch_parking_update") {
                val dataMap = DataMapItem.fromDataItem(event.dataItem).dataMap
                if (dataMap.containsKey("parkedLevel")) {
                    val parkedLevel = dataMap.getInt("parkedLevel")
                    Log.d("DropspotWear", "Received updated parked level from watch: $parkedLevel")
                    
                    // Send to Flutter
                    runOnUiThread {
                        methodChannel?.invokeMethod("onWatchParkedLevelUpdated", mapOf("parkedLevel" to parkedLevel))
                    }
                }
            }
        }
    }
}

