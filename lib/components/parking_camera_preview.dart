import 'dart:io';

import 'package:camera/camera.dart';
import 'package:dropspot/base/drop_spot_snack_bar.dart';
import 'package:dropspot/base/theme/colors.dart';
import 'package:dropspot/components/camera_aspect_ratio_preset.dart';
import 'package:dropspot/providers/parking_info_provider.dart';
import 'package:flutter/material.dart';
import 'package:logger/web.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class ParkingCameraPreview extends StatefulWidget {
  const ParkingCameraPreview({super.key});

  @override
  State<ParkingCameraPreview> createState() => _ParkingCameraPreview();
}

class _ParkingCameraPreview extends State<ParkingCameraPreview> {
  CameraController? _cameraController;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _initializeCamera() async {
    try {
      await Permission.camera.request();
      final cameras = await availableCameras();
      _cameraController = CameraController(
        cameras[0], // 첫 번째 카메라 사용
        ResolutionPreset.high,
        enableAudio: false,
      );

      await _cameraController?.initialize();
      await _cameraController?.setFlashMode(FlashMode.off);
      await _cameraController?.setExposureMode(ExposureMode.auto);
      setState(() {});
    } catch (exception) {
      if (context.mounted) {
        DropSpotSnackBar.showFailureSnackBar(context, "카메라를 사용할 수 없습니다.");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Future<void> captureImage() async {
      final image = await _cameraController?.takePicture();
      if (image != null && context.mounted) {
        await context
            .read<ParkingInfoProvider>()
            .setParkingImageInfo(File(image.path));
      }
      if (context.mounted) {
        DropSpotSnackBar.showSuccessSnackBar(context, "주차위치를 추가했습니다.");
        Navigator.pop(context);
      }
    }

    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _cameraController != null && _cameraController!.value.isInitialized
              ? CameraAspectRatioPreset(
                  child: ClipRect(
                    child: OverflowBox(
                      alignment: Alignment.center,
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: SizedBox(
                          width: _cameraController!.value.previewSize!.height,
                          height: _cameraController!.value.previewSize!.width,
                          child: CameraPreview(_cameraController!),
                        ),
                      ),
                    ),
                  ),
                )
              : CameraAspectRatioPreset(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
          SizedBox(height: 16),
          Text("주차한 위치가 잘 보이는 기둥을 찍어주세요."),
          SizedBox(height: 16),
          _CameraZoomSlider(cameraController: _cameraController),
          SizedBox(height: 16),
          FloatingActionButton(
            onPressed: captureImage,
            shape: CircleBorder(),
            child: Icon(
              Icons.camera_alt,
            ),
          ),
        ],
      ),
    );
  }
}

class _CameraZoomSlider extends StatefulWidget {
  final CameraController? cameraController;

  const _CameraZoomSlider({this.cameraController});

  @override
  State<_CameraZoomSlider> createState() => _CameraZoomSliderState();
}

class _CameraZoomSliderState extends State<_CameraZoomSlider> {
  double minZoomLevel = 3.0;
  double maxZoomLevel = 10.0;
  double currentZoomLevel = 3.0;

  @override
  void initState() {
    super.initState();
    initializeCameraZoomLevel();
  }

  void initializeCameraZoomLevel() async {
    double? _minZoomLevel = await widget.cameraController?.getMinZoomLevel();
    double? _currentZoomLevel = _minZoomLevel;

    setState(() {
      minZoomLevel = _minZoomLevel ?? 1.0;
      currentZoomLevel = _currentZoomLevel ?? 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "-",
          style: TextStyle(
            fontSize: 24,
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.7,
          child: Slider(
            min: minZoomLevel,
            max: maxZoomLevel,
            value: currentZoomLevel,
            activeColor: primaryColor,
            inactiveColor: tertiaryColor,
            onChanged: (value) async {
              try {
                await widget.cameraController?.setZoomLevel(value);
                setState(() {
                  currentZoomLevel = value;
                });
              } catch (exception) {
                if (exception is CameraException) {
                  Logger().e(exception);
                }
              }
            },
          ),
        ),
        Text(
          "+",
          style: TextStyle(
            fontSize: 24,
          ),
        ),
      ],
    );
  }
}
