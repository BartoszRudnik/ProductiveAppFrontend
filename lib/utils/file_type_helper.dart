import 'package:mime/mime.dart';

class FileTypeHelper {
  static bool isImage(String filePath) {
    final mimeType = lookupMimeType(filePath);

    return mimeType.startsWith('image/');
  }

  static bool isPDF(String filePath) {
    final mimeType = lookupMimeType(filePath);

    return mimeType.startsWith('application/');
  }
}
