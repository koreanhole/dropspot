import 'package:dropspot/base/location_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:logger/logger.dart';

const defaultMapZoom = 16.0;
const naverMapClientIdKey = 'NAVER_MAP_CLIENT_ID';

class ParkingMapScreen extends StatefulWidget {
  const ParkingMapScreen({super.key});

  @override
  State<ParkingMapScreen> createState() => _ParkingMapScreenState();
}

class _ParkingMapScreenState extends State<ParkingMapScreen> {
  bool _isMapInitialized = false;

  @override
  void initState() {
    initializeMap();
    super.initState();
  }

  Future<void> initializeMap() async {
    WidgetsFlutterBinding.ensureInitialized();
    await dotenv.load(fileName: '.env');
    await NaverMapSdk.instance.initialize(
        clientId: dotenv.get(naverMapClientIdKey),
        onAuthFailed: (exception) {
          Logger().e('Map Auth Failed: $exception');
        });
    await LocationUtil().requestLocationPermission();
    setState(() {
      _isMapInitialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isMapInitialized == true
          ? NaverMap(
              options: NaverMapViewOptions(
                locationButtonEnable: true,
              ),
              onMapReady: (controller) async {
                Logger().i("Map Ready");
                controller
                    .setLocationTrackingMode(NLocationTrackingMode.follow);
              },
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
