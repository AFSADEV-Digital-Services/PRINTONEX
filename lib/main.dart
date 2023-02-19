import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:printonex_final/Providers/auth_provider.dart';
import 'package:printonex_final/Providers/chat_provider.dart';
import 'package:printonex_final/Providers/home_provider.dart';
import 'package:printonex_final/Providers/profile_provider.dart';
import 'package:printonex_final/firebase_options.dart';
import 'package:printonex_final/views/pages/splash.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  // MobileAds.instance.initialize();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // transparent status bar
  ));
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await GetStorage.init();
  runApp(MyApp(prefs: prefs));

}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  MyApp({Key? key, required this.prefs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
            create: (_) => AuthProvider(
                firebaseFirestore: firebaseFirestore,
                prefs: prefs,
                // googleSignIn: GoogleSignIn(),
                firebaseAuth: FirebaseAuth.instance)),
        Provider<ProfileProvider>(
            create: (_) => ProfileProvider(
                prefs: prefs,
                firebaseFirestore: firebaseFirestore,
                firebaseStorage: firebaseStorage)),
        Provider<ChatProvider>(
            create: (_) => ChatProvider(
                prefs: prefs,
                firebaseStorage: firebaseStorage,
                firebaseFirestore: firebaseFirestore)),

        Provider<HomeProvider>(
            create: (_) => HomeProvider(firebaseFirestore: firebaseFirestore)),
        ],
      child: GetMaterialApp(
        title: 'PRINTONEX',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch()
              .copyWith(secondary: Colors.greenAccent),
          textSelectionTheme: const TextSelectionThemeData(
              cursorColor: Colors.green
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              textStyle: const TextStyle(
                fontSize: 24.0,
              ),
              padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
            ),
          ),
          textTheme: TextTheme(
            headline1: TextStyle(
              fontSize: 46.0,
              color: Colors.blue.shade700,
              fontWeight: FontWeight.w500,
            ),
            bodyText1: const TextStyle(fontSize: 18.0),
          ),
        ),
        home: const Splash(),
      ),
    );

  }
}
