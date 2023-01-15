import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class web {
  static launchURLApp(String url) async {
    await canLaunch(url)
        ? await launch(url,
            forceSafariVC: true, forceWebView: true, enableJavaScript: true)
        : Center(child: CircularProgressIndicator());
  }


}
