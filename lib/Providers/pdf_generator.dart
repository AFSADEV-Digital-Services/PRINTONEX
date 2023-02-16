import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileProvider {
  final SharedPreferences prefs;
  final FirebaseFirestore firebaseFirestore;
  final FirebaseStorage firebaseStorage;

  ProfileProvider({required this.prefs,
    required this.firebaseStorage,
    required this.firebaseFirestore});

  String? getPrefs(String key) {
    return prefs.getString(key);
  }
  UploadTask uploadImageFile(File image, String fileName, String id) {
    final path = 'user_upload/${id}/${fileName}';
    Reference reference = firebaseStorage.ref().child(path);
    UploadTask uploadTask = reference.putFile(image);
    return uploadTask;
  }
  Future<void> updateFirestoreData(String collectionPath, String path,
      Map<String, dynamic> dataUpdateNeeded) {
    return firebaseFirestore
        .collection(collectionPath)
        .doc(path)
        .update(dataUpdateNeeded);
  }

}