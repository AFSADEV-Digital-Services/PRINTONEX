

import 'dart:async';

import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import 'package:printonex_final/consts/responsive_file.dart';
import 'package:printonex_final/consts/text_class.dart';


import 'package:receive_sharing_intent/receive_sharing_intent.dart';

class AddImages extends StatefulWidget {
  const AddImages({Key? key}) : super(key: key);

  @override
  State<AddImages> createState() => _AddImagesState();
}

class _AddImagesState extends State<AddImages> {
  late StreamSubscription _intentDataStreamSubscription;
  List<SharedMediaFile>? _sharedFiles;
  String? _sharedText;
  List<File> images = [];
  List<String> downloadUrls = [];
  UploadTask? uploadTask;
  var _current = 0;
  String progress = '0';
  bool isDownloaded = false;
  final List<int> _bytes = [];
  late bool error, showProgress;
  TextEditingController messageController = TextEditingController();
  final CarouselController _controller = CarouselController();
  List<String> selectedimages = [];


  List<dynamic> userfile= [];

  getData() async {
    final auth = FirebaseAuth.instance;
    dynamic user;
    String userEmail, uid;
    user = auth.currentUser!;
    uid = user.uid;
    // QuerySnapshot bannersRef =
    // await FirebaseFirestore.instance.collection('uploader').doc(uid).collection(uid).get();
    print(userfile);
    QuerySnapshot bannersRef =
    await FirebaseFirestore.instance.collection('uploader').doc(uid).collection(uid).get();
    setState(() {
      for (int g = 0; g < bannersRef.docs.length; g++) {
        print(bannersRef.docs[g]["fileUrl"].length);
        for (int i = 0; i < bannersRef.docs[g]["fileUrl"].length; i++) {
          userfile.add(
            bannersRef.docs[g]["fileUrl"][i],
          );
        }
      }
    });
    return bannersRef.docs;

  }


  @override
  void initState() {
    super.initState();

    getData();

    showProgress = false;
    // For sharing images coming from outside the app while the app is in the memory
    _intentDataStreamSubscription = ReceiveSharingIntent.getMediaStream()
        .listen((List<SharedMediaFile> value) {
      setState(() {
        _sharedFiles = value;
        images.add(File((_sharedFiles?.map((f) => f.path).join(",") ?? "")));
        print("Shared:" + (_sharedFiles?.map((f) => f.path).join(",") ?? ""));
      });
    }, onError: (err) {
      print("getIntentDataStream error: $err");
    });

    // For sharing images coming from outside the app while the app is closed
    ReceiveSharingIntent.getInitialMedia().then((List<SharedMediaFile> value) {
      setState(() {
        _sharedFiles = value;
        var sharedfile = (_sharedFiles?.map((f) => f.path).join(",") ?? "");
        //images.add(File(sharedfile));
        print("Shared Closed:" +
            (_sharedFiles?.map((f) => f.path).join(",") ?? ""));
      });
    });

  }

