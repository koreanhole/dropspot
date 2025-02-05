import 'package:dropspot/base/drop_spot_app_bar.dart';
import 'package:dropspot/base/theme/colors.dart';
import 'package:dropspot/components/parking_camera_preview.dart';
import 'package:flutter/material.dart';

class CameraScreen extends StatelessWidget {
  const CameraScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DropSpotAppBar(
        title: "",
      ),
      backgroundColor: backgroundColor,
      body: ParkingCameraPreview(),
    );
  }
}
