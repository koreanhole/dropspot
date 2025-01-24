import 'dart:convert';

import 'package:dropspot/base/data/public_parking_info.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';

class JsonUtil {
  Future<List<PublicParkingInfo>> getPublicParkingInfos() async {
    Logger().d('getPublicParkingInfos()');
    String rootJsonString =
        await rootBundle.loadString("assets/public_parking_info.json");
    List<dynamic> recordJsonList = jsonDecode(rootJsonString)['records'];

    return recordJsonList
        .map((json) => PublicParkingInfo.fromJson(json))
        .where((info) => info.parkingLotType == "공영")
        .toList();
  }
}
