import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';

class DeviceInfoUtil {
  static Future<int?> getIOSMajorVersion() async {
    if (Platform.isIOS == false) {
      return null;
    }
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    final iosInfo = await deviceInfo.iosInfo;
    // 예: "14.4.1"과 같이 반환될 수 있음
    String systemVersion = iosInfo.systemVersion;
    // 메이저 버전을 추출하기 위해 점(.)을 기준으로 분리
    int? majorVersion = int.tryParse(systemVersion.split('.')[0]);
    return majorVersion;
  }
}
