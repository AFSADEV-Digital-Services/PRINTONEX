import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:printonex_final/consts/responsive_file.dart';

class Error {
  static Future<void> ErrorMsg({required String msg}) async {
    Fluttertoast.showToast(
        backgroundColor: Colors.red,
        msg: msg,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        textColor: Colors.white,
        fontSize: ResponsiveFile.font20);
  }
  static Future<void> SuccessMsg({required String msg}) async {
    Fluttertoast.showToast(
        backgroundColor: Colors.greenAccent,
        msg: msg,
        toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      textColor: Colors.white,
        fontSize: ResponsiveFile.font20,

    );
  }
}
