import 'dart:typed_data';

import 'package:file_chooser/file_chooser.dart';

import 'file_picker_cross.dart';
import 'file_picker_io.dart';

/// Implementation of file selection dialog using file_chooser for desktop platforms
Future<Map<String, Uint8List>> selectFilesDesktop(
    {FileTypeCross type, String fileExtension}) async {
  FileChooserResult file = await showOpenPanel(
      allowedFileTypes: (parseExtension(fileExtension) == null)
          ? null
          : [
              FileTypeFilterGroup(
                  label: 'files', fileExtensions: parseExtension(fileExtension))
            ]);
  String path = file.paths[0];
  return {path: await fileByPath(path).readAsBytes()};
}

/// Implementation of file selection dialog using file_chooser for desktop platforms
Future<String> saveFileDesktop(
    {FileTypeCross type, String fileExtension}) async {
  FileChooserResult file = await showSavePanel(
      allowedFileTypes: (parseExtension(fileExtension) == null)
          ? null
          : [
              FileTypeFilterGroup(
                  label: 'files', fileExtensions: parseExtension(fileExtension))
            ]);
  String path = file.paths.isEmpty ? "" : file.paths[0];
  return path;
}
