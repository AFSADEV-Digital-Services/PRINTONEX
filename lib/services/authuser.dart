import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FireAuth {
  // For registering a new user

  static Future<User?> registerUsingEmailPassword({required String name,required String email,required String password,}) async {
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
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Get.snackbar('Fail!', 'The password provided is too weak.',backgroundColor: Colors.greenAccent);
      } else if (e.code == 'email-already-in-use') {
        Get.snackbar('Fail!', 'The account already exists for that email.',backgroundColor: Colors.greenAccent);
      }
    } catch (e) {
      print(e);
    }

    return user;
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
  static Future<User?> signInUsingEmailPassword({required String email,required String password,}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = userCredential.user;

    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Get.snackbar('Fail!', 'No user found for that email.', backgroundColor: Colors.greenAccent);
      } else if (e.code == 'wrong-password') {
        Get.snackbar('Fail!', 'Wrong password provided.', backgroundColor: Colors.greenAccent);
      }
    }

    return user;
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

}
