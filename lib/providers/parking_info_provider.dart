import 'dart:convert';
import 'dart:io';

import 'package:dropspot/base/data/parking_info.dart';
import 'package:exif/exif.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:intl/intl.dart';
import 'package:logger/web.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String imageFileName = 'parking_image.jpg';
const String defaultImagePath = 'assets/samples/sample.png';

class ParkingInfoProvider with ChangeNotifier {
  ParkingInfo? _parkingInfo;
  File? _image;

  String get parkingImagePath => _image?.path ?? defaultImagePath;
  ParkingInfo? get parkingInfo => _parkingInfo;

  ParkingInfoProvider() {
    _initializeParkingInfo();
  }

  Future<void> setParkingImageInfo(File image) async {
    Logger().d("setParkingImageInfo");
    await _deleteParkingInfoFromPreferences();
    final File savedParkingImage = await _getParkingImage();
    final List<int> imageBytes = await image.readAsBytes();
    _image =
        await savedParkingImage.writeAsBytes(imageBytes, mode: FileMode.write);
    _parkingInfo = ParkingInfo(
      parkedLevel: await _getParkingLevelFromImage(image),
      parkedDateTime: await _getParkingImageDateTimeFromImage(image),
    );
    notifyListeners();
  }

  Future<void> setParkingManualInfo(ParkingInfo parkingInfo) async {
    Logger().d("setParkingManualInfo");
    _parkingInfo = parkingInfo;
    await _deleteAllParkingImage();
    _image = null;
    await _saveParkingInfoToPreferences(parkingInfo);
    notifyListeners();
  }

  Future<void> deleteParkingInfo() async {
    Logger().d("deleteParkingInfo");
    await _deleteParkingInfoFromPreferences();
    await _deleteAllParkingImage();
    _parkingInfo = null;
    _image = null;
    notifyListeners();
  }

  Future<void> _deleteAllParkingImage() async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final List<FileSystemEntity> files = directory.listSync();
    for (int i = 0; i < files.length; i++) {
      if (files[i] is File && files[i].path.contains(imageFileName)) {
        await files[i].delete();
      }
    }
  }

  Future<int?> _getParkingLevelFromImage(File image) async {
    final basementParkingTextPattern =
        RegExp(r'b\s*(\d+)', caseSensitive: false);

    final textRecognizer = TextRecognizer();
    try {
      if (!image.existsSync()) {
        Logger().e("파일이 존재하지 않습니다.");
        return Future.error("파일이 존재하지 않습니다.");
      }
      final RecognizedText recognizedText = await textRecognizer.processImage(
        InputImage.fromFile(image),
      );
      for (TextBlock block in recognizedText.blocks) {
        for (TextLine line in block.lines) {
          for (var match in basementParkingTextPattern.allMatches(line.text)) {
            Logger().i('Recognized text: ${line.text}');
            return -1 * int.parse(match.group(1) ?? "");
          }
        }
      }
      return null;
    } finally {
      textRecognizer.close();
    }
  }

  Future<DateTime?> _getParkingImageDateTimeFromImage(File image) async {
    const String imageExifDateTimeKey = 'Image DateTime';

    final List<int> imageBytes = await image.readAsBytes();
    final Map<String, IfdTag> exifInfo = await readExifFromBytes(imageBytes);
    final imageDateTimeString = exifInfo[imageExifDateTimeKey]?.toString();
    if (imageDateTimeString != null) {
      final dateFormat = DateFormat('yyyy:MM:dd HH:mm:ss');
      return dateFormat.parse(imageDateTimeString);
    } else {
      return null;
    }
  }

  Future<void> _initializeParkingInfo() async {
    // 먼저 SharedPreferences에서 수동 등록한 parkingInfo를 불러옴
    final savedManualInfo = await _loadParkingInfoFromPreferences();
    if (savedManualInfo != null) {
      _parkingInfo = savedManualInfo;
      notifyListeners();
      Logger().d('Loaded parkingInfo from SharedPreferences');
      return;
    }

    // 저장된 수동 등록 정보가 없으면 이미지 파일에서 parkingInfo를 불러옴
    final Directory directory = await getApplicationDocumentsDirectory();
    final List<FileSystemEntity> files = directory.listSync()
      ..sort((a, b) {
        // 수정된 시간 기준으로 정렬 (최신 파일이 맨 앞으로)
        return b.statSync().modified.compareTo(a.statSync().modified);
      });

    // 가장 최신 파일 로드
    final latestFile = files.isNotEmpty ? files.first : null;
    if (latestFile != null &&
        latestFile is File &&
        latestFile.path.contains(imageFileName)) {
      await setParkingImageInfo(latestFile);
      notifyListeners();
      Logger().d('Latest ParkingImage loaded: ${_image!.path}');
    } else {
      Logger().d("No saved ParkingImage");
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

  // SharedPreferences에 ParkingInfo 삭제
  Future<void> _deleteParkingInfoFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('parking_info');
  }

  // SharedPreferences에 ParkingInfo 저장
  Future<void> _saveParkingInfoToPreferences(ParkingInfo parkingInfo) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(parkingInfo.toJson());
    await prefs.setString('parking_info', jsonString);
  }

  // SharedPreferences에서 ParkingInfo 불러오기
  Future<ParkingInfo?> _loadParkingInfoFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('parking_info');
    if (jsonString != null) {
      final Map<String, dynamic> map = json.decode(jsonString);
      return ParkingInfo.fromJson(map);
    }
    return null;
  }
}
