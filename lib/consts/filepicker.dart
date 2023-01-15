import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:printonex_final/consts/responsive_file.dart';

class Upload {
  PlatformFile? pickedFile;
  File? fileToDisplay;
  FilePickerResult? result;

  static Future<String?> pickfile()async{
    final result = await FilePicker.platform.pickFiles(allowMultiple: true);
    final pickedFile = result!.files.first;
    final fileToDisplay = File(pickedFile.path.toString());
    var path = fileToDisplay.path;
    return path;
  }
  static Future<void> upload(String path)async{
    final result = await FilePicker.platform.pickFiles(allowMultiple: true);
    final pickedFile = result!.files.first;
    final fileToDisplay = File(pickedFile.path.toString());
  }
  // static Future selectfile() async {
  //   final result = await FilePicker.platform.pickFiles();
  //   if (result == null) return;
  //   setState(() {
  //     pickedFile = result.files.first
  //   });
  // }
}
