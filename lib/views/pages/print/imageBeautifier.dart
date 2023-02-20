import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:printonex_final/consts/responsive_file.dart';
import 'package:printonex_final/consts/text_class.dart';
import 'package:printonex_final/services/add_images.dart';

import 'package:before_after_image_slider_nullsafty/before_after_image_slider_nullsafty.dart';
import 'dart:convert';

import 'dart:typed_data';

import 'package:http/http.dart' as http;


import 'package:image_gallery_saver/image_gallery_saver.dart';


import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:printonex_final/views/pages/chat.dart';
import 'package:printonex_final/views/pages/checkout.dart';

import 'package:printonex_final/views/pages/print/PrintPhoto.dart';
import 'package:screenshot/screenshot.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whatsapp_share/whatsapp_share.dart';
class ImageBeautifier extends StatefulWidget {

  @override
  State<ImageBeautifier> createState() => _ImageBeautifierState();
}

class _ImageBeautifierState extends State<ImageBeautifier> {

  String? id, imagefile,_userId;
  String? outputImage,outputImageMirror,currentimgid;
  bool downloading = false;
  List<String> images = [];
  String progress = '0';
  bool isDownloaded = false;
  final List<int> _bytes = [];
  late http.StreamedResponse _response;
  late bool error, showProgress;
  List<String> log = [];
  final _controller = ScreenshotController();
  File? _image;


  @override
  void initState() {
    super.initState();
    showProgress = false;

  }

  sendFile() async {

    String apiUrl = "https://api.replicate.com/v1/predictions";
    var data = '\n{"version": "9283608cc6b7be6b65a8e44983db012355fde4132009bf99d976b2f0896856a3", "input": {"img": "$imagefile"}}\n';
    var headers = {
      'Authorization': 'Token 89021c58b3c579caed1744b6bca680658e107f55',
      'Content-Type': 'application/json',
    };
    var response = await http.post(Uri.parse(apiUrl), headers: headers, body: data);
    if (response.statusCode == 201) {
      Get.snackbar(
          'Wait', 'Wait 20-30 Depending on file size Sec AI is Processing Your Image',
          backgroundColor: Colors.orange);
      var jsonData = json.decode(response.body);
      var id = jsonData["id"];
      print(id);
      setState(() {
        currentimgid= id;
      });

      await Future.delayed(const Duration(seconds: 30), () {
        getImage(id);
      });
    }
    else{
      setState(() {
        log.add('Image Inhancher/Error:${response.statusCode}');
      });
      Get.snackbar(
          'FAIL', 'http.post error: statusCode= ${response.statusCode}',
          backgroundColor: Colors.red);

      }


  }
  getImage(id) async {
    Get.snackbar(
        'Wait', 'AI is Inhanching Your Image id: $id',
        backgroundColor: Colors.orange);
    var headers = {
      'Authorization': 'Token 89021c58b3c579caed1744b6bca680658e107f55',
    };
    var url = Uri.parse('https://api.replicate.com/v1/predictions/$id');
    try{
      var res = await http.get(url, headers: headers);
      if (res.statusCode != 200) throw Exception('http.get error: statusCode= ${res.statusCode}');
      var jsonData = json.decode(res.body);
      print(jsonData);
      setState(() {
        log.add(jsonData.toString());
      });
      await Future.delayed(const Duration(seconds: 5), () {
      if (jsonData["status"]=='succeeded') {

          Get.snackbar(
              'SUCCESS', 'Successfully Inhanched Image',
              backgroundColor: Colors.green);
          Get.snackbar(
              'SUCCESS', 'If Not Showing Click Refresh From Tolbar',
              backgroundColor: Colors.green);
          setState(() {
            showProgress = false; //don't show progress indicator
            error = true;
            outputImage = jsonData["output"];
            outputImageMirror = jsonData["msg"];
          });
          _download(outputImage.toString());


      }else{

        Get.snackbar(
            'Failed', 'Failed to process Upload Only Low Image,Small Size, and Blur Image',
            backgroundColor: Colors.redAccent);
        setState(() {
          showProgress = false; //don't show progress indicator
          error = true;
          imagefile = null;
          outputImage=null;
        });
      }
      });

    }
    catch (e) {
      print(e);
      setState(() {
        log.add("Error While Generating Image: $id and error is : $e");
        imagefile = null;
        outputImage=null;
        showProgress = false; //don't show progress indicator
        error = true;
      });
    }





  }

