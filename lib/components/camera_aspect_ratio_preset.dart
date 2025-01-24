import 'package:flutter/material.dart';

class CameraAspectRatioPreset extends StatelessWidget {
  final Widget child;

  const CameraAspectRatioPreset({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 3 / 4,
      child: child,
    );
  }
}
