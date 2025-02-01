import 'dart:async';

import 'package:dropspot/components/camera_aspect_ratio_preset.dart';
import 'package:dropspot/providers/parking_info_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const double minImageScale = 1.0;
const double maxImageScale = 10.0;
const Duration resetImageScaleDuration = Duration(seconds: 2);

class ImageViewer extends StatelessWidget {
  const ImageViewer({super.key});

  @override
  Widget build(BuildContext context) {
    final TransformationController transformationController =
        TransformationController(Matrix4.identity());

    final parkingImagePath =
        context.watch<ParkingInfoProvider>().parkingImagePath;
    return CameraAspectRatioPreset(
      child: InteractiveViewer(
        minScale: minImageScale,
        maxScale: maxImageScale,
        key: ValueKey(
          DateTime.now().millisecondsSinceEpoch,
        ),
        transformationController: transformationController,
        onInteractionEnd: (details) {
          Timer(resetImageScaleDuration, () {
            transformationController.value = Matrix4.identity();
          });
        },
        child: Image.asset(
          parkingImagePath,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
