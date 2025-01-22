import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:logger/logger.dart';

class ParkingRecognizedTextProvider with ChangeNotifier {
  String? _recognizedText;

  String? get recognizedText => _recognizedText;

  void setRecognizedText(String imagePath) async {
    _recognizedText = await _performOCR(imagePath);
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
          print(line.text);
        }
      }
      return recognizedText.text;
    } finally {
      textRecognizer.close();
    }
  }
}
