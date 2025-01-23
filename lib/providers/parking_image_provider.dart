import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

const String imageFileName = 'parking_image.jpg';
const String defaultImagePath = 'assets/samples/sample.png';

class ParkingImageProvider with ChangeNotifier {
  String get imagePath => _image?.path ?? defaultImagePath;

  File? _image;

  ParkingImageProvider() {
    _loadLatestParkingImage();
  }

  Future<void> saveImageToFiles({required XFile image}) async {
    final File savedParkingImage = await _getParkingImage();
    final List<int> imageBytes = await image.readAsBytes();
    _image =
        await savedParkingImage.writeAsBytes(imageBytes, mode: FileMode.write);
    notifyListeners();
    Logger().d('ParkingImage saved');
  }

  Future<void> _loadLatestParkingImage() async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final List<FileSystemEntity> files = directory.listSync()
      ..sort((a, b) {
        // 수정된 시간 기준으로 정렬 (최신 파일이 맨 앞으로)
        return b.statSync().modified.compareTo(a.statSync().modified);
      });

    // 가장 최신 파일 로드
    final latestFile = files.isNotEmpty ? files.first : null;
    if (latestFile != null && latestFile is File) {
      _image = latestFile;
      notifyListeners();
      Logger().d('Latest ParkingImage loaded: ${_image!.path}');
    }

    // 최신 파일 제외 나머지 삭제
    for (int i = 1; i < files.length; i++) {
      if (files[i] is File) {
        await files[i].delete(); // 파일 삭제
      }
    }
  }

  Future<File> _getParkingImage() async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String path = directory.path;
    final File parkingImage =
        File('$path/$imageFileName${DateTime.now().microsecondsSinceEpoch}');
    return parkingImage;
  }
}
