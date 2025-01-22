import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

const String imageFileName = 'parking_image.jpg';
const String defaultImagePath = 'assets/samples/sample.png';

class ParkingImageProvider with ChangeNotifier {
  String get imagePath => _image?.path ?? defaultImagePath;

  ParkingImageProvider() {
    _getParkingImage().then((File parkingImage) {
      if (parkingImage.existsSync()) {
        _image = parkingImage;
        notifyListeners();
        Logger().d('ParkingImage loaded');
      }
    });
  }

  File? _image;

  Future<void> saveImageToFiles({required XFile image}) async {
    final File savedParkingImage = await _getParkingImage();
    final List<int> imageBytes = await image.readAsBytes();
    _image =
        await savedParkingImage.writeAsBytes(imageBytes, mode: FileMode.write);
    notifyListeners();
    Logger().d('ParkingImage saved');
  }

  Future<File> _getParkingImage() async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String path = directory.path;
    final File parkingImage = File('$path/$imageFileName');
    return parkingImage;
  }
}
