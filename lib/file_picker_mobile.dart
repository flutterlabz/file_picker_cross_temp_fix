import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';

import 'file_picker_cross.dart';
import 'file_picker_io.dart';

/// Implementation of file selection dialog using file_picker for mobile platforms
Future<Map<String, Uint8List>> selectFilesMobile(
    {FileTypeCross type, String fileExtension}) async {
  File file = await FilePicker.getFile(
      type: fileTypeCrossParse(type),
      allowedExtensions: parseExtension(fileExtension));
  return {file.path: file.readAsBytesSync()};
}

Future<String> saveFileMobile(
    {FileTypeCross type, String fileExtension}) async {
  /// TODO: implement
  throw UnimplementedError('Unsupported Platform for file_picker_cross');
}
