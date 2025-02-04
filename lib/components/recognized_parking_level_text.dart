import 'package:dropspot/base/data/parking_info.dart';
import 'package:dropspot/base/string_util.dart';
import 'package:flutter/material.dart';

class RecognizedParkingLevelText extends StatelessWidget {
  final ParkingInfo parkingInfo;
  const RecognizedParkingLevelText({
    super.key,
    required this.parkingInfo,
  });

  @override
  Widget build(BuildContext context) {
    if (parkingInfo.parkedLevel == null) {
      return SizedBox.shrink();
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text("주차 위치"),
        Text(
          parkingInfo.parkedLevel.convertToReadableText(),
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12),
      ],
    );
  }
}
