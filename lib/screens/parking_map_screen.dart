import 'package:dropspot/base/bottom_sheet.dart';
import 'package:dropspot/base/json_util.dart';
import 'package:dropspot/base/location_util.dart';
import 'package:dropspot/components/public_parking_lot_info_modal_sheet.dart';
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
  List<NMarker>? _publicParkingMarkers;
  NaverMapController? _mapController;

  @override
  void initState() {
    initializeMap();
    initializePublicParkingMarkers();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _mapController?.dispose();
    _mapController = null;
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

  Future<void> initializePublicParkingMarkers() async {
    final publicParkingInfos = await JsonUtil().getPublicParkingInfos();
    final publicParkingMarkerIcon =
        NOverlayImage.fromAssetImage("assets/map/parking_lot_marker.png");

    final publicParkingMarkers = publicParkingInfos
        .map((info) {
          try {
            final marker = NClusterableMarker(
              id: info.parkingLotId,
              position: NLatLng(
                double.parse(info.latitude),
                double.parse(info.longitude),
              ),
              icon: publicParkingMarkerIcon,
            );
            marker.setOnTapListener((marker) {
              Logger().d("setOnTapListener: ${info.toJson()}");
              showDropSpotBottomsheet(
                context: context,
                child: PublicParkingLotInfoModalSheet(
                  mapMarker: marker,
                  publicParkingInfo: info,
                ),
              );
            });
            return marker;
          } catch (e) {
            // 예외 발생 시 null 반환
            return null;
          }
        })
        .where((marker) => marker != null) // null 값을 필터링
        .cast<NMarker>() // List<NMarker?>를 List<NMarker>로 변환
        .toList();

    setState(() {
      _publicParkingMarkers = publicParkingMarkers;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isMapInitialized == true
          ? NaverMap(
              options: NaverMapViewOptions(
                locationButtonEnable: true,
                logoClickEnable: false,
              ),
              clusterOptions: NaverMapClusteringOptions(
                enableZoomRange:
                    NaverMapClusteringOptions.defaultClusteringZoomRange,
                mergeStrategy: NClusterMergeStrategy(
                  maxMergeableScreenDistance: 10,
                ),
              ),
              onMapReady: (controller) {
                Logger().i("Map Ready");
                _mapController = controller;
                _mapController
                    ?.setLocationTrackingMode(NLocationTrackingMode.follow);
              },
              onCameraIdle: () async {
                _mapController?.clearOverlays(type: NOverlayType.marker);
                final cameraBound = await _mapController?.getContentBounds();
                final publicParkingMarkers = _publicParkingMarkers;
                if (cameraBound == null || publicParkingMarkers == null) {
                  Logger().e('Camera Bound or Markers are null');
                  return;
                }
                final markersInCameraBound = publicParkingMarkers
                    .where(
                      (marker) => cameraBound.containsPoint(marker.position),
                    )
                    .toSet();
                await _mapController?.addOverlayAll(markersInCameraBound);
              },
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
