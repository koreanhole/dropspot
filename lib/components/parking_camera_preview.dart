import 'package:camera/camera.dart';
import 'package:dropspot/providers/parking_image_provider.dart';
import 'package:flutter/material.dart';
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
    await Permission.camera.request();
    final cameras = await availableCameras();
    _cameraController = CameraController(
      cameras[0], // 첫 번째 카메라 사용
      ResolutionPreset.high,
    );

    await _cameraController?.initialize();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Future<void> captureImage() async {
      final image = await _cameraController?.takePicture();
      if (image != null && context.mounted) {
        await context
            .read<ParkingImageProvider>()
            .saveImageToFiles(image: image);
      }
      if (context.mounted) {
        Navigator.pop(context);
      }
    }

    return Column(
      children: [
        _cameraController != null && _cameraController!.value.isInitialized
            ? AspectRatio(
                aspectRatio: 1, // 1:1 비율 설정
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
            : Center(child: CircularProgressIndicator()),
        SizedBox(height: 16),
        FloatingActionButton(
          onPressed: captureImage,
          shape: CircleBorder(),
          child: Icon(
            Icons.camera_alt,
          ),
        ),
      ],
    );
  }
}
