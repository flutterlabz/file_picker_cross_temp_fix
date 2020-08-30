import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import 'file_picker_stub.dart'
// ignore: uri_does_not_exist
    if (dart.library.io) 'file_picker_io.dart'
// ignore: uri_does_not_exist
    if (dart.library.html) 'file_picker_web.dart';

/// FilePickerCross allows you to select files on any of Flutters platforms.
class FilePickerCross {
  /// The allowed [FileTypeCross] of the file to be selected
  final FileTypeCross type;

  /// The allowed file extension of the file to be selected
  final String fileExtension;

  /// Returns the path the file is located at
  final String path;

  final Uint8List _bytes;

  FilePickerCross(this._bytes,
      {this.path, this.type = FileTypeCross.any, this.fileExtension = ''});

  /// Deprecated. Use [importFromStorage] instead
  @deprecated
  static Future<FilePickerCross> pick(
          {FileTypeCross type = FileTypeCross.any,
          String fileExtension = ''}) =>
      importFromStorage(type: type, fileExtension: fileExtension);

  /// Shows a dialog for selecting a file from your device's internal storage.
  static Future<FilePickerCross> importFromStorage(
      {FileTypeCross type = FileTypeCross.any,
      String fileExtension = ''}) async {
    final Map<String, Uint8List> file =
        await selectSingleFileAsBytes(type: type, fileExtension: fileExtension);

    String _path = file.keys.toList()[0];
    Uint8List _bytes = file[_path];

    if (_bytes == null) throw (NullThrownError());
    return FilePickerCross(_bytes,
        path: _path, fileExtension: fileExtension, type: type);
  }

  /// Deprecated. Use [saveToPath] or [exportToStorage] instead.
  @deprecated
  static Future<FilePickerCross> save(
      {FileTypeCross type = FileTypeCross.any,
      String fileExtension = ''}) async {
    final String path =
        await pickSingleFileAsPath(type: type, fileExtension: fileExtension);

    return FilePickerCross(null,
        path: path, fileExtension: fileExtension, type: type);
  }

  /// Lists all internal files inside the app's internal memory
  static Future<List<String>> listInternalFiles({Pattern at, Pattern name}) {
    return listFiles(at: at, name: name);
  }

  /// Creates a [FilePickerCross] from a local path.
  /// This does **not** allow you to open a file from the local storage but only a file previously saved by [saveToPath].
  /// If you want to open the file to the shared, local memory, use [importFromStorage] instead.
  static Future<FilePickerCross> fromInternalPath({String path}) async {
    final Uint8List file = await internalFileByPath(path: path);

    if (file == null) throw (NullThrownError());
    return FilePickerCross(file, path: path);
  }

  /// Save the file to an internal path.
  /// This does **not** allow you to save the file to the device's public storage like `Documents`, `Downloads`
  /// or `Photos` but saves the [FilePickerCross] in an **app specific**, internal folder for later access by *this app only*. To export a file to
  /// the local storage, use [exportToStorage] instead.
  Future<bool> saveToPath({String path}) {
    return saveInternalBytes(bytes: toUint8List(), path: path);
  }

  Future<bool> delete({String path}) {
    return deleteInternalPath(path: path);
  }

  /// Export the file to the external storage.
  Future<String> exportToStorage() {
    return exportToExternalStorage(bytes: toUint8List(), fileName: fileName);
  }

  /// Returns the name of the file. This typically is the part of the path after the last `/` or `\`.
  String get fileName {
    final parsedPath = '/' + path.replaceAll(r'\', r'/');
    return parsedPath.substring(parsedPath.lastIndexOf('/'));
  }

  /// Returns the directory the file is located in. This it typically everything before the last `/` or `\`.
  String get directory {
    final parsedPath = '/' + path.replaceAll(r'\', r'/');
    return parsedPath.substring(0, parsedPath.lastIndexOf('/'));
  }

  /// Returns a sting containing the file contents of plain text files. Please use it in a try {} catch (e) {} block if you are unsure if the opened file is plain text.
  String toString() => Utf8Codec().decode(_bytes);

  /// Returns the file as a list of bytes.
  Uint8List toUint8List() => _bytes;

  /// Returns the file as base64-encoded String.
  String toBase64() => base64.encode(_bytes);

  /// Returns the file as MultiPartFile for use with tha http package. Useful for file upload in apps.
  http.MultipartFile toMultipartFile({String filename}) {
    return http.MultipartFile.fromBytes('file', _bytes,
        contentType: new MediaType('application', 'octet-stream'),
        filename: filename);
  }

  /// Returns the file's length in bytes
  int get length => _bytes.lengthInBytes;
}

/// Supported file types
enum FileTypeCross { image, video, audio, any, custom }
