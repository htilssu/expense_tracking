import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';

class Image {
  static Future<File> saveCroppedImage(Uint8List croppedBytes) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String filePath =
        '${directory.path}/cropped_image_${DateTime.now().millisecondsSinceEpoch}.png';

    File file = File(filePath);
    await file.writeAsBytes(croppedBytes);

    return file;
  }
}
