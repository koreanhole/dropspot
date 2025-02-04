import 'dart:async';

import 'package:dropspot/base/data/parking_info.dart';
import 'package:dropspot/base/extensions.dart';
import 'package:dropspot/base/time_util.dart';
import 'package:flutter/material.dart';

class ImageDateTimeText extends StatefulWidget {
  final ParkingInfo parkingInfo;
  const ImageDateTimeText({
    super.key,
    required this.parkingInfo,
  });

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
    final parkingImageDateTime = widget.parkingInfo.parkedDateTime;
    if (parkingImageDateTime == null) {
      setState(() {
        _parkingElapsedTime = null;
      });
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
