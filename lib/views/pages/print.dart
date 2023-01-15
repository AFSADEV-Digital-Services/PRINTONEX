import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:printonex_final/consts/responsive_file.dart';
import 'package:printonex_final/consts/text_class.dart';
import 'package:printonex_final/services/add_images.dart';
import 'package:printonex_final/views/auth_pages/login.dart';

class Print extends StatefulWidget {



  @override

  State<Print> createState() => _PrintState();
}

class _PrintState extends State<Print> {
  List<String> images = [];



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Print Any Time Any Where"),
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
            icon: const Icon(Icons.add),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _awaitReturnValueFromSecondScreen(context);

        },
      ),
      body:  Container(
        width: ResponsiveFile.screenWidth,
        margin: EdgeInsets.all(ResponsiveFile.height10),
        decoration: BoxDecoration(
            borderRadius:
            BorderRadius.circular(ResponsiveFile.height20 / 1.23),
            border: Border.all(color: Colors.grey.withOpacity(0.3))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
images==0?Center(child: Text("No Image Upload"),)
            :Container(
              width: Get.width,
              height: 150,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemBuilder: (ctx, i) {
                  return Container(
                      width: 100,
                      margin: EdgeInsets.only(right: 10),
                      height: 100,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8)),
                      child: Image.network(images[i])

                  );
                },
                itemCount: images.length,
              ),
            ),
            SizedBox(
              height: ResponsiveFile.height20,
            ),
            Container(
              padding: EdgeInsets.only(
                left: ResponsiveFile.height10 / 2,
                right: ResponsiveFile.height10 / 2,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Flexible(
                    child: InkWell(
                      onTap: () {},
                      child: SizedBox(
                        width: ResponsiveFile.height80,
                        height: ResponsiveFile.height120 -
                            ResponsiveFile.height20,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: ResponsiveFile.height50,
                              width: ResponsiveFile.height50,
                              child: SvgPicture.asset(
                                  "images/photo_print.svg"),
                            ),
                            AppText(
                              text: "Photo Print",
                              textAlign: TextAlign.center,
                              size: ResponsiveFile.font14,
                              fontWeight: FontWeight.bold,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: InkWell(
                      onTap: () {},
                      child: SizedBox(
                        width: ResponsiveFile.height80,
                        height: ResponsiveFile.height120 -
                            ResponsiveFile.height20,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: ResponsiveFile.height50,
                              width: ResponsiveFile.height50,
                              child: SvgPicture.asset(
                                  "images/doc_print.svg"),
                            ),
                            AppText(
                              text: "Document Print",
                              textAlign: TextAlign.center,
                              size: ResponsiveFile.font14,
                              fontWeight: FontWeight.bold,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: InkWell(
                      onTap: () {},
                      child: SizedBox(
                        width: ResponsiveFile.height80,
                        height: ResponsiveFile.height120 -
                            ResponsiveFile.height20,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: ResponsiveFile.height50,
                              width: ResponsiveFile.height50,
                              child: SvgPicture.asset(
                                  "images/aadhar_print.svg"),
                            ),
                            AppText(
                              text: "Aadhar/Id Card Print",
                              textAlign: TextAlign.center,
                              size: ResponsiveFile.font14,
                              fontWeight: FontWeight.bold,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: InkWell(
                      onTap: () {},
                      child: SizedBox(
                        width: ResponsiveFile.height80,
                        height: ResponsiveFile.height120 -
                            ResponsiveFile.height20,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: ResponsiveFile.height50,
                              width: ResponsiveFile.height50,
                              child: SvgPicture.asset(
                                  "images/doc_scanner.svg"),
                            ),
                            AppText(
                              text: "Scan Document",
                              textAlign: TextAlign.center,
                              size: ResponsiveFile.font14,
                              fontWeight: FontWeight.bold,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: ResponsiveFile.height15,
            ),
            Container(
              padding: EdgeInsets.only(
                left: ResponsiveFile.height10 / 2,
                right: ResponsiveFile.height10 / 2,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Flexible(
                    child: InkWell(
                      onTap: () {},
                      child: SizedBox(
                        width: ResponsiveFile.height80,
                        height: ResponsiveFile.height120 -
                            ResponsiveFile.height20,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: ResponsiveFile.height50,
                              width: ResponsiveFile.height50,
                              child: Image.asset(
                                  "images/PDF_file_icon.svg.png"),
                            ),
                            AppText(
                              text: "Image to PDF",
                              textAlign: TextAlign.center,
                              size: ResponsiveFile.font14,
                              fontWeight: FontWeight.bold,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: InkWell(
                      onTap: () {},
                      child: SizedBox(
                        width: ResponsiveFile.height80,
                        height: ResponsiveFile.height120 -
                            ResponsiveFile.height20,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: ResponsiveFile.height50,
                              width: ResponsiveFile.height50,
                              child: Image.asset("images/4151701.png"),
                            ),
                            AppText(
                              text: "Image Beautifier",
                              textAlign: TextAlign.center,
                              size: ResponsiveFile.font14,
                              fontWeight: FontWeight.bold,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: InkWell(
                      onTap: () {},
                      child: SizedBox(
                        width: ResponsiveFile.height80,
                        height: ResponsiveFile.height120 -
                            ResponsiveFile.height20,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: ResponsiveFile.height50,
                              width: ResponsiveFile.height50,
                              child: Image.asset("images/4151701.png"),
                            ),
                            AppText(
                              text: "Easy EMI",
                              size: ResponsiveFile.font14,
                              fontWeight: FontWeight.bold,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: SizedBox(
                      width: ResponsiveFile.height80,
                      height: ResponsiveFile.height120 -
                          ResponsiveFile.height20,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: ResponsiveFile.height50,
                            width: ResponsiveFile.height50,
                            child: Image.asset("images/3029373.png"),
                          ),
                          AppText(
                            text: "Money Transfer",
                            textAlign: TextAlign.center,
                            size: ResponsiveFile.font14,
                            fontWeight: FontWeight.bold,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: ResponsiveFile.height15,
            ),
            Container(
              padding: EdgeInsets.only(
                left: ResponsiveFile.height10 / 2,
                right: ResponsiveFile.height10 / 2,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Flexible(
                    child: SizedBox(
                      width: ResponsiveFile.height80,
                      height: ResponsiveFile.height120 -
                          ResponsiveFile.height20,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: ResponsiveFile.height50,
                            width: ResponsiveFile.height50,
                            child: Image.asset("images/2830284.png"),
                          ),
                          AppText(
                            text: "Opening Account",
                            textAlign: TextAlign.center,
                            size: ResponsiveFile.font14,
                            fontWeight: FontWeight.bold,
                          )
                        ],
                      ),
                    ),
                  ),
                  Flexible(
                    child: SizedBox(
                      width: ResponsiveFile.height80,
                      height: ResponsiveFile.height120 -
                          ResponsiveFile.height20,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: ResponsiveFile.height50,
                            width: ResponsiveFile.height50,
                            child: Image.asset(
                                "images/18-182217_pan-card-pan-card-with-cartoon-hd-png.png"),
                          ),
                          AppText(
                            text: "Pan Card",
                            size: ResponsiveFile.font14,
                            fontWeight: FontWeight.bold,
                          )
                        ],
                      ),
                    ),
                  ),
                  Flexible(
                    child: SizedBox(
                      width: ResponsiveFile.height80,
                      height: ResponsiveFile.height120 -
                          ResponsiveFile.height20,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: ResponsiveFile.height50,
                            width: ResponsiveFile.height50,
                            child: Image.asset(
                                "images/electricity-bill-1817182-1538050.webp"),
                          ),
                          AppText(
                            text: "Electrical Recharge",
                            textAlign: TextAlign.center,
                            size: ResponsiveFile.font14,
                            fontWeight: FontWeight.bold,
                          )
                        ],
                      ),
                    ),
                  ),
                  Flexible(
                    child: SizedBox(
                      width: ResponsiveFile.height80,
                      height: ResponsiveFile.height120 -
                          ResponsiveFile.height20,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: ResponsiveFile.height50,
                            width: ResponsiveFile.height50,
                            child: Image.asset("images/recharge.png"),
                          ),
                          AppText(
                            text: "Mobile Recharge",
                            textAlign: TextAlign.center,
                            size: ResponsiveFile.font14,
                            fontWeight: FontWeight.bold,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: ResponsiveFile.height20,
            ),

          ],
        ),
      )


    );
  }
  void _awaitReturnValueFromSecondScreen(BuildContext context) async {

    // start the SecondScreen and wait for it to finish with a result
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Add_images(),
        ));

    // after the SecondScreen result comes back update the Text widget with it
    setState(() {
      images = result;
    });
    print(images);
  }

}
