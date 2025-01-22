import 'package:dropspot/providers/parking_recognized_text_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecognizedParkingText extends StatelessWidget {
  const RecognizedParkingText({super.key});

  @override
  Widget build(BuildContext context) {
    final parkingRecognizedText =
        context.watch<ParkingRecognizedTextProvider>().recognizedText;

    return parkingRecognizedText == null
        ? SizedBox.shrink()
        : Text(parkingRecognizedText);
  }
}
