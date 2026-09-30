import 'dart:io';

import 'package:path_provider/path_provider.dart';

Future<String> writeAppFile(String fileName, List<int> bytes) async {
  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/$fileName');
  await file.writeAsBytes(bytes, flush: true);
  return file.path;
}

Future<List<int>?> readAppFile(String fileName) async {
  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/$fileName');
  if (!await file.exists()) return null;
  return file.readAsBytes();
}
