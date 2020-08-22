import 'dart:io';

import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _fileString;
  int _fileLength = 0;
  String _filePath;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: ListView(
          padding: EdgeInsets.all(8),
          children: <Widget>[
            RaisedButton(
              onPressed: _selectFile,
              child: Text('Select File'),
            ),
            RaisedButton(
              onPressed: _selectSaveFile,
              child: Text('Select File To Save'),
            ),
            Text('File path: $_filePath (Might cause issues on web)\n'),
            Text('File length: $_fileLength\n'),
            Text('File as String: $_fileString\n'),
          ],
        ),
      ),
    );
  }

  void _selectFile() {
    FilePickerCross.pick().then((filePicker) => setState(() {
          _filePath = filePicker.path;
          _fileLength = filePicker.toUint8List().lengthInBytes;
          try {
            _fileString = filePicker.toString();
          } catch (e) {
            _fileString =
                'Not a text file. Showing base64.\n\n' + filePicker.toBase64();
          }
        }));
  }

  void _selectSaveFile() {
    FilePickerCross.save().then((filePicker) => setState(() {
          _filePath = filePicker.path;
          try {
            if (_filePath != "") {
              _fileString = 'file content';
              File f = File(_filePath);
              f.writeAsString(_fileString);
            }
          } catch (e) {
            _fileString = 'Error writing file. Path: $_filePath';
          }
          _fileLength = _fileString.length;
        }));
  }
}
