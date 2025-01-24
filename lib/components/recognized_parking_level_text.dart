import 'package:dropspot/providers/parking_level_text_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dropspot/base/extensions.dart';

class RecognizedParkingLevelText extends StatelessWidget {
  const RecognizedParkingLevelText({super.key});

  @override
  Widget build(BuildContext context) {
    final parkingRecognizedText =
        context.watch<ParkingLevelTextProvider>().recognizedLevelText;

    return parkingRecognizedText.letOrElse(
      (it) => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Text("주차위치"),
          Text(
            it,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),
        ],
      ),
      orElse: () => SizedBox.shrink(),
    );
  }
}
