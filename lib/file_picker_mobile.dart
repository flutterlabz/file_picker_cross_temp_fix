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

/// Implementation of file selection dialog for multiple files using file_picker for mobile platforms
Future<Map<String, Uint8List>> selectMultipleFilesMobile(
    {FileTypeCross type, String fileExtension}) async {
  List<File> files = await FilePicker.getMultiFile(
      type: fileTypeCrossParse(type),
      allowedExtensions: parseExtension(fileExtension));
  Map<String, Uint8List> filesMap = {};
  files.forEach((file) {
    filesMap[file.path] = file.readAsBytesSync();
  });
  return filesMap;
}

Future<String> saveFileMobile(
    {FileTypeCross type, String fileExtension}) async {
  /// TODO: implement
  throw UnimplementedError('Unsupported Platform for file_picker_cross');
}
