import 'dart:io';

import 'package:exif/exif.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

const String imageExifDateTimeKey = 'Image DateTime';

class ParkingImageExifProvider with ChangeNotifier {
  Map<String, IfdTag>? _imageExifData;

  String? get imageDateTime =>
      _imageExifData?[imageExifDateTimeKey]?.toString();

  void setParkingImageExifData(String imagePath) async {
    _imageExifData = await _getImageExifData(imagePath);
    Logger().d('Image exif data updated');
    notifyListeners();
  }

  Future<Map<String, IfdTag>?> _getImageExifData(String imagePath) async {
    final List<int> imageBytes = await File(imagePath).readAsBytes();
    return await readExifFromBytes(imageBytes);
  }
}
