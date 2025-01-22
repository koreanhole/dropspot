import 'package:dropspot/providers/parking_image_datetime_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ImageDateTimeText extends StatelessWidget {
  const ImageDateTimeText({super.key});

  @override
  Widget build(BuildContext context) {
    final parkingImageDateTime =
        context.watch<ParkingImageDateTimeProvider>().imageDateTime;

    return parkingImageDateTime == null
        ? SizedBox.shrink()
        : Text(parkingImageDateTime);
  }
}
