import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:logger/web.dart';
import 'package:path_provider/path_provider.dart';

class ImageUtils {
  Future<void> saveImageToFiles({required XFile image}) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String path = directory.path;
    final String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    final String newPath = '$path/$fileName';
    final File savedImage = await File(image.path).copy(newPath);
    Logger().d('Image saved to: ${savedImage.path}');
  }
}
