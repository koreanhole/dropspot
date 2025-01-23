import 'package:dropspot/providers/parking_level_text_provider.dart';
import 'package:dropspot/screens/home_screen.dart';
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
      (it) => Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          HomeScreenLeftSpacer,
          Text(
            it,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 8),
          Text("에 주차됨"),
        ],
      ),
      orElse: () => SizedBox.shrink(),
    );
  }
}
