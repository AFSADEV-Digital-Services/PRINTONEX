import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:printonex_final/consts/responsive_file.dart';
import 'package:printonex_final/consts/text_class.dart';
import 'package:printonex_final/views/auth_pages/login.dart';
import 'package:printonex_final/views/auth_pages/registration.dart';
import 'package:printonex_final/views/pages/settings.dart';
import 'package:printonex_final/consts/launch_url.dart';
import 'package:http/http.dart' as http;
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final ScrollController _scrollController = ScrollController();
  final CarouselController _controller = CarouselController();
  late User _currentUser;
  bool isLoading = false;

  List<dynamic> _banner = [];
  List<dynamic> _blog = [];
  var _current = 0;
  checklogin() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });
  }

  banner() async {
    QuerySnapshot bannersRef =
        await FirebaseFirestore.instance.collection('banners').get();
    setState(() {
      for (int i = 0; i < bannersRef.docs.length; i++) {
        _banner.add(
          bannersRef.docs[i]["imgurl"],
        );
      }
    });
    return bannersRef.docs;
  }

  Future<void> fetchWpPosts() async {
    final response = await http.get(
        Uri.parse("https://afsadev.in/wp-json/wp/v2/posts"),
        headers: {"Accept": "application/json"});
    var convertDataJson = jsonDecode(response.body);
    setState(() {
      _blog = convertDataJson;
    });
  }

  _launchURLApp(String url) async {
    setState(() {
      isLoading=true;
    });
    Future.delayed(const Duration(seconds: 3), () {
      setState(() async {
        isLoading = false;
        await canLaunch(url)
            ? await launch(url,
            forceSafariVC: true, forceWebView: true, enableJavaScript: true)
            : const Center(child: CircularProgressIndicator());

      });
    }
    );
    }

  @override
  void initState() {
    _currentUser = FirebaseAuth.instance.currentUser!;
    banner();
    fetchWpPosts();
    super.initState();
  }

  @override
  void dispose() {
    _controller;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final firebaseAuth = FirebaseAuth.instance;
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const Profile())),
            child: CircleAvatar(
              backgroundColor: Colors.greenAccent,
              backgroundImage:
              firebaseAuth.currentUser!.photoURL == null
                  ? const NetworkImage(
                      "https://firebasestorage.googleapis.com/v0/b/printonex-eeff2.appspot.com/o/icons%2Flogo.png?alt=media&token=eddbcced-ade9-418c-8d4d-cd0738c1a550")
                  : NetworkImage(
                      firebaseAuth.currentUser!.photoURL!,
                    ),

            ),
          ),
        ),
        title: _currentUser.uid != null
            ? FlatButton(
                onPressed: () {
                  // method to show the search bar
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => Profile()));
                },
                child: Text(
                    _currentUser.displayName != null
                        ? _currentUser.displayName.toString()
                        : _currentUser.email.toString(),
                    style: TextStyle(fontSize: ResponsiveFile.font16)),
              )
            : FlatButton(
                onPressed: () {
                  // method to show the search bar
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => RegisterPage()));
                },
                child: const Text("Login/SignUp here"),
              ),
        shape:
        RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(ResponsiveFile.radius17),
          ),
        ),
        backgroundColor: Colors.greenAccent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              // method to show the search bar
            },
            icon: const Icon(Icons.search),
          )
        ],
      ),
      body: _banner.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: SizedBox(
                        child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CarouselSlider.builder(
                          carouselController: _controller,
                          itemCount: _banner.length,
                          itemBuilder: (BuildContext context, int itemIndex,
                                  int pageViewIndex) =>
                              Container(
                            decoration: BoxDecoration(
                              color: Colors.white54,
                              borderRadius: BorderRadius.circular(
                                  ResponsiveFile.radius20 / 1.19),
                            ),
                            margin: EdgeInsets.only(
                                left: ResponsiveFile.height10,
                                right: ResponsiveFile.height10),
                            width: ResponsiveFile.screenWidth,
                            height: ResponsiveFile.height220 -
                                ResponsiveFile.height50,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  ResponsiveFile.radius20 / 1.19),
                              child: CachedNetworkImage(
                                imageUrl: _banner[itemIndex],
                                fit: BoxFit.fill,
                                errorWidget: (context, url, error) =>
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.error_outline_outlined, size: 50,color: Colors.red,),
                                       SizedBox(height: ResponsiveFile.height10,),
                                        AppText(text: "Cannot load banner".toUpperCase(),
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold,
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                              ),
                            ),
                          ),
                          options: CarouselOptions(
                              autoPlay: true,
                              padEnds: true,
                              disableCenter: true,
                              enlargeCenterPage: false,
                              viewportFraction: 1,
                              aspectRatio: 2,
                              initialPage: 2,
                              autoPlayInterval: const Duration(seconds: 5),
                              autoPlayAnimationDuration:
                                  const Duration(milliseconds: 800),
                              autoPlayCurve: Curves.easeInOut,
                              scrollDirection: Axis.horizontal,
                              onPageChanged: (index, reason) {
                                setState(() {
                                  _current = index;
                                });
                              }),
                        ),
                        Positioned(
                          top: ResponsiveFile.height10,
                          right: ResponsiveFile.height20,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: _banner.asMap().entries.map((entry) {
                              return GestureDetector(
                                onTap: () =>
                                    _controller.animateToPage(entry.key),
                                child: Container(
                                  width: 7.0,
                                  height: 7.0,
                                  margin: EdgeInsets.only(
                                      right: ResponsiveFile.height10),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: (Theme.of(context).brightness ==
                                                  Brightness.dark
                                              ? Colors.greenAccent
                                              : Colors.black)
                                          .withOpacity(_current == entry.key
                                              ? 1
                                              : 0.4)),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),),
                  ),
                  Container(
                    width: ResponsiveFile.screenWidth,
                    margin: EdgeInsets.all(ResponsiveFile.height10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                            ResponsiveFile.height20 / 1.23),
                        border:
                            Border.all(color: Colors.grey.withOpacity(0.3))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.only(
                              left: ResponsiveFile.height20,
                              right: ResponsiveFile.height20,
                              top: ResponsiveFile.height10),
                          child: AppText(
                            text: "Fast Go Services",
                            size: ResponsiveFile.font19,
                            fontWeight: FontWeight.bold,
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: ResponsiveFile.height50,
                                        width: ResponsiveFile.height50,
                                        child:
                                            Image.asset("images/2830284.png"),
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: ResponsiveFile.height50,
                                        width: ResponsiveFile.height50,
                                        child: Image.asset(
                                            "images/recharge.png"),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: ResponsiveFile.height50,
                                          width: ResponsiveFile.height50,
                                          child: Image.asset(
                                              "images/PDF_file_icon.png"),
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
                              Flexible(
                                child: InkWell(
                                  onTap: () => web.launchURLApp(
                                      'https://apply.hdfcbank.com/digital/consumerdurables?BranchCode=4744&LGCode=175111650010&LCCode=CSCVLE&channelsource=CSC#CD-Login'),
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: ResponsiveFile.height50,
                                        width: ResponsiveFile.height50,
                                        child:
                                            Image.asset("images/3029373.png"),
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
                          height: ResponsiveFile.height20,
                        )
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: ResponsiveFile.height15,
                              vertical: ResponsiveFile.height10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AutoSizeText(
                                "Product/Services",
                                style: TextStyle(
                                    fontSize: ResponsiveFile.font16,
                                    color: Colors.black),
                              ),
                              AutoSizeText(
                                "More...",
                                style: TextStyle(
                                    fontSize: ResponsiveFile.font16,
                                    color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (_blog.isEmpty)
                    const CircularProgressIndicator()
                  else
                    ListView.builder(
                      padding: EdgeInsets.symmetric(
                          vertical: 0, horizontal: ResponsiveFile.height10),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _blog.length,
                      itemBuilder: (BuildContext context, int index) {
                        Map webPost = _blog[index];
                        return InkWell(
                          borderRadius: BorderRadius.circular(
                              ResponsiveFile.height10 / 4),

                          onTap: () {
                            _launchURLApp(webPost['link']);

                          } ,
                          child: Container(
                            margin: EdgeInsets.only(
                                bottom: ResponsiveFile.height10 / 2),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    ResponsiveFile.height10 / 2),
                                border: Border.all(
                                    color: Colors.grey.withOpacity(0.2))),
                            child: Row(
                              children: [
                                Expanded(
                                    flex: 2,
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: Container(
                                        height: 160,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(
                                                    ResponsiveFile.height10 /
                                                        4),
                                                bottomLeft: Radius.circular(
                                                    ResponsiveFile.height10 /
                                                        4)),
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                    webPost['yoast_head_json']
                                                            ['og_image'][0]
                                                        ['url']),
                                                fit: BoxFit.fitHeight)),
                                      ),
                                    )),
                                Expanded(
                                    flex: 3,
                                    child: Container(
                                      padding:
                                          EdgeInsets.fromLTRB(0, 5, 5, 5),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            webPost['title']['rendered'],
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            webPost['date'],
                                            style: TextStyle(
                                                color: Colors.black
                                                    .withOpacity(0.6)),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            webPost['yoast_head_json']
                                                ['description'],
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15),
                                            maxLines: 3,
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              GradientText(
                                                "See More",
                                                style: TextStyle(
                                                    color: Colors.black
                                                        .withOpacity(0.8),
                                                    fontWeight:
                                                        FontWeight.bold),
                                                colors: [
                                                  Color(0xffFF416C),
                                                  Color(0xffFF4B2B),
                                                ],
                                              ),
                                              Icon(
                                                Icons.arrow_forward_outlined,
                                                size: 18,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ))
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
    );
  }
}