  Future<void> _download(String url) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Checkout(price: '0.30', fileurl: outputImage.toString(), product: 'ImageBeautyfy', producturl: 'https://firebasestorage.googleapis.com/v0/b/printonex-eeff2.appspot.com/o/products%2Fimage_inhancher.png?alt=media&token=8f4198c8-83da-4957-96b6-a2e70d24f086'),
      ),
    );
    setState(() {
      downloading = true;
    });
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    var response = await Dio().get(url, onReceiveProgress: (rcv, total) {
      setState(() {
        progress = ((rcv / total) * 100).toStringAsFixed(0);
      });

      if (progress == '100') {
        setState(() {
          isDownloaded = true;
        });
      } else if (double.parse(progress) < 100) {}
    }, options: Options(responseType: ResponseType.bytes)).then((_) {
      setState(() {
        if (progress == '100') {
          isDownloaded = true;

        }

        downloading = false;
      });
    });
    var response2 = await Dio()
        .get(url, options: Options(responseType: ResponseType.bytes));
    final result = await ImageGallerySaver.saveImage(
        Uint8List.fromList(response2.data),
        quality: 100,
        name: "Printonex_${DateTime.now().millisecond}");
    Get.snackbar(
        'Success', 'Save on Gallery "Printonex_${DateTime.now().millisecond}"',
        backgroundColor: Colors.green);
    print("Printonex_${DateTime.now()}");
  }
  void share() async {
    await FlutterShare.share(
        title: 'PRINTONEX APP',
        text: 'Download Our Online App for any Services👇',
        linkUrl: 'https://afsadev.in/Download/PrintoNexOnline.apk '
            'Your Image Can Download From this link 👇'
            '$outputImage',
        chooserTitle: 'PRINTONEX');
  }



  void reporterror(List<String> log) async {
    FlutterShare.share(
        title: 'PRINTONEX APP',
        text: 'Has Error Plz Solve Problem👇',
        linkUrl: '$log',
        chooserTitle: 'PRINTONEX');
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => Chat("$log"),
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      appBar: AppBar(
        title: const AppText(
          text: "Image Beautifier",
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
          // IconButton(
          //   icon: const Icon(Icons.refresh, color: Colors.red),
          //   onPressed: () {
          //     setState(() {
          //       //_showRewardedAd();
          //     });
          //   },
          // ),
          currentimgid!=null?IconButton(
            icon: const Icon(Icons.refresh, color: Colors.red),
            onPressed: () {
              setState(() {
                getImage(currentimgid);
                showProgress = true;
              });
            },
          ):Container(),
          imagefile!=null?IconButton(
            icon: const Icon(Icons.format_paint, color: Colors.pinkAccent),
            onPressed: () {
              setState(() {
                sendFile();
                //getadsreward();
                showProgress = true;
              });
            },
          ):
            Container(),
          IconButton(
            onPressed: () {
              _awaitReturnValueFromSecondScreen(context);
            },
            icon: const Icon(
              Icons.add_a_photo,
              color: Colors.black87,
            ),
          ),

        ],
      ),
      body: Stack(
        children: [
          Container(
            width: ResponsiveFile.screenWidth,
            height: ResponsiveFile.screenHeight,
            color: Colors.black87,
            child: imagefile!=null?

                BeforeAfter(
              beforeImage: CachedNetworkImage(
                imageUrl: imagefile.toString(),
                fit: BoxFit.fill,
                errorWidget: (context, url, error) =>
                const Icon(
                  Icons.account_circle,
                  color: Colors.white,
                  size: 120,
                ),
              ),
              afterImage: CachedNetworkImage(
                imageUrl: outputImage.toString(),
                fit: BoxFit.fill,
                errorWidget: (context, url, error) =>
                const Icon(
                  Icons.account_circle,
                  color: Colors.white,
                  size: 120,
                ),
              ),
            )

            :Center(

                child: InkWell(
                  onTap: (){
                      _awaitReturnValueFromSecondScreen(context);
                  },
                  child: AppText(
                    text: "Click the Above Camera Icon\n "
                        "      select Images or Files",
                    size: ResponsiveFile.font16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ))
          ),

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
          outputImage != null? Positioned(
            bottom: 10,
            left: 10,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: Colors.blueAccent,
                  onPrimary: Colors.white,
                  shape: const RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.all(const Radius.circular(20)))),
              onPressed: () async {
                 _download(outputImage.toString());
              },
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    isDownloaded
                        ? AppText(
                      text: "Downloaded",
                      fontWeight: FontWeight.bold,
                      size: ResponsiveFile.font16,
                    )
                        : AppText(
                      text: "Download",
                      fontWeight: FontWeight.bold,
                      size: ResponsiveFile.font16,
                    ),

                    SizedBox(
                      width: ResponsiveFile.height10,
                    ),
                    Visibility(
                        visible: downloading,
                        child: CircularPercentIndicator(
                          radius: 20.0,
                          lineWidth: 3.0,
                          // percent: (progress/100),
                          center: Text(
                            "$progress%",
                            style: const TextStyle(
                                fontSize: 12, color: Colors.blue),
                          ),
                          progressColor: Colors.blue,
                        )),

                    Icon(
                      Icons.download_for_offline,
                      color: isDownloaded ? Colors.white : Colors.grey,
                    )

                    // const Icon(Icons.download_for_offline)
                  ],
                ),
              ),
            ),
          ): Container(),
          log.isEmpty?Container():Positioned(
            bottom: 80,
            right: 10,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: Colors.orangeAccent,
                  onPrimary: Colors.white,
                  shape: const RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.all(const Radius.circular(20)))),
              onPressed: () {
              reporterror(log);
              },
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    AppText(
                      text: "Report Error",
                      fontWeight: FontWeight.bold,
                      size: ResponsiveFile.font16,
                    ),
                    SizedBox(
                      width: ResponsiveFile.height10,
                    ),
                    const Icon(Icons.share)
                  ],
                ),
              ),
            ),
          ),
          outputImage != null?Positioned(
            bottom: 10,
            right: 10,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: Colors.pinkAccent,
                  onPrimary: Colors.white,
                  shape: const RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.all(const Radius.circular(20)))),
              onPressed: () {

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PrintPhoto(
                      selectedimages: [outputImage.toString()],
                    ),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    AppText(
                      text: "Print Now",
                      fontWeight: FontWeight.bold,
                      size: ResponsiveFile.font16,
                    ),
                    SizedBox(
                      width: ResponsiveFile.height10,
                    ),
                    const Icon(Icons.print)
                  ],
                ),
              ),
            ),
          ):Container(),
          outputImage != null?Positioned(
            bottom: 80,
            left: 10,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: Colors.greenAccent,
                  onPrimary: Colors.white,
                  shape: const RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.all(const Radius.circular(20)))),
              onPressed: () {
                share();


              },
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    AppText(
                      text: "Share Now",
                      fontWeight: FontWeight.bold,
                      size: ResponsiveFile.font16,
                    ),
                    SizedBox(
                      width: ResponsiveFile.height10,
                    ),
                    const Icon(Icons.share)
                  ],
                ),
              ),
            ),
          ):Container()
        ],
      ),

    );
  }
  void _awaitReturnValueFromSecondScreen(BuildContext context) async {
    // start the SecondScreen and wait for it to finish with a result
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const AddImages(),
        ));

    // after the SecondScreen result comes back update the Text widget with it
    setState(() {
      images = result;
      imagefile = images.join("");
    });
  }
}
