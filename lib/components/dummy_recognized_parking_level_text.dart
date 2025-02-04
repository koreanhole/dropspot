import 'package:flutter/material.dart';

class DummyRecognizedParkingLevelText extends StatelessWidget {
  const DummyRecognizedParkingLevelText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text("주차 위치"),
        Text(
          "알 수 없음",
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
