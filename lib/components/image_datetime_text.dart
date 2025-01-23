import 'dart:async';

import 'package:dropspot/providers/parking_image_exif_provider.dart';
import 'package:dropspot/base/extensions.dart';
import 'package:dropspot/base/time_util.dart';
import 'package:dropspot/screens/home_screen.dart';
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
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      final parkingImageDateTime =
          context.read<ParkingImageExifProvider>().imageDateTime;
      if (parkingImageDateTime == null) {
        return;
      }
      setState(() {
        _parkingElapsedTime = TimeUtil.getTimeDifference(
          DateTime.now(),
          parkingImageDateTime,
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return _parkingElapsedTime.letOrElse(
      (it) => Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          HomeScreenLeftSpacer,
          Text("주차한 지"),
          SizedBox(width: 8),
          Text(
            it,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 8),
          Text("경과"),
        ],
      ),
      orElse: () => SizedBox.shrink(),
    );
  }
}
