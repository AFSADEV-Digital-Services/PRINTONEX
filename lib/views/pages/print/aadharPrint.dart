import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:printonex_final/controllers/pdfgenerater.dart';
import 'package:printonex_final/services/add_images.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
class AadharPrint extends StatefulWidget {
  const AadharPrint({Key? key}) : super(key: key);

  @override
  State<AadharPrint> createState() => _AadharPrintState();
}

class _AadharPrintState extends State<AadharPrint> {
  List<String> images = [];
  List<String> selectedimages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Print Aadhar"),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          ),
        ),
        backgroundColor: Colors.greenAccent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              _awaitReturnValueFromSecondScreen(context);
            },
            icon: const Icon(Icons.add_a_photo, color: Colors.black87,),
          )
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 5,),

          Center(
            child: Container(
              alignment: Alignment.center,
              height: Get.height/4,
              width: Get.width/1.5,
              color: Colors.red,
              child: Center(
                child: selectedimages!=null?Image.network(selectedimages[1]):Icon(
                  Icons.add_a_photo,
                  size: 30,
                  color: Colors.black,
                ),
              )
            ),
          ),
        SizedBox(height: 5,),
          Center(
            child: Container(
              alignment: Alignment.center,
              color: Colors.green,
              width: Get.width/1.5,
              height: Get.height/4,
                child: Center(
                  child: selectedimages!=null?Image.network(selectedimages[0]):Icon(
                    Icons.add_a_photo,
                    size: 30,
                    color: Colors.black,
                  ),
                )
            ),
          ),
          SizedBox(height: 20,),
          ElevatedButton(onPressed: () async {
            final pdfFile =
                await PdfApi.generateCenteredText('Aadhar Print', selectedimages[0].toString(), selectedimages[1].toString() );
            //PdfApi.openFile(pdfFile);
          }, child: Text("Upload Order"))

        ],
      ),

    );
  }
  void _awaitReturnValueFromSecondScreen(BuildContext context) async {
    // start the SecondScreen and wait for it to finish with a result
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddImages(),
        ));

    // after the SecondScreen result comes back update the Text widget with it
    if(images!=null){
      setState(() {
        images = result;
        for (int i = 0; i < images.length; i++) {
          selectedimages.add(images[i].toString());
        }
      });
    }

  }
}
