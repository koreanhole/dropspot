import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:logger/logger.dart';

var basementParkingPattern = RegExp(r'b\s*(\d+)', caseSensitive: false);

class ParkingLevelTextProvider with ChangeNotifier {
  String? _recognizedLevelText;

  String? get recognizedLevelText => _recognizedLevelText;

  void setRecognizedText(String imagePath) async {
    _recognizedLevelText = await _performOCR(imagePath);
    Logger().d('Recognized level text: $_recognizedLevelText');
    notifyListeners();
  }

  Future<String?> _performOCR(String imagePath) async {
    final textRecognizer = TextRecognizer();
    try {
      final file = File(imagePath);
      if (!file.existsSync()) {
        Logger().e("파일이 존재하지 않습니다.");
        return Future.error("파일이 존재하지 않습니다.");
      }
      final RecognizedText recognizedText = await textRecognizer.processImage(
        InputImage.fromFile(file),
      );
      for (TextBlock block in recognizedText.blocks) {
        for (TextLine line in block.lines) {
          Logger().i('Recognized text: ${line.text}');
          for (var match in basementParkingPattern.allMatches(line.text)) {
            return '지하${match.group(1)}층';
          }
        }
      }
      return null;
    } finally {
      textRecognizer.close();
    }
  }
}
