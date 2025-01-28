import 'dart:io';

import 'package:dropspot/base/data/parking_info.dart';
import 'package:exif/exif.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:intl/intl.dart';
import 'package:logger/web.dart';

class ParkingInfoProvider with ChangeNotifier {
  ParkingInfo? _parkingInfo;

  ParkingInfo? get parkingInfo => _parkingInfo;

  void setParkingImageInfo(String imagePath) async {
    Logger().d("setParkingImageInfo");
    _parkingInfo = ParkingInfo(
      parkedLevel: await _getParkingLevelFromImage(imagePath),
      parkedDateTime: await _getParkingImageDateTimeFromImage(imagePath),
    );
    notifyListeners();
  }

  Future<int?> _getParkingLevelFromImage(String imagePath) async {
    final basementParkingTextPattern =
        RegExp(r'b\s*(\d+)', caseSensitive: false);

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
          for (var match in basementParkingTextPattern.allMatches(line.text)) {
            Logger().i('Recognized text: ${line.text}');
            return int.parse(match.group(1) ?? "");
          }
        }
      }
      return null;
    } finally {
      textRecognizer.close();
    }
  }

  Future<DateTime?> _getParkingImageDateTimeFromImage(String imagePath) async {
    const String imageExifDateTimeKey = 'Image DateTime';

    final List<int> imageBytes = await File(imagePath).readAsBytes();
    final Map<String, IfdTag> exifInfo = await readExifFromBytes(imageBytes);
    final imageDateTimeString = exifInfo[imageExifDateTimeKey]?.toString();
    if (imageDateTimeString != null) {
      final dateFormat = DateFormat('yyyy:MM:dd HH:mm:ss');
      return dateFormat.parse(imageDateTimeString);
    } else {
      return null;
    }
  }
}
