import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:printonex_final/Providers/auth_provider.dart';
import 'package:printonex_final/main_screen.dart';
import 'package:printonex_final/services/add_images.dart';
import 'package:printonex_final/views/auth_pages/login.dart';
import 'package:printonex_final/views/pages/printing_management_page.dart';
import 'package:provider/provider.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../consts/firebase/all_constants.dart';

const List<Color> _kDefaultRainbowColors = const [
  Colors.red,
  Colors.orange,
  Colors.yellow,
  Colors.green,
  Colors.blue,
  Colors.indigo,
  Colors.purple,
];

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      checkSignedIn();
    });
  }
  void setStat(String status) async{
    final firebaseAuth = FirebaseAuth.instance;
    final FirebaseFirestore firebasestore =  FirebaseFirestore.instance;
    await firebasestore
        .collection(FirestoreConstants.pathUserCollection)
        .doc(firebaseAuth.currentUser!.uid)
        .update({
     'online': status

    });
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state){
    if(state == AppLifecycleState.resumed){
      setStat("ONLINE");
    }
    else{
      setStat("OFFLINE");
    }

  }

  void checkSignedIn() async {
    var isLoggedIn = false;
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseAuth.instance
        .authStateChanges()
        .listen((User? user) {
      if (user == null) {
        isLoggedIn = false;
      } else {
        isLoggedIn = true;
      }

      if (isLoggedIn) {
        setStat("ONLINE");
        Get.snackbar('Success', 'Already Login',
            backgroundColor: Colors.greenAccent);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const MainScreen()));
        return;
      }
      Get.snackbar('Warning', 'Authenticate Yourself',
          backgroundColor: Colors.orangeAccent);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginPage()));

    });
    // AuthProvider authProvider = context.read<AuthProvider>();
    // bool isLoggedIn = await authProvider.isLoggedIn();
    // print(isLoggedIn.toString());
    // if (isLoggedIn) {
    //   Navigator.pushReplacement(
    //       context, MaterialPageRoute(builder: (context) => MainScreen()));
    //   return;
    // }
    // Navigator.pushReplacement(
    //     context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          //if stack layer if coloumn top to butom
          children: <Widget>[
            Container(
                height: double.maxFinite,
                width: MediaQuery.of(context).size.width, // fill/auto
                child: Image.asset("images/background.png", fit: BoxFit.fill)),
            Column(
              // crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center, // top - t0 button
              children: <Widget>[
                Container(
                  alignment: Alignment.center, //left to right
                  height: 80,

                  child: LoadingIndicator(
                      indicatorType: Indicator.lineScalePulseOut,

                      /// Required, The loading type of the widget
                      colors: _kDefaultRainbowColors,

                      /// Optional, The color collections
                      strokeWidth: 4.0,

                      /// Optional, The stroke of the line, only applicable to widget which contains line
                      //backgroundColor: Colors.white,      /// Optional, Background of the widget
                      pathBackgroundColor: Colors.black

                    /// Optional, the stroke backgroundColor
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "PRINTO",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.w800),
                      ),
                      Text(
                        "NEX",
                        style: TextStyle(
                            color: Color(0xffFFA700),
                            fontSize: 25,
                            fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Version",
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                            fontWeight: FontWeight.w800),
                      ),
                      SizedBox(width: 3),
                      Text(
                        "1.0.1",
                        style: TextStyle(
                            color: Color(0xffe6e6e6),
                            fontSize: 10,
                            fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}
