import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:printonex_final/consts/firebase/firestore_constants.dart';
import 'package:printonex_final/models/chat_user.dart';
import 'package:shared_preferences/shared_preferences.dart';


enum Status {
  uninitialized,
  authenticated,
  authenticating,
  authenticateError,
  authenticateCanceled,
  authenticatecheck,
}

class AuthProvider extends ChangeNotifier {

  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firebaseFirestore;
  final SharedPreferences prefs;
  Status _status = Status.uninitialized;
  Status get status => _status;

  AuthProvider(
      {
      required this.firebaseAuth,
      required this.firebaseFirestore,
      required this.prefs});

  String? getFirebaseUserId() {
    return prefs.getString(FirestoreConstants.id);
  }


  Future<bool> isLoggedIn() async {
    var isLoggedIn = false;
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
        isLoggedIn = false;
      } else {
        isLoggedIn = true;
      }
    });
    if (isLoggedIn &&
        prefs.getString(FirestoreConstants.id)?.isNotEmpty == true) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> registerUsingEmailPassword({required String name,required String email,required String password,}) async {
    _status = Status.authenticating;
    notifyListeners();
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = userCredential.user;
      await user!.updateProfile(displayName: name);
      await user.reload();
      user = auth.currentUser;
      if (user != null) {
        final QuerySnapshot result = await firebaseFirestore
            .collection(FirestoreConstants.pathUserCollection)
            .where(FirestoreConstants.id, isEqualTo: user.uid)
            .get();
        final List<DocumentSnapshot> document = result.docs;
        if (document.isEmpty) {
          firebaseFirestore
              .collection(FirestoreConstants.pathUserCollection)
              .doc(user.uid)
              .set({
            FirestoreConstants.displayName: user.displayName,
            FirestoreConstants.photoUrl: user.photoURL,
            FirestoreConstants.id: user.uid,
            "createdAt: ": DateTime.now().millisecondsSinceEpoch.toString(),
            FirestoreConstants.chattingWith: "8ZywDVWyFice42nvCF3n9BVdoO03"
          });

          User? currentUser = user;
          await prefs.setString(FirestoreConstants.id, currentUser.uid);
          await prefs.setString(
              FirestoreConstants.displayName, currentUser.displayName ?? "");
          await prefs.setString(
              FirestoreConstants.photoUrl, currentUser.photoURL ?? "");
          await prefs.setString(
              FirestoreConstants.phoneNumber, currentUser.phoneNumber ?? "");
        } else {
          DocumentSnapshot documentSnapshot = document[0];
          PrintonexUsers userChat = PrintonexUsers.fromDocument(documentSnapshot);
          await prefs.setString(FirestoreConstants.id, userChat.id);
          await prefs.setString(
              FirestoreConstants.displayName, userChat.displayName);
          await prefs.setString(FirestoreConstants.aboutMe, userChat.aboutMe);
          await prefs.setString(
              FirestoreConstants.phoneNumber, userChat.phoneNumber);
        }
        _status = Status.authenticated;
        notifyListeners();
        return true;
      } else {
        _status = Status.authenticateError;
        notifyListeners();
        return false;
      }


    } on FirebaseAuthException catch (e) {

      if (e.code == 'weak-password') {
        _status = Status.authenticateError;
        notifyListeners();
        return false;
      } else if (e.code == 'email-already-in-use') {
        _status = Status.authenticateError;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _status = Status.authenticateError;
      notifyListeners();
      return false;

    }

    _status = Status.authenticated;
    notifyListeners();
    return true;
  }
  static Future<void> sendPasswordResetEmail({required String email,}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    try {
      await auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Fail!', ' ${e.code}',backgroundColor: Colors.deepPurpleAccent);
      Get.snackbar('Fail!', '${e.message}',backgroundColor: Colors.deepPurpleAccent);
    }
  }
  Future<bool> signInUsingEmailPassword({required String email,required String password,}) async {
    _status = Status.authenticating;
    notifyListeners();
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      user = userCredential.user;
      if (user != null) {
        final firebaseAuth = FirebaseAuth.instance;
        final FirebaseFirestore firebasestore =  FirebaseFirestore.instance;
        await firebasestore
            .collection(FirestoreConstants.pathUserCollection)
            .doc(firebaseAuth.currentUser!.uid)
            .update({
          'online': "ONLINE",
          'wetlet' : "0.01"

        });
        await prefs.setString(FirestoreConstants.id, user.uid);
        await prefs.setString(
            FirestoreConstants.displayName, user.displayName ?? "");
        await prefs.setString(
            FirestoreConstants.photoUrl, user.photoURL ?? "");
        await prefs.setString(
            FirestoreConstants.phoneNumber, user.phoneNumber ?? "");
        _status = Status.authenticated;
        notifyListeners();
        return true;

      }
      else{
        _status = Status.authenticateError;
        notifyListeners();
        return false;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print(e.code);
        _status = Status.authenticateError;
        Get.snackbar('Fail!', 'Something Error Contact Costumer',
            backgroundColor: Colors.orangeAccent);
        notifyListeners();
        return false;

      } else if (e.code == 'wrong-password') {
        print(e.code);
        Get.snackbar('Fail!', 'Something Error Contact Costumer',
            backgroundColor: Colors.orangeAccent);
        _status = Status.authenticateError;
        notifyListeners();
        return false;

      }
    }
    _status = Status.authenticatecheck;
    notifyListeners();
    return false;
  }
  static Future<User?>signInAnonymously() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      UserCredential userCredential = await auth.signInAnonymously();
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "operation-not-allowed":
          Get.snackbar('Fail!', "Anonymous auth hasn't been enabled for this project.", backgroundColor: Colors.greenAccent);
          break;
        default:
          Get.snackbar('Fail!', "Unknown error.", backgroundColor: Colors.greenAccent);
      }
    }
    return user;
  }
  static Future<User?> refreshUser(User user) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    await user.reload();
    User? refreshedUser = auth.currentUser;

    return refreshedUser;
  }
  Future<void> SignOut() async {
    _status = Status.uninitialized;
    await firebaseAuth.signOut();
  }

}
