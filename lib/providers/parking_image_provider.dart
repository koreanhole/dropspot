import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

const String imageFileName = 'parking_image.jpg';
const String defaultImagePath = 'assets/samples/sample.png';

class ParkingImageProvider with ChangeNotifier {
  File? _image;

  String get imagePath => _image?.path ?? defaultImagePath;

  Future<void> saveImageToFiles({required XFile image}) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String path = directory.path;
    final File targetFile =
        File('$path/$imageFileName${DateTime.now().microsecondsSinceEpoch}');
    final List<int> imageBytes = await image.readAsBytes();
    final File savedImage =
        await targetFile.writeAsBytes(imageBytes, mode: FileMode.write);
    _image = savedImage;
    Logger().d('Image saved to: ${savedImage.path}');
    notifyListeners();
  }
}
