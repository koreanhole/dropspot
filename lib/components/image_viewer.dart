import 'package:dropspot/providers/parking_image_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ImageViewer extends StatelessWidget {
  const ImageViewer({super.key});

  @override
  Widget build(BuildContext context) {
    final parkingImageProvider = context.watch<ParkingImageProvider>();
    return Image.asset(
      parkingImageProvider.imagePath,
      fit: BoxFit.cover,
    );
  }
}
