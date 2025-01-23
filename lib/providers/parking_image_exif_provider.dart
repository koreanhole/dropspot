import 'dart:io';

import 'package:exif/exif.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

const String imageExifDateTimeKey = 'Image DateTime';

class ParkingImageExifProvider with ChangeNotifier {
  Map<String, IfdTag>? _imageExifData;

  DateTime? get imageDateTime {
    final imageDateTimeString =
        _imageExifData?[imageExifDateTimeKey]?.toString();
    if (imageDateTimeString != null) {
      final dateFormat = DateFormat('yyyy:MM:dd HH:mm:ss');
      return dateFormat.parse(imageDateTimeString);
    } else {
      return null;
    }
  }

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
