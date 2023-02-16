import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:printonex_final/consts/responsive_file.dart';
import 'package:printonex_final/consts/text_class.dart';
import 'package:printonex_final/services/add_images.dart';
import 'package:printonex_final/views/pages/print/PrintPhoto.dart';
import 'package:printonex_final/views/pages/print/aadharPrint.dart';
import 'package:printonex_final/views/pages/print/imageBeautifier.dart';
import 'package:printonex_final/views/pages/printing_management_page.dart';
import 'package:side_menu_animation/side_menu_animation.dart';

class Print extends StatefulWidget {
  const Print({Key? key}) : super(key: key);

  @override
  State<Print> createState() => _PrintState();
}

class _PrintState extends State<Print> {
  List<String> images = [];
  List<String> selectedimages = [];

  @override
  Widget build(BuildContext context) {
    final _index = ValueNotifier<int>(1);
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const AppText(
          text: "Print Anything",
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
          if (images.isNotEmpty)
            IconButton(
              onPressed: () {
                _awaitReturnValueFromSecondScreen(context);
              },
              icon: const Icon(
                Icons.add_a_photo,
                color: Colors.black87,
              ),
            )
          else
            Container(),
        ],
      ),
      body: Column(
        children: [
          if (images.isEmpty)
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                fit: StackFit.expand,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.add_a_photo,
                      size: 80,
                      color: Colors.greenAccent,
                    ),
                    onPressed: () {
                      _awaitReturnValueFromSecondScreen(context);
                    },
                  ),
                  Positioned(
                      bottom: 50,
                      child: AppText(
                        text: "Click the Above Camera Icon\n "
                            "      select Images or Files",
                        size: ResponsiveFile.font16,
                        color: Colors.grey.withOpacity(0.6),
                        fontWeight: FontWeight.bold,
                      ))
                ],
              ),
            )
          else
            Expanded(
                child: Container(
              height: 10,
              color: Colors.white10,
              child: GridView.builder(
                itemCount: images.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                scrollDirection: Axis.vertical,
                itemBuilder: (ctx, i) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (selectedimages.contains(images[i].toString())) {
                          selectedimages.remove(images[i].toString());
                        } else {
                          selectedimages.add(images[i].toString());
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
                                  image: NetworkImage(images[i]),
                                  fit: BoxFit.cover)),
                        ),
                        Padding(
                          padding: EdgeInsets.all(ResponsiveFile.height10 / 2),
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: selectedimages.contains(images[i].toString())
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
            )),

            Column(
              children: [
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
                          onTap: () {
                            selectedimages.isEmpty
                                ? Get.snackbar(
                                    'Error', 'Select Image From List',
                                    backgroundColor: Colors.red)
                                : Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PrintCustomizer(
                                        selectedImages: [selectedimages],
                                      ),
                                    ));
                          },
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
                                  child: Image.asset("images/photo_print.png"),
                                ),
                                AppText(
                                  text: "Photo Printting",
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
                                  child: Image.asset("images/doc_print.png"),
                                ),
                                AppText(
                                  text: "Document Printing",
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
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AadharPrint(),
                                ));
                          },
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
                                  child: Image.asset("images/aadhar_print.png"),
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
                                  child: Image.asset("images/doc_scanner.png"),
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
                                  child:
                                      Image.asset("images/PDF_file_icon.png"),
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
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ImageBeautifier(),
                                ));
                          },
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
                                  child:
                                      Image.asset("images/PDF_file_icon.png"),
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
                    ],
                  ),
                ),
              ],
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
      for (int i = 0; i < images.length; i++) {
        selectedimages.add(images[i].toString());
      }
    });
  }
}
