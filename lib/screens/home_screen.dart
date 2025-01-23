// ignore_for_file: constant_identifier_names

import 'package:dropspot/components/camera_button.dart';
import 'package:dropspot/components/image_datetime_text.dart';
import 'package:dropspot/components/image_viewer.dart';
import 'package:dropspot/components/recognized_parking_level_text.dart';
import 'package:flutter/cupertino.dart';

const HomeScreenLeftSpacer = SizedBox(width: 16);

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RecognizedParkingLevelText(),
            ImageDateTimeText(),
            ImageViewer(),
            CameraButton(),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
