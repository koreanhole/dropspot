import 'package:dropspot/providers/parking_image_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

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
      if (pickedFile != null && context.mounted) {
        await context
            .read<ParkingImageProvider>()
            .saveImageToFiles(image: pickedFile);
      }
    }

    return FloatingActionButton(
      onPressed: () => openCamera(),
      shape: CircleBorder(),
      child: Icon(Icons.add),
    );
  }
}
