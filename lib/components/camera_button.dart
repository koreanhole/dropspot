import 'package:dropspot/utils/image_utils.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CameraButton extends StatelessWidget {
  const CameraButton({super.key});

  @override
  Widget build(BuildContext context) {
    final ImagePicker picker = ImagePicker();

    Future<void> openCamera() async {
      final XFile? pickedFile = await picker.pickImage(
        source: ImageSource.camera,
        requestFullMetadata: false,
        preferredCameraDevice: CameraDevice.rear,
      );
      if (pickedFile != null) {
        ImageUtils().saveImageToFiles(image: pickedFile);
      }
    }

    return ElevatedButton(
      onPressed: openCamera,
      child: Text("Open Camera"),
    );
  }
}
