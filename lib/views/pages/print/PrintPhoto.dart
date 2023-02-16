import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:printonex_final/consts/responsive_file.dart';
import 'package:printonex_final/services/add_images.dart';

class PrintPhoto extends StatefulWidget {
  final List selectedimages;
  const PrintPhoto({ required this.selectedimages});

  @override
  State<PrintPhoto> createState() => _PrintPhotoState();
}

class _PrintPhotoState extends State<PrintPhoto> {
  List<String> images = [];
  var _current = 0;
  void _awaitReturnValueFromSecondScreen(BuildContext context) async {
    // start the SecondScreen and wait for it to finish with a result
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddImages(),
        ));
    // after the SecondScreen result comes back update the Text widget with it
    setState(() {
      images = result;
      for (int i = 0; i < images.length; i++) {
        images.add(images[i].toString());
      }
    });
    print(images);
  }
  @override
  void initState() {
    super.initState();


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87 ,
      appBar: AppBar(
        title: Text("PrintPhoto"),
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
            icon: const Icon(Icons.add_box_rounded),
          )
        ],
      ),
body: Container(
  color: Colors.red,
  child: Column(
    children: [
      Container(
        color: Colors.black87,
        width: ResponsiveFile.screenWidth,
        height: ResponsiveFile.screenHeight,
        child: CarouselSlider.builder(
          itemCount: images.length,
          itemBuilder: (BuildContext context, int itemIndex,
              int pageViewIndex) =>

              Container(
                child: Image.network(images[itemIndex]),
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
    ],
  ),
),
    );
  }
}
