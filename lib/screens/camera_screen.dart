import 'package:dropspot/base/theme/colors.dart';
import 'package:dropspot/components/parking_camera_preview.dart';
import 'package:flutter/material.dart';

class CameraScreen extends StatelessWidget {
  const CameraScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        iconTheme: IconThemeData(color: primaryColor),
        backgroundColor: backgroundColor,
      ),
      backgroundColor: backgroundColor,
      body: ParkingCameraPreview(),
    );
  }
}