  @override
  void dispose() {
    _intentDataStreamSubscription.cancel();
    _controller;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: const AppText(
          text: "File/Images Uploader",
          color: Colors.black54,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          ),
        ),
        backgroundColor: Colors.greenAccent,
        elevation: 0,
        actions: [
          Row(
            children: [
              images.isEmpty
                  ? Container()
                  : IconButton(
                      onPressed: () {
                        setState(() {
                          images.remove(images[_current]);
                        });
                      },
                      icon: const Icon(Icons.delete_forever),
                    ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.crop),
              ),
              IconButton(
                onPressed: () {
                  getMultipleImage();
                },
                icon: const Icon(Icons.add_a_photo),
              ),
            ],
          )
        ],
      ),
      body: images.isEmpty
          ? Stack(
            children: [
              SizedBox(
                  height: ResponsiveFile.screenHeight,
                  width: ResponsiveFile.screenWidth,
                  child:

                  GridView.builder(
                    itemCount: userfile.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                    ),
                    scrollDirection: Axis.vertical,
                    itemBuilder: (ctx, i) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (selectedimages.contains(userfile[i].toString())) {
                              selectedimages.remove(userfile[i].toString());
                            } else {
                              selectedimages.add(userfile[i].toString());
                            }
                            if (kDebugMode) {
                              print(selectedimages);
                            }
                          });
                        },
                        child: Stack(
                          children: [
                            Container(
                              width: ResponsiveFile.height150,
                              margin: EdgeInsets.all(ResponsiveFile.height10 / 3.3),
                              height: ResponsiveFile.height150,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      ResponsiveFile.height10 / 1.25),
                                  image: DecorationImage(
                                      image: NetworkImage(userfile[i]),
                                      fit: BoxFit.cover)),
                              child:  Image.network(
                                userfile[i],
                                fit: BoxFit.fill,
                                loadingBuilder: (BuildContext context, Widget child,
                                    ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value: loadingProgress.expectedTotalBytes != null
                                          ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                          : null,
                                    ),
                                  );
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(ResponsiveFile.height10 / 2),
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: selectedimages.contains(userfile[i].toString())
                                    ? const Icon(
                                  Icons.check_box,
                                  color: Colors.greenAccent,
                                )
                                    : const Icon(
                                  Icons.check_box_outline_blank,
                                  color: Colors.redAccent,
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
              selectedimages!=null?Positioned(
                bottom: 10,
                left: 10,
                right: 10,
                child: Row(
                  children: [

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.orange,
                        onPrimary: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              ResponsiveFile.height10 / 2),
                        ),
                      ),
                      onPressed: () async {
                        Navigator.of(context).pop(selectedimages);

                      },
                      child: Row(
                        children: [

                          Text("Process"),
                          SizedBox(
                            width: ResponsiveFile.height10,
                          ),
                          const Icon(Icons.backup),
                        ],
                      ),
                    ),
                  ],
                ),
              ):Container(),
              selectedimages!=null?Positioned(
                bottom: 50,
                right: 10,
                left: 10,
                child: Row(
                  children: [

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.orange,
                        onPrimary: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              ResponsiveFile.height10 / 2),
                        ),
                      ),
                      onPressed: () async {
                        Navigator.of(context).pop(selectedimages);

                      },
                      child: Row(
                        children: [

                          Text("Process"),
                          SizedBox(
                            width: ResponsiveFile.height10,
                          ),
                          const Icon(Icons.backup),
                        ],
                      ),
                    ),
                  ],
                ),
              ):Container(),
            ],

          )
          : Stack(
              children: [
                if (showProgress == true)
                  const Opacity(
                    opacity: 0.8,
                    child: ModalBarrier(dismissible: false, color: Colors.black),
                  )
                else
                  Container(),
                Center(
                  child: showProgress == true
                      ? const CircularProgressIndicator()
                      : Container(),
                ),
                Container(
                  color: Colors.black87,
                  width: ResponsiveFile.screenWidth,
                  height: ResponsiveFile.screenHeight,
                  child: CarouselSlider.builder(
                    itemCount: images.length,
                    itemBuilder: (BuildContext context, int itemIndex,
                            int pageViewIndex) =>
                        Image.file(
                      images[itemIndex],
                    ),
                    options: CarouselOptions(
                        autoPlay: false,
                        padEnds: true,
                        disableCenter: true,
                        enlargeCenterPage: false,
                        viewportFraction: 1,
                        aspectRatio: 2,
                        initialPage: 2,
                        pauseAutoPlayInFiniteScroll: false,
                        scrollDirection: Axis.horizontal,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _current = index;
                            print(_current);
                          });
                        }),
                  ),
                ),
                Positioned(
                    bottom: 10,
                    child: buildProgress()),
                Positioned(
                  bottom: 70,
                  left: 10,
                  right: 10,
                  child: SizedBox(
                    width: Get.width,
                    height: 50,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (ctx, i) {
                        return Container(
                            width: 50,
                            height: 50,
                            margin: const EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                            ),
                            child: GestureDetector(
                              onTap: () => _controller.animateToPage(i),
                              child: Image.file(
                                images[i],
                                fit: BoxFit.cover,
                              ),
                            ));
                      },
                      itemCount: images.length,
                    ),
                  ),
                ),

                Positioned(
                  bottom: 10,
                  left: 10,
                  right: 10,
                  child: Row(
                    children: [

                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.orange,
                          onPrimary: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                ResponsiveFile.height10 / 2),
                          ),
                        ),
                        onPressed: () async {
                          setState(() {
                            showProgress = true;
                          });
                          for (int i = 0; i < images.length; i++) {
                            String url = await uploadFile(images[i]);
                            downloadUrls.add(url);
                            if (i == images.length - 1) {
                              storeEntry(downloadUrls, messageController.text)
                                  .whenComplete(() =>
                                      Navigator.of(context).pop(downloadUrls));
                            }
                          }
                        },
                        child: Row(
                          children: [

                            Text("File: ${images.length}"),
                            SizedBox(
                              width: ResponsiveFile.height10,
                            ),
                            const Icon(Icons.upload),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
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

  final ImagePicker _picker = ImagePicker();

  getMultipleImage() async {
    final List<XFile>? pickedImages = await _picker.pickMultiImage();
    if (pickedImages != null) {
      pickedImages.forEach((e) {
        images.add(File(e.path));
        if (kDebugMode) {
          print(File(e.path));
        }
      });
      setState(() {});
    }
  }

  Future<String> uploadFile(File file) async {
    final path = 'user_upload/${Path.basename(file.path)}';
    final metaData = SettableMetadata(contentType: 'image/jpeg');
    final storageRef = FirebaseStorage.instance.ref().child(path);

    setState(() {
      uploadTask = storageRef.putFile(file, metaData);
    });
    final taskSnapshot = await uploadTask!.whenComplete(() {});
    String url = await taskSnapshot.ref.getDownloadURL();
    if (kDebugMode) {
      print(url.toString());
    }
    return url;
  }

  storeEntry(List<String> imageUrls, String message) async {
    final auth = FirebaseAuth.instance;
    dynamic user;
    String userEmail, uid;
    user = auth.currentUser!;
    uid = user.uid;
    userEmail = user.email;

    FirebaseFirestore.instance.collection('uploader').doc('$uid').collection('$uid').add(
        {
          'fileUrl': imageUrls,
          'uid': uid,
          'email': userEmail,
          'createdAt': FieldValue.serverTimestamp(),
          'message': message
        })
    // ;
    // FirebaseFirestore.instance.collection('uploader').add({
    //   'fileUrl': imageUrls,
    //   'uid': uid,
    //   'email': userEmail,
    //   'createdAt': FieldValue.serverTimestamp(),
    //   'message': message
    // })
        .then((value) {
      Get.snackbar('Success', 'Data has Saved',
          backgroundColor: Colors.greenAccent);
    });
  }
}
