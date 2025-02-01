import 'dart:async';

import 'package:dropspot/base/extensions.dart';
import 'package:dropspot/base/time_util.dart';
import 'package:dropspot/providers/parking_info_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ImageDateTimeText extends StatefulWidget {
  const ImageDateTimeText({super.key});

  @override
  State<ImageDateTimeText> createState() => _ImageDateTimeTextState();
}

class _ImageDateTimeTextState extends State<ImageDateTimeText> {
  Timer? _timer;
  String? _parkingElapsedTime;

  @override
  void initState() {
    super.initState();
    _updateParkingElapsedTime();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _updateParkingElapsedTime() {
    final parkingImageDateTime =
        context.read<ParkingInfoProvider>().parkingInfo?.parkedDateTime;
    if (parkingImageDateTime == null) {
      return;
    }
    setState(() {
      _parkingElapsedTime = TimeUtil.getTimeDifference(
        DateTime.now(),
        parkingImageDateTime,
      );
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _updateParkingElapsedTime();
    });
  }

  @override
  Widget build(BuildContext context) {
    return _parkingElapsedTime.letOrElse(
      (it) => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Text("주차 시간"),
          Text(
            it,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      orElse: () => SizedBox.shrink(),
    );
  }
}
