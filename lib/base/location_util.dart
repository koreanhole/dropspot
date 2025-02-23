import 'package:dropspot/base/drop_spot_snack_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';

class LocationUtil {
  Future<void> requestLocationPermission(BuildContext context) async {
    // 위치 서비스 활성화 확인
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (context.mounted) {
        DropSpotSnackBar.showFailureSnackBar(context, "내 위치를 확인할 수 없습니다.");
      }
    }

    // 위치 권한 확인
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (context.mounted) {
          DropSpotSnackBar.showFailureSnackBar(context, "내 위치를 확인할 수 없습니다.");
        }
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (context.mounted) {
        DropSpotSnackBar.showFailureSnackBar(context, "내 위치를 확인할 수 없습니다.");
      }
    }
  }
}
