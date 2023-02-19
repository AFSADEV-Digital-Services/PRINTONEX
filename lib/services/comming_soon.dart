import 'package:flutter/material.dart';
import 'package:printonex_final/consts/responsive_file.dart';
import 'package:printonex_final/consts/text_class.dart';
import 'package:printonex_final/views/pages/print/imageBeautifier.dart';

class CommingSoon extends StatefulWidget {
  const CommingSoon({Key? key}) : super(key: key);

  @override
  State<CommingSoon> createState() => _CommingSoonState();
}

class _CommingSoonState extends State<CommingSoon> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const AppText(
          text: "Comming Soon",
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

        ],
      ),
      body: Stack(
        children: [
          Container(
            child: Center(
              child: Image.asset("images/coming-soon.png"),
            ),
          ),
          Positioned(
            bottom: 50,
            right: 10,
            left: 10,
            child: Flexible(
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
                    mainAxisAlignment:
                    MainAxisAlignment.center,
                    crossAxisAlignment:
                    CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: ResponsiveFile.height50,
                        width: ResponsiveFile.height50,
                        child: Image.asset(
                            "images/4151701.png"),
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
          ),
        ],
      ),
    );
  }
}
