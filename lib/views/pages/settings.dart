import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:image_picker/image_picker.dart';
import 'package:printonex_final/consts/responsive_file.dart';
import 'package:printonex_final/consts/reusable_widget.dart';
import 'package:printonex_final/consts/text_class.dart';
import 'package:printonex_final/consts/filepicker.dart';
import 'package:printonex_final/consts/errormsg.dart';
import 'package:printonex_final/views/auth_pages/login.dart';
import 'package:printonex_final/views/widgets/errorWidget.dart';
class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {





  void share() {
    FlutterShare.share(
        title: 'PRINTONEX',
        text: 'Share & Earn Reward',
        linkUrl: 'https://afsadev.in/printonex/',
        chooserTitle: 'PRINTONEX');
  }




  @override
  void initState() {
    super.initState();

  }
  bool _isSigningOut = false;
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      bottomNavigationBar: Container(
        margin: EdgeInsets.symmetric(
          horizontal: ResponsiveFile.height20,
            vertical: ResponsiveFile.height20),
        child: Stack(
          children: [
            InkWell(
              onTap: () async {
                setState(() {
                  _isSigningOut = true;
                });
                await FirebaseAuth.instance.signOut();
                setState(() {
                  _isSigningOut = false;
                });
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => LoginPage(),
                  ),
                );
              },
              child:  _isSigningOut
                  ? CircularProgressIndicator():Positioned(
                left: ResponsiveFile.height220,
                bottom: ResponsiveFile.height8,
                child: Container(
                  padding: EdgeInsets.only(left:ResponsiveFile.height20,
                      top: ResponsiveFile.height8,
                      right: ResponsiveFile.height15,
                      bottom: ResponsiveFile.height8),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            blurRadius: 5
                        )
                      ],
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(ResponsiveFile.radius50),
                        bottomRight: Radius.circular(ResponsiveFile.height50),),
                  ),
                  child: AppText(text: " logout", size: ResponsiveFile.font19,),
                ),
              ),
            ),

            InkWell(
              onTap: () async{
                setState(() {
                  _isSigningOut = true;
                });
                await FirebaseAuth.instance.signOut();
                setState(() {
                  _isSigningOut = false;
                });
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => LoginPage(),
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.all(ResponsiveFile.height20),
                decoration: const BoxDecoration(
                  color: Colors.deepOrange,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.logout, size: ResponsiveFile.height20,),
              ),
            ),
          ],
        ),
      ),
        backgroundColor: Colors.white,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              title: AppText(text: "Hi.. ${user!.displayName.toString()}", size: 16,),

              pinned: true,
              backgroundColor: Colors.orange,
              elevation: 0,
              expandedHeight:
                  ResponsiveFile.height220 + ResponsiveFile.height50,
              flexibleSpace: Stack(
                children: [
                  ReusableWidget(
                    top: -ResponsiveFile.height50,
                    left: -ResponsiveFile.height50,
                    height: ResponsiveFile.height200,
                    width: ResponsiveFile.height200,
                    color: Colors.white,
                  ),
                  ReusableWidget(
                    top: -ResponsiveFile.height30,
                    left: -ResponsiveFile.height30,
                    height: ResponsiveFile.height150,
                    width: ResponsiveFile.height150,
                    color: Colors.red,
                  ),
                  ReusableWidget(
                    top: -ResponsiveFile.height200 / 1.5,
                    right: -ResponsiveFile.height200 / 1.5,
                    height: ResponsiveFile.height200,
                    width: ResponsiveFile.height200,
                    color: Colors.white,
                  ),
                  ReusableWidget(
                    bottom: ResponsiveFile.height20,
                    right: ResponsiveFile.height20,
                    height: ResponsiveFile.height80,
                    width: ResponsiveFile.height80,
                    color: Colors.white,
                  ),
                  ReusableWidget(
                    bottom: ResponsiveFile.height50,
                    right: ResponsiveFile.height50,
                    height: ResponsiveFile.height50,
                    width: ResponsiveFile.height50,
                    color: Colors.white,
                  ),
                  Container(
                    alignment: Alignment.center,
                    height: ResponsiveFile.height220 + ResponsiveFile.height50,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 5, color: Colors.black.withOpacity(0.4))
                      ],
                      color: Colors.deepOrange.withOpacity(0.8),
                    ),
                    child: Stack(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          radius:
                              ResponsiveFile.height50 + ResponsiveFile.height10,
                          child: user.photoURL!=null
                              ? Padding(
                                  padding:
                                      EdgeInsets.all(ResponsiveFile.height10),
                                  child: Image.asset("images/logo.png"),
                                )
                              : Image.asset("images/logo.png"),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            height: ResponsiveFile.height30 +
                                ResponsiveFile.height10,
                            width: ResponsiveFile.height30 +
                                ResponsiveFile.height10,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            child: Container(
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.white),
                              child: IconButton(
                                icon: Icon(
                                  Icons.camera_alt_outlined,
                                  size: ResponsiveFile.height20,
                                ),
                                onPressed: () async{
                                  final path= await Upload.pickfile();
                                  Error.ErrorMsg(msg: path.toString());

                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[

                    ListTile(
                      title: AppText(text: 'Account settings',size: ResponsiveFile.radius17,),
                    ),
                    Divider(
                      height: ResponsiveFile.height20,
                      color: Colors.grey.withOpacity(0.3),
                    ),
                    ListTile(
                      leading: Icon(Icons.location_on_outlined,
                        color: Colors.red,
                        size: ResponsiveFile.height20,),
                      title: AppText(text: 'Address',size: ResponsiveFile.radius17,),
                      trailing: Icon(Icons.add),
                    ),
                    Divider(
                      height: ResponsiveFile.height20,
                      color: Colors.grey.withOpacity(0.3),
                    ),
                    ListTile(
                      leading: Icon(Icons.account_balance_rounded,
                        color: Colors.blueAccent,
                        size: ResponsiveFile.height20,),
                      title: AppText(text: 'Bank',size: ResponsiveFile.radius17,),
                      trailing: Icon(Icons.add),
                    ),
                    Divider(
                      height: ResponsiveFile.height20,
                      color: Colors.grey.withOpacity(0.3),
                    ),
                    ListTile(
                      leading: Icon(Icons.share_rounded,
                        color: Colors.green,
                        size: ResponsiveFile.height20,),
                      title: AppText(text: 'Share',size: ResponsiveFile.radius17,),
                    ),
                    Divider(
                      height: ResponsiveFile.height20,
                      color: Colors.grey.withOpacity(0.3),
                    ),
                    ListTile(
                      leading: Icon(Icons.location_on_outlined, size: ResponsiveFile.height20,),
                      title: AppText(text: user.email.toString(),size: ResponsiveFile.radius17,),
                      trailing: user.emailVerified?
                      AppText(text: "Email Verified", color: Colors.green,):
                      InkWell(
                        onTap: () async {
                          await user.sendEmailVerification();
                        },
                          child: AppText(text: "Verify Email", color: Colors.red,)),
                    ),

                  ],
                ),
              ),
            )
          ],
        ));
  }
}

