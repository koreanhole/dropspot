import 'dart:io';

import 'package:dropspot/providers/parking_image_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class RecognizedParkingText extends StatefulWidget {
  const RecognizedParkingText({super.key});

  @override
  State<RecognizedParkingText> createState() => _RecognizedParkingTextState();
}

class _RecognizedParkingTextState extends State<RecognizedParkingText> {
  String? _extractedText;

  Future<void> _performOCR(String imagePath) async {
    final textRecognizer = TextRecognizer();
    try {
      final file = File(imagePath);
      if (!file.existsSync()) {
        Logger().e("파일이 존재하지 않습니다.");
        return;
      }
      final RecognizedText recognizedText = await textRecognizer.processImage(
        InputImage.fromFile(file),
      );

      setState(() {
        _extractedText = recognizedText.text; // 전체 텍스트
      });
    } catch (e) {
      Logger().e("OCR 에러: $e");
    } finally {
      textRecognizer.close(); // 리소스 해제
    }
  }

  @override
  Widget build(BuildContext context) {
    final parkingImageProvider = context.watch<ParkingImageProvider>();

    return Column(
      children: [
        ElevatedButton(
          onPressed: () => _performOCR(parkingImageProvider.imagePath),
          child: Text('ocr 실행'),
        ),
        _extractedText == null
            ? SizedBox.shrink()
            : Text("인식된 텍스트: $_extractedText"),
      ],
    );
  }
}
