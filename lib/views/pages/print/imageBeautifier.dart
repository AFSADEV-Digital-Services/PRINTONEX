import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
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
import 'package:printonex_final/views/pages/print/PrintPhoto.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
          'Wait', 'Wait 15 Sec AI is Processing Your Image',
          backgroundColor: Colors.orange);
      var jsonData = json.decode(response.body);
      var id = jsonData["id"];
      print(id);
      setState(() {
        currentimgid= id;
      });
      await Future.delayed(const Duration(seconds: 15), () {
        getImage(id);
      });
    }
    else{
      Get.snackbar(
          'FAIL', 'http.post error: statusCode= ${response.statusCode}',
          backgroundColor: Colors.red);

      }


  }
  getImage(id) async {
    print(id);
    var headers = {
      'Authorization': 'Token 89021c58b3c579caed1744b6bca680658e107f55',
    };
    var url = Uri.parse('https://api.replicate.com/v1/predictions/$id');
    try{
      var res = await http.get(url, headers: headers);
      if (res.statusCode != 200) throw Exception('http.get error: statusCode= ${res.statusCode}');
      var jsonData = json.decode(res.body);
      print(jsonData["output"]);

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
        outputImageMirror= jsonData["msg"];
      });
    }
    catch (e) {
      print(e);
    }





  }
  Future<void> _download(String url) async {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Colors.black87,
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
          outputImage==null?IconButton(
            icon: const Icon(Icons.refresh, color: Colors.red),
            onPressed: () {
              setState(() {
                getImage(currentimgid);
                showProgress = true;
              });
            },
          ): Container(

                ),
          IconButton(
            icon: const Icon(Icons.format_paint, color: Colors.pinkAccent),
            onPressed: () {
              setState(() {
                sendFile();
                showProgress = true;
              });
            },
          ),
            IconButton(
              onPressed: () {
                _awaitReturnValueFromSecondScreen(context);
              },
              icon: const Icon(
                Icons.add_a_photo,
                color: Colors.black87,
              ),
            )

        ],
      ),
      body: Stack(
        children: [
          Container(
            width: ResponsiveFile.screenWidth,
            height: ResponsiveFile.screenHeight,
            color: Colors.black87,
            child: outputImage != null
                ? BeforeAfter(
              beforeImage: Image.network(
                imagefile.toString(),
              ),
              afterImage: Image.network(
                outputImage.toString(),
              ),
            )
                : Image.network(
              imagefile.toString()
            ),
          ),
          // if (showProgress == true)
          //   const Opacity(
          //     opacity: 0.8,
          //     child: ModalBarrier(dismissible: false, color: Colors.black),
          //   )
          // else
          //   Container(),
          // Center(
          //   child: showProgress == true
          //       ? const CircularProgressIndicator()
          //       : Container(),
          // ),
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
          outputImage != null
              ? Positioned(
            bottom: 10,
            left: 10,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: Colors.pinkAccent,
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
          )
              : Container(),
          Positioned(
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
          )
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
