import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

class FireStoreDataBase {
  String? downloadURL;

  Future getData() async {
    try {
      await downloadURLExample();
      return downloadURL;
    } catch (e) {
      debugPrint("Error - $e");
      return null;
    }
  }

  Future<void> downloadURLExample() async {
    QuerySnapshot downloadURL = await FirebaseFirestore.instance.collection('banners').get();
    debugPrint(downloadURL.toString());
  }
}