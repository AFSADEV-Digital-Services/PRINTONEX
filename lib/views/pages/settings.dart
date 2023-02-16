import 'dart:async';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_number/mobile_number.dart';
import 'package:printonex_final/Providers/auth_provider.dart';
import 'package:printonex_final/Providers/profile_provider.dart';
import 'package:printonex_final/consts/firebase/color_constants.dart';
import 'package:printonex_final/consts/firebase/firestore_constants.dart';
import 'package:printonex_final/consts/responsive_file.dart';
import 'package:printonex_final/consts/reusable_widget.dart';
import 'package:printonex_final/consts/text_class.dart';
import 'package:printonex_final/models/chat_user.dart';
import 'package:printonex_final/views/auth_pages/login.dart';
import 'package:printonex_final/views/widgets/loading_view.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late AuthProvider authProvider;
  late String currentUserId;
  TextEditingController? displayNameController;
  TextEditingController? aboutMeController;
  final TextEditingController _phoneController = TextEditingController();
  String dialCodeDigits = '+00';
  String id = '';
  String displayName = '';
  String photoUrl = '';
  String phoneNumber = '';
  String aboutMe = '';
  String _mobileNumber = '';
  List<SimCard> _simCard = <SimCard>[];
  late Position _currentPosition;
  String _currentAddress= '';
  bool isLoading = false;
  File? avatarImageFile;
  late ProfileProvider profileProvider;
  final FocusNode focusNodeNickname = FocusNode();

  @override
  void initState() {
    super.initState();
    profileProvider = context.read<ProfileProvider>();
    readLocal();
    authProvider = context.read<AuthProvider>();
    if (authProvider.getFirebaseUserId()?.isNotEmpty == true) {
      currentUserId = authProvider.getFirebaseUserId()!;
    } else {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginPage()),
              (Route<dynamic> route) => false);
    }
    MobileNumber.listenPhonePermission((isPermissionGranted) {
      if (isPermissionGranted) {
        initMobileNumberState();
      } else {}
    });

    initMobileNumberState();
  }

  Future<void> SignOut() async {
    authProvider.SignOut();
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

  void share() {
    FlutterShare.share(
        title: 'PRINTONEX APP',
        text: 'Download Our Online App for any Services👇',
        linkUrl: 'https://afsadev.in/Download/PrintoNexOnline.apk',
        chooserTitle: 'PRINTONEX');
  }

  void readLocal() {
    setState(() {
      id = profileProvider.getPrefs(FirestoreConstants.id) ?? "";
      displayName =
          profileProvider.getPrefs(FirestoreConstants.displayName) ?? "";

      photoUrl = profileProvider.getPrefs(FirestoreConstants.photoUrl) ?? "";
      phoneNumber =
          profileProvider.getPrefs(FirestoreConstants.phoneNumber) ?? "";
      aboutMe = profileProvider.getPrefs(FirestoreConstants.aboutMe) ?? "";
    });
    displayNameController = TextEditingController(text: displayName);
    aboutMeController = TextEditingController(text: aboutMe);
  }

  Future getImage() async {
    ImagePicker imagePicker = ImagePicker();
    // PickedFile is not supported
    // Now use XFile?
    XFile? pickedFile = await imagePicker
        .pickImage(source: ImageSource.gallery)
        .catchError((onError) {
      Fluttertoast.showToast(msg: onError.toString());
    });
    File? image;
    if (pickedFile != null) {
      image = File(pickedFile.path);
    }
    if (image != null) {
      setState(() {
        avatarImageFile = image;
        isLoading = true;
      });
      uploadFile();
    }
  }

  Future uploadFile() async {
    isLoading = true;
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    UploadTask uploadTask =
    profileProvider.uploadImageFile(avatarImageFile!, fileName, id);
    try {
      TaskSnapshot snapshot = await uploadTask;
      photoUrl = await snapshot.ref.getDownloadURL();
      profileProvider.updateFireAuthen(photoUrl).then((value) async {
        Get.snackbar('Success', 'Profile has been changed successfully',
            backgroundColor: Colors.greenAccent);
        await profileProvider.setPrefs(FirestoreConstants.photoUrl, photoUrl);
        setState(() {
          isLoading = false;
        });
        //DO Other compilation here if you want to like setting the state of the app
      }).catchError((e) {
        Get.snackbar('Failed', 'Failed has been Occur' + e.toString(),
            backgroundColor: Colors.redAccent);
      });
      // PrintonexUsers updateInfo = PrintonexUsers(
      //     id: id,
      //     photoUrl: photoUrl,
      //     displayName: displayName,
      //     phoneNumber: phoneNumber,
      //     aboutMe: aboutMe);
      // profileProvider
      //     .updateFirestoreData(
      //         FirestoreConstants.pathUserCollection, id, updateInfo.toJson())
      //     .then((value) async {
      //   await profileProvider.setPrefs(FirestoreConstants.photoUrl, photoUrl);
      //   setState(() {
      //     isLoading = false;
      //   });
      // });
    } on FirebaseException catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  void updateFirestoreData() {
    focusNodeNickname.unfocus();
    setState(() {
      isLoading = true;
      if (dialCodeDigits != "+00" && _phoneController.text != "") {
        phoneNumber = dialCodeDigits + _phoneController.text.toString();
      }
    });
    PrintonexUsers updateInfo = PrintonexUsers(
        id: id,
        photoUrl: photoUrl,
        displayName: displayName,
        phoneNumber: phoneNumber,
        aboutMe: aboutMe);
    profileProvider
        .updateFirestoreData(
        FirestoreConstants.pathUserCollection, id, updateInfo.toJson())
        .then((value) async {
      await profileProvider.setPrefs(
          FirestoreConstants.displayName, displayName);
      await profileProvider.setPrefs(
          FirestoreConstants.phoneNumber, phoneNumber);
      await profileProvider.setPrefs(
        FirestoreConstants.photoUrl,
        photoUrl,
      );
      await profileProvider.setPrefs(FirestoreConstants.aboutMe, aboutMe);

      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: 'UpdateSuccess');
    }).catchError((onError) {
      Fluttertoast.showToast(msg: onError.toString());
    });
  }

  getLocation() async {
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );
    StreamSubscription<Position> positionStream =
    Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position? position) {
      if (kDebugMode) {
        print(position == null
            ? 'Unknown'
            : '${position.latitude.toString()}, ${position.longitude.toString()}');
      }
    });

  }

  Future<void> initMobileNumberState() async {
    if (!await MobileNumber.hasPhonePermission) {
      await MobileNumber.requestPhonePermission;
      return;
    }
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      _mobileNumber = (await MobileNumber.mobileNumber)!;
      _simCard = (await MobileNumber.getSimCards)!;
    } on PlatformException catch (e) {
      debugPrint("Failed to get mobile number because of '${e.message}'");
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {});
  }

  Widget fillCards() {
    List<Widget> widgets = _simCard
        .map((SimCard sim) => Text(

        ' ${sim.number}'



    ))
        .toList();
    print(widgets.toString());
    return Column(children: widgets);

  }
  _getCurrentLocation() {
    Geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best, forceAndroidLocationManager: true)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
        _getAddressFromLatLng();
      });
    }).catchError((e) {
      print(e);
    });
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          _currentPosition.latitude,
          _currentPosition.longitude
      );

      Placemark place = placemarks[0];

      setState(() {
        _currentAddress = "${place.locality}, ${place.postalCode}, ${place.country}";
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    return Scaffold(
        backgroundColor: Colors.white,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              leading: IconButton(
                splashRadius: ResponsiveFile.height20,
                icon: const Icon(
                  Icons.arrow_back,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: AppText(
                text:
                "Hi.. ${user!.displayName == null ? user.email.toString() : user.displayName.toString()}",
                size: 16,
              ),
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
                    height: ResponsiveFile.height300+ ResponsiveFile.height30,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 5, color: Colors.black.withOpacity(0.4))
                      ],
                      color: Colors.deepOrange.withOpacity(0.4),
                    ),
                    child: Stack(
                      children: [
                        GestureDetector(
                          onTap: getImage,
                          child: Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.all(10),
                            child: avatarImageFile == null
                                ? photoUrl.isNotEmpty
                                ? ClipRRect(
                              borderRadius:
                              BorderRadius.circular(300),
                              child: CachedNetworkImage(
                                imageUrl: photoUrl,
                                fit: BoxFit.contain,
                                width: 120,
                                height: 120,
                                errorWidget: (context, url, error) =>
                                const Icon(
                                  Icons.account_circle,
                                  color: Colors.white,
                                  size: 120,
                                ),
                              ),
                            )
                                : const Icon(
                              Icons.account_circle,
                              size: 120,
                              color: AppColors.greyColor,
                            )
                                : ClipRRect(
                              borderRadius: BorderRadius.circular(300),
                              child: Image.file(
                                avatarImageFile!,
                                width: 120,
                                height: 120,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                            child: isLoading
                                ? const LoadingView()
                                : const SizedBox.shrink()),
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
                    InkWell(
                      onTap: () {
                        fillCards();
                        showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                actionsAlignment: MainAxisAlignment.center,
                                scrollable: true,
                                titlePadding: EdgeInsets.only(
                                  left: ResponsiveFile.height20,
                                ),
                                title: Stack(
                                  children: [
                                    Container(
                                        margin: EdgeInsets.only(
                                            top: ResponsiveFile.height15),
                                        child: const Text(
                                            'Update Profile Detail')),
                                    Positioned(
                                        top: -7,
                                        right: -4,
                                        child: IconButton(
                                          splashRadius: 12,
                                          splashColor: Colors.red,
                                          icon: const Icon(
                                            Icons.remove,
                                            color: Colors.red,
                                          ),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        )),
                                    if (_currentAddress != null) Text(
                                        _currentAddress
                                    ),
                                    FlatButton(
                                      child: Text("Get location"),
                                      onPressed: () {
                                        _getCurrentLocation();
                                      },
                                    ),
                                  ],
                                ),
                                content: Form(
                                  child: Column(
                                    children: <Widget>[
                                      TextFormField(
                                        decoration: const InputDecoration(
                                          labelText: 'Name',
                                          icon: Icon(Icons.location_history),
                                        ),
                                      ),
                                      TextFormField(
                                        decoration: InputDecoration(
                                          labelText: _mobileNumber.toString(),
                                          icon: const Icon(
                                              Icons.location_history),
                                        ),
                                      ),
                                      TextFormField(
                                        decoration: const InputDecoration(
                                          labelText: "_currentAddress.toString()",
                                          icon: Icon(Icons.location_history),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                actions: [
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        elevation: 10,
                                        primary: Colors
                                            .black, // background (button) color
                                        onPrimary: Colors
                                            .white, // foreground (text) color
                                      ),
                                      child: const Text("Submit"),
                                      onPressed: () {
                                        // your code
                                      })
                                ],
                              );
                            });
                      },
                      child: ListTile(
                        leading: Icon(
                          Icons.account_circle_outlined,
                          color: Colors.greenAccent,
                          size: ResponsiveFile.height20,
                        ),
                        title: AppText(
                          text: 'Profile Details',
                          size: ResponsiveFile.radius17,
                        ),
                        trailing: Icon(Icons.edit),
                      ),
                    ),
                    Divider(
                      height: ResponsiveFile.height20,
                      color: Colors.grey.withOpacity(0.3),
                    ),
                    InkWell(
                      onTap: () {
                        getLocation();
                        showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                actionsAlignment: MainAxisAlignment.center,
                                scrollable: true,
                                titlePadding: EdgeInsets.only(
                                  left: ResponsiveFile.height20,
                                ),
                                title: Stack(
                                  children: [
                                    Container(
                                        margin: EdgeInsets.only(
                                            top: ResponsiveFile.height15),
                                        child: const Text('Add Your location')),
                                    Positioned(
                                        top: -7,
                                        right: -4,
                                        child: IconButton(
                                          splashRadius: 12,
                                          splashColor: Colors.red,
                                          icon: const Icon(
                                            Icons.remove,
                                            color: Colors.red,
                                          ),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ))
                                  ],
                                ),
                                content: Form(
                                  child: Column(
                                    children: <Widget>[
                                      TextFormField(
                                        decoration: const InputDecoration(
                                          labelText: 'Full Address',
                                          icon: Icon(Icons.location_history),
                                        ),
                                      ),
                                      TextFormField(
                                        decoration: const InputDecoration(
                                          labelText: 'GPS location',
                                          icon:
                                          Icon(Icons.location_on_outlined),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                actions: [
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        elevation: 10,
                                        primary: Colors
                                            .black, // background (button) color
                                        onPrimary: Colors
                                            .white, // foreground (text) color
                                      ),
                                      child: const Text("Submit"),
                                      onPressed: () {
                                        // your code
                                      }),
                                ],
                              );
                            });
                      },
                      child: ListTile(
                        leading: Icon(
                          Icons.location_on_outlined,
                          color: Colors.red,
                          size: ResponsiveFile.height20,
                        ),
                        title: AppText(
                          text: 'Address',
                          size: ResponsiveFile.radius17,
                        ),
                        trailing: Icon(Icons.add),
                      ),
                    ),
                    Divider(
                      height: ResponsiveFile.height20,
                      color: Colors.grey.withOpacity(0.3),
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.account_balance_rounded,
                        color: Colors.blueAccent,
                        size: ResponsiveFile.height20,
                      ),
                      title: AppText(
                        text: 'Bank',
                        size: ResponsiveFile.radius17,
                      ),
                      trailing: Icon(Icons.add),
                    ),
                    Divider(
                      height: ResponsiveFile.height20,
                      color: Colors.grey.withOpacity(0.3),
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.verified_user_outlined,
                        size: ResponsiveFile.height20,
                        color: user.emailVerified ? Colors.green : Colors.red,
                      ),
                      title: AppText(
                        text: user.email.toString(),
                        size: ResponsiveFile.radius17,
                      ),
                      trailing: user.emailVerified
                          ? AppText(
                        text: "Email Verified",
                        color: Colors.green,
                      )
                          : InkWell(
                          onTap: () async {
                            await user.sendEmailVerification();
                          },
                          child: AppText(
                            text: "Verify Email",
                            color: Colors.red,
                          )),
                    ),
                    Divider(
                      height: ResponsiveFile.height20,
                      color: Colors.grey.withOpacity(0.3),
                    ),
                    InkWell(
                      onTap: () {
                        share();
                      },
                      child: ListTile(
                        leading: Icon(
                          Icons.share_rounded,
                          color: Colors.green,
                          size: ResponsiveFile.height20,
                        ),
                        title: AppText(
                          text: 'Share',
                          size: ResponsiveFile.radius17,
                        ),
                      ),
                    ),
                    Divider(
                      height: ResponsiveFile.height20,
                      color: Colors.grey.withOpacity(0.3),
                    ),
                    InkWell(
                      onTap: () async {
                        SignOut();
                        isLoading = true;
                      },
                      child: ListTile(
                        leading: Icon(
                          Icons.account_circle_outlined,
                          color: Colors.blueAccent,
                          size: ResponsiveFile.height20,
                        ),
                        title: AppText(
                          text: 'LogOut',
                          size: ResponsiveFile.radius17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('_currentAddress', _currentAddress));
  }
}
