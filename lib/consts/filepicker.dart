import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:printonex_final/consts/responsive_file.dart';

class Upload {

  static Future<void> pickfile()async{
    FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result != null) {
      List<File> files = result.paths.map((path) => File(path!)).toList();
    } else {
      // User canceled the picker
    }
  }
}
