import 'package:dropspot/base/string_util.dart';
import 'package:dropspot/providers/parking_info_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dropspot/base/extensions.dart';

class RecognizedParkingLevelText extends StatelessWidget {
  const RecognizedParkingLevelText({super.key});

  @override
  Widget build(BuildContext context) {
    final parkedLevel =
        context.watch<ParkingInfoProvider>().parkingInfo?.parkedLevel;

    return parkedLevel.letOrElse(
      (it) => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Text("주차위치"),
          Text(
            parkedLevel.convertToReadableText(),
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),
        ],
      ),
      orElse: () => SizedBox.shrink(),
    );
  }
}
