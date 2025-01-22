import 'dart:io';

import 'package:exif/exif.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

const String imageExifDateTimeKey = 'Image DateTime';

class ParkingImageDateTimeProvider with ChangeNotifier {
  String? _imageDateTime;

  String? get imageDateTime => _imageDateTime;

  void setParkingImageDateTime(String imagePath) async {
    _imageDateTime = await _getImageDateTime(imagePath);
    Logger().d('Image datetime: $_imageDateTime');
    notifyListeners();
  }

  Future<String?> _getImageDateTime(String imagePath) async {
    final List<int> imageBytes = await File(imagePath).readAsBytes();
    final Map<String, IfdTag> exifData = await readExifFromBytes(imageBytes);
    return exifData[imageExifDateTimeKey]?.toString();
  }
}
