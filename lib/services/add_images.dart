import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;


class Add_images extends StatefulWidget {
  const Add_images({Key? key}) : super(key: key);

  @override
  State<Add_images> createState() => _Add_imagesState();
}

class _Add_imagesState extends State<Add_images> {
  List<File> images = [];
  UploadTask? uploadTask;

  TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Upload multiple files")),
      body: Container(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(children: [
            SizedBox(
              height: 50,
            ),
            InkWell(
              onTap: () {
                getMultipImage();
              },
              child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(8)),
                  child: const Center(
                    child: Icon(
                      Icons.upload_file,
                      size: 50,
                    ),
                  )),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              width: Get.width,
              height: 150,
              child: images.length == 0
                  ? Center(
                child: Text("No Images found"),
              )
                  : ListView.builder(
                scrollDirection: Axis.horizontal,
                itemBuilder: (ctx, i) {
                  return Container(
                      width: 100,
                      margin: EdgeInsets.only(right: 10),
                      height: 100,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(8)),
                      child: Image.file(
                        images[i],
                        fit: BoxFit.cover,
                      ));
                },
                itemCount: images.length,
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: messageController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Write Message Or Keep Blank'),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: MaterialButton(
                color: Colors.blue,
                minWidth: double.infinity,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                height: 50,
                onPressed: () async {
                  for (int i = 0; i < images.length; i++) {
                    String url = await uploadFile(images[i]);
                    downloadUrls.add(url);

                    if (i == images.length - 1) {
                      storeEntry(downloadUrls, messageController.text).whenComplete(() => Navigator.of(context).pop(downloadUrls));
                    }
                  }
                },
                child: Text("Upload"),
              ),
            ),
            buildProgress(),
          ]),
        ),
      ),
    );
  }

  Widget buildProgress() => StreamBuilder<TaskSnapshot>(
      stream: uploadTask?.snapshotEvents,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data!;
          double progress = data.bytesTransferred / data.totalBytes;
          return SizedBox(
            height: 50,
            child: Stack(
              fit: StackFit.expand,
              children: [
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey,
                  color: Colors.green,
                ),
                Center(
                  child: Text(
                    '${(100 * progress).roundToDouble()}%',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          );
        } else {
          return const SizedBox(height: 50);
        }
      });

  List<String> downloadUrls = [];

  final ImagePicker _picker = ImagePicker();

  getMultipImage() async {
    final List<XFile>? pickedImages = await _picker.pickMultiImage();
    if (pickedImages != null) {
      pickedImages.forEach((e) {
        images.add(File(e.path));
      });
      setState(() {});
    }
  }

  Future<String> uploadFile(File file) async {

    final path= 'user_upload/${Path.basename(file.path)}';
    final metaData = SettableMetadata(contentType: 'image/jpeg');
    final storageRef = FirebaseStorage.instance.ref().child(path);

    setState(() {
      uploadTask = storageRef.putFile(file, metaData);
    });
    final taskSnapshot = await uploadTask!.whenComplete(() {});
    String url = await taskSnapshot.ref.getDownloadURL();
    return url;
  }

  storeEntry(List<String> imageUrls, String message) async {
    final _auth = FirebaseAuth.instance;
    dynamic user;
    String userEmail;
    user = await _auth.currentUser!;
    userEmail = user.email;
    FirebaseFirestore.instance.collection('uploader').add({
      'fileUrl': imageUrls,
      'email': userEmail,
      'createdAt': FieldValue.serverTimestamp(),
      'message': message
    }).then((value) {
      Get.snackbar('Success', 'Data is stored successfully',
          backgroundColor: Colors.greenAccent);

    });
  }
}
