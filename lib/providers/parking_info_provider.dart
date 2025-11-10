import 'dart:convert';
import 'dart:io';

import 'package:dropspot/base/data/parking_info.dart';
import 'package:dropspot/base/device_info_util.dart';
import 'package:exif/exif.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:home_widget/home_widget.dart';
import 'package:intl/intl.dart';
import 'package:logger/web.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart' show rootBundle;

const String imageFileName = 'parking_image.jpg';
const String defaultImagePath = 'assets/images/default_parking_image.png';

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
    updateWidgetParkedLevel(_parkingInfo?.parkedLevel);
    notifyListeners();
  }

  Future<void> setParkingManualInfo(ParkingInfo parkingInfo) async {
    Logger().d("setParkingManualInfo");
    final File savedParkingImage = await _getImageFileFromAssets(
        "assets/images/${parkingInfo.parkedLevel}.png");
    final List<int> imageBytes =
        await File(savedParkingImage.path).readAsBytes();
    _image =
        await savedParkingImage.writeAsBytes(imageBytes, mode: FileMode.write);
    _parkingInfo = parkingInfo;
    await _saveParkingInfoToPreferences(parkingInfo);
    updateWidgetParkedLevel(_parkingInfo?.parkedLevel);
    notifyListeners();
  }

  Future<void> deleteParkingInfo() async {
    Logger().d("deleteParkingInfo");
    await _deleteParkingInfoFromPreferences();
    await _deleteAllParkingImage();
    _parkingInfo = null;
    _image = null;
    updateWidgetParkedLevel(-999);
    notifyListeners();
  }

  Future<void> _deleteAllParkingImage() async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final List<FileSystemEntity> files = directory.listSync();

    if (Platform.isAndroid) {
      final RegExp manualImagePattern = RegExp(r'^-?\d{1,2}\.png$');
      for (final file in files) {
        if (file is File) {
          final fileName = file.path.split('/').last;
          if (fileName.contains(imageFileName) ||
              manualImagePattern.hasMatch(fileName)) {
            await file.delete();
          }
        }
      }
    } else {
      for (int i = 0; i < files.length; i++) {
        if (files[i] is File && files[i].path.contains(imageFileName)) {
          await files[i].delete();
        }
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
    // 1. Load manual info from SharedPreferences first.
    final savedManualInfo = await _loadParkingInfoFromPreferences();
    if (savedManualInfo != null) {
      _parkingInfo = savedManualInfo;
      await setParkingManualInfo(savedManualInfo);
      notifyListeners();
      Logger().d('Loaded parkingInfo from SharedPreferences');
      return;
    }

    // 2. If no manual info, find the latest image file in the documents directory.
    final Directory directory = await getApplicationDocumentsDirectory();
    final RegExp manualImagePattern = RegExp(r'^-?\d{1,2}\.png$');
    List<File> parkingImages = directory.listSync().where((item) {
      if (item is! File) return false;
      final fileName = item.path.split('/').last;
      return fileName.contains(imageFileName) ||
          manualImagePattern.hasMatch(fileName);
    }).cast<File>().toList();

    if (parkingImages.isEmpty) {
      Logger().d("No saved parking images found.");
      return;
    }

    // Sort by date to find the latest.
    parkingImages
        .sort((a, b) => b.statSync().modified.compareTo(a.statSync().modified));

    final File latestImage = parkingImages.first;

    // 3. Load info from the latest image without creating a copy.
    // This re-uses the logic from setParkingImageInfo but without the file-writing part.
    _image = latestImage;
    _parkingInfo = ParkingInfo(
      parkedLevel: await _getParkingLevelFromImage(latestImage),
      parkedDateTime: await _getParkingImageDateTimeFromImage(latestImage),
    );
    notifyListeners();
    Logger().d('Initialized with latest image: ${latestImage.path}');

    // 4. Delete all other parking images.
    for (int i = 1; i < parkingImages.length; i++) {
      await parkingImages[i].delete();
      Logger().d('Deleted old parking image: ${parkingImages[i].path}');
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

  Future<File> _getImageFileFromAssets(String assetPath,
      {String? fileName}) async {
    // asset의 데이터를 ByteData 형태로 읽어옵니다.
    final byteData = await rootBundle.load(assetPath);

    final Directory directory;
    if (Platform.isAndroid) {
      directory = await getApplicationDocumentsDirectory();
    } else {
      directory = await getTemporaryDirectory();
    }

    // fileName이 제공되지 않으면 기본 파일명 지정
    final name = fileName ?? assetPath.split('/').last;

    // 파일의 경로 생성
    final file = File('${directory.path}/$name');

    // ByteData를 Uint8List로 변환하여 파일에 기록
    await file.writeAsBytes(byteData.buffer.asUint8List(), flush: true);

    return file;
  }

  Future<void> updateWidgetParkedLevel(int? parkedLevel) async {
    if (parkedLevel == null) {
      Logger().i("parkedLevel is null");
      return;
    }
    if (Platform.isIOS == false) {
      Logger().i("Not ios. No need to update widget data");
      return;
    }
    if ((await DeviceInfoUtil.getIOSMajorVersion() ?? 0) < 17) {
      Logger().i("Not supported IOS version");
      return;
    }
    Logger().i("updateWidget parked level: $parkedLevel");
    await HomeWidget.setAppGroupId(
        "group.com.koreanhole.pluto.dropspot.widget");
    await HomeWidget.saveWidgetData<int>("parkedLevel", parkedLevel);
    await HomeWidget.updateWidget(iOSName: "LockScreenWidget");
  }
}
