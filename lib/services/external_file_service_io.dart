import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:share_plus/share_plus.dart';

class ExternalFileService {
  static Future<String?> saveBytes({
    required String suggestedName,
    required List<int> bytes,
    required List<String> allowedExtensions,
  }) async {
    final path = await FilePicker.platform.saveFile(
      dialogTitle: 'Salvar arquivo',
      fileName: suggestedName,
      type: FileType.custom,
      allowedExtensions: allowedExtensions,
    );
    if (path == null) return null;
    await File(path).writeAsBytes(bytes, flush: true);
    return path;
  }

  static Future<List<int>?> pickJsonBytes() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['json'],
      withData: true,
    );
    if (result == null || result.files.isEmpty) return null;
    final file = result.files.single;
    if (file.bytes != null) return file.bytes;
    if (file.path == null) return null;
    return File(file.path!).readAsBytes();
  }

  static Future<void> sharePath(String path, {String? text}) async {
    await Share.shareXFiles([XFile(path)], text: text);
  }
}
