import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';
import 'package:pinch_zoom/pinch_zoom.dart';
import 'package:printonex_final/consts/firebase/size_constants.dart';
import 'package:printonex_final/consts/text_class.dart';
import 'dart:math' as math;
import '../../consts/responsive_file.dart';
import '../../models/chat_messages.dart';

Widget errorContainer() {
  return Container(
    clipBehavior: Clip.hardEdge,
    child: Image.asset(
      'assets/images/img_not_available.jpeg',
      height: Sizes.dimen_200,
      width: Sizes.dimen_200,
    ),
  );
}

// ignore: non_constant_identifier_names
Widget ZoomPhoto(String url) {
  return Builder(builder: (context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
            splashRadius: ResponsiveFile.height15,
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            )),
      ),
      body: Hero(
        tag: "imageSrc",
        child: PinchZoom(
          zoomEnabled: true,
          maxScale: 5.5,
          child: CachedNetworkImage(
            width: ResponsiveFile.screenWidth,
            height: ResponsiveFile.screenHeight,
            imageUrl: url,
            errorWidget: (context, url, error) =>const Icon(Icons.zoom_out_map_outlined)
          ),
        ),
      ),
    );
  });
}

Widget chatImage({
  required String imageSrc,
  required Function onTap,
  required String dateText,
}) {
  return Builder(builder: (context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('h:mm a').format(now);

    return GestureDetector(
      onTap: () {
        showDialog(
            context: (context),
            builder: (BuildContext context) {
              return ZoomPhoto(imageSrc);
            });
      },
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(ResponsiveFile.height10 / 4),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.greenAccent),
                borderRadius:
                    BorderRadius.all(Radius.circular(ResponsiveFile.height10))),
            child: Hero(
              tag: "imageSrc",
              child: ClipRRect(
                borderRadius: BorderRadius.circular(ResponsiveFile.height10),
                child: CachedNetworkImage(
                  imageUrl: imageSrc,
                  width: Sizes.dimen_200,
                  height: Sizes.dimen_250,
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) =>
                      const Icon(Icons.image_search_rounded),
                ),
              ),
            ),
          ),
          Positioned(
              bottom: 5,
              right: 0.1,
              child: Container(
                padding: EdgeInsets.all(ResponsiveFile.height10 / 6),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(ResponsiveFile.height10 / 2)),
                child: AppText(
                  text: dateText,
                  size: ResponsiveFile.height10 / 1.2,
                ),
              ))
        ],
      ),
    );
  });
}

class CustomShape extends CustomPainter {
  final Color bgColor;

  CustomShape(this.bgColor);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()..color = bgColor;

    var path = Path();
    path.lineTo(-5, 0);
    path.lineTo(0, 10);
    path.lineTo(5, 0);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

Widget messageBubbleSender(
    {required String timeText,
    required String chatContent,
    required EdgeInsetsGeometry? margin,
    Color? color,
    Color? textColor}) {
  return Builder(
    builder: (context) {
      return Flexible(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: Container(
                margin: EdgeInsets.only(top: ResponsiveFile.height10),
                padding: EdgeInsets.all(ResponsiveFile.height10),
                decoration: BoxDecoration(
                  color: Colors.greenAccent,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(ResponsiveFile.radius17),
                    bottomLeft: Radius.circular(ResponsiveFile.radius17),
                    bottomRight: Radius.circular(ResponsiveFile.radius17),
                  ),
                ),
                child: RichText(
                  text: TextSpan(
                    text: chatContent,
                    style: DefaultTextStyle.of(context).style.merge(TextStyle(fontSize: ResponsiveFile.font16)),
                    children: <TextSpan>[
                      TextSpan(text: '  ' + timeText,
                        style: Theme.of(context).textTheme.caption?.merge(
                            TextStyle(
                              fontSize: ResponsiveFile.font20/2,
                            )
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
                margin: EdgeInsets.only(top: ResponsiveFile.height10, right: 5),
                child: CustomPaint(painter: CustomShape(Colors.greenAccent))),
          ],
        ),
      );
    }
  );
}

Widget messageBubbleRecever(
    {required String timeText,
    required String chatContent,
    required EdgeInsetsGeometry? margin,
    Color? color,
    Color? textColor}) {
  return Builder(
    builder: (context) {
      return Flexible(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(math.pi),
              child: Container(
                margin: EdgeInsets.only(top: ResponsiveFile.height10, right: ResponsiveFile.height10),
                child: CustomPaint(
                  painter: CustomShape(Colors.blueAccent),
                ),
              ),
            ),
            Flexible(
              child: Container(
                margin: EdgeInsets.only(top: ResponsiveFile.height10),
                padding: EdgeInsets.all(ResponsiveFile.height10),
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(ResponsiveFile.radius17),
                    bottomLeft: Radius.circular(ResponsiveFile.radius17),
                    bottomRight: Radius.circular(ResponsiveFile.radius17),
                  ),
                ),
                child: RichText(
                  text: TextSpan(
                    text: chatContent,
                    style: DefaultTextStyle.of(context).style.merge(TextStyle(fontSize: ResponsiveFile.font16)),
                    children: <TextSpan>[
                      TextSpan(text: '  ' + timeText,
                        style: Theme.of(context).textTheme.caption?.merge(
                            TextStyle(
                              fontSize: ResponsiveFile.font20/2,
                            )
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
  );
  // return Container(
  //   margin: const EdgeInsets.only(left: Sizes.dimen_8, top: Sizes.dimen_8, right: Sizes.dimen_8),
  //   decoration: BoxDecoration(
  //     color: Colors.greenAccent,
  //     border: Border.all(
  //         color: Colors.greenAccent),
  //     borderRadius: BorderRadius.circular(Sizes.dimen_10),
  //   ),
  //   child: Flexible(
  //     child: Row(
  //       children: [
  //         Container(
  //
  //           margin: margin,
  //           padding: const EdgeInsets.all(10),
  //           child: Text(
  //             chatContent,
  //             style: TextStyle(fontSize: Sizes.dimen_16, color: textColor),
  //           ),
  //         ),
  //         SizedBox(width: ResponsiveFile.height10,),
  //         Container(
  //           alignment: Alignment.bottomRight,
  //           margin: const EdgeInsets.only(right: 0.1),
  //           padding: const EdgeInsets.all(1),
  //           decoration: BoxDecoration(
  //               color: Colors.white,
  //               borderRadius:
  //               BorderRadius.circular(ResponsiveFile.height10 / 2)),
  //           child: AppText(
  //             textAlign: TextAlign.right,
  //             text: timeText,
  //             size: ResponsiveFile.height10/1.2,
  //           ),
  //
  //         ),
  //         Container( margin: EdgeInsets.only(top:10, left:20),child: CustomPaint(painter: CustomShape(Colors.greenAccent))),
  //       ],
  //     ),
  //   ),
  // );
}
