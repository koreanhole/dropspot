import 'package:dropspot/providers/parking_image_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ImageViewer extends StatelessWidget {
  const ImageViewer({super.key});

  @override
  Widget build(BuildContext context) {
    final parkingImagePath = context.watch<ParkingImageProvider>().imagePath;
    return SizedBox(
      width: MediaQuery.of(context).size.width, // 화면 너비의 80%
      height: MediaQuery.of(context).size.width,
      child: Image.asset(
        parkingImagePath,
        fit: BoxFit.cover,
        key: ValueKey(DateTime.now().millisecondsSinceEpoch),
      ),
    );
  }
}
