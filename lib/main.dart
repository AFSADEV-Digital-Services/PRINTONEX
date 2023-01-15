import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:printonex_final/main_screen.dart';


import 'views/auth_pages/login.dart';
import 'views/pages/print.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp(
  //   options: const FirebaseOptions(
  //   apiKey: "AIzaSyC5pxBgyhtiTwWGWuOkKhpUCxvfUUW5QYw",
  //   appId: "1:1077555323212:android:4c1f3a24299ea369952fe9",
  //   messagingSenderId: "1077555323212",
  //   projectId: "printonex-eeff2",
  // ),
  );



  await GetStorage.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'PRINTONEX',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            textStyle: TextStyle(
              fontSize: 24.0,
            ),
            padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
          ),
        ),
        textTheme: TextTheme(
          headline1: TextStyle(
            fontSize: 46.0,
            color: Colors.blue.shade700,
            fontWeight: FontWeight.w500,
          ),
          bodyText1: TextStyle(fontSize: 18.0),
        ),
      ),

      home: LoginPage(),
    );
  }
}