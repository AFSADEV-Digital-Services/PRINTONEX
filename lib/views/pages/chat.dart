import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:printonex_final/Providers/auth_provider.dart';
import 'package:printonex_final/Providers/chat_provider.dart';
import 'package:printonex_final/Providers/profile_provider.dart';
import 'package:printonex_final/consts/firebase/all_constants.dart';
import 'package:printonex_final/models/chat_messages.dart';
import 'package:printonex_final/views/auth_pages/login.dart';
import 'package:printonex_final/views/pages/settings.dart';
import 'package:printonex_final/views/widgets/common_widgets.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../consts/responsive_file.dart';

class Chat extends StatefulWidget {
  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  late String currentUserId;
  List<QueryDocumentSnapshot> listMessages = [];
  String adminId = "8ZywDVWyFice42nvCF3n9BVdoO03";
  String logo =
      "https://firebasestorage.googleapis.com/v0/b/printonex-eeff2.appspot.com/o/icons%2Flogo.png?alt=media&token=eddbcced-ade9-418c-8d4d-cd0738c1a550";
  String name = "AFTAB SHAH";
  String avatar =
      "https://firebasestorage.googleapis.com/v0/b/printonex-eeff2.appspot.com/o/icons%2Flogo.png?alt=media&token=eddbcced-ade9-418c-8d4d-cd0738c1a550";

  int _limit = 20;
  final int _limitIncrement = 20;
  String groupChatId = '';
  File? imageFile;
  bool isLoading = false;
  bool isShowSticker = false;
  late bool showEmojiKeyboard;
  String imageUrl = '';

  final TextEditingController textEditingController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final FocusNode focusNode = FocusNode();
  late ChatProvider chatProvider;
  late AuthProvider authProvider;
  final firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firebasestore =  FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();

    chatProvider = context.read<ChatProvider>();
    authProvider = context.read<AuthProvider>();

    focusNode.addListener(onFocusChanged);
    scrollController.addListener(_scrollListener);
    readLocal();
  }

  @override
  void dispose() {
    textEditingController;
    scrollController;
    super.dispose();
  }



  _scrollListener() {
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      setState(() {
        _limit += _limitIncrement;
      });
    }
  }

  void onFocusChanged() {
    if (focusNode.hasFocus) {
      setState(() {
        isShowSticker = false;
      });
    }
  }

  void readLocal() {
    if (authProvider.getFirebaseUserId()?.isNotEmpty == true) {
      currentUserId = authProvider.getFirebaseUserId()!;
    } else {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginPage()),
          (Route<dynamic> route) => false);
    }
    if (currentUserId.compareTo(adminId) > 0) {
      groupChatId = '$currentUserId - ${adminId}';
    } else {
      groupChatId = '${adminId} - $currentUserId';
    }
    chatProvider.updateFirestoreData(FirestoreConstants.pathUserCollection,
        currentUserId, {FirestoreConstants.chattingWith: adminId});
  }

  Future getImage() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? pickedFile;
    pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      if (imageFile != null) {
        setState(() {
          isLoading = true;
        });
        uploadImageFile();
      }
    }
  }

  void getSticker() {
    focusNode.unfocus();
    setState(() {
      isShowSticker = !isShowSticker;
    });
  }

  Future<bool> onBackPressed() {
    if (isShowSticker) {
      setState(() {
        isShowSticker = false;
      });
    } else {
      chatProvider.updateFirestoreData(FirestoreConstants.pathUserCollection,
          currentUserId, {FirestoreConstants.chattingWith: null});
    }
    return Future.value(false);
  }

  void _callPhoneNumber(String phoneNumber) async {
    var url = 'tel://9481924680';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Error Occurred';
    }
  }

  void uploadImageFile() async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    String id = currentUserId;
    UploadTask uploadTask =
        chatProvider.uploadImageFile(imageFile!, fileName, id);
    try {
      TaskSnapshot snapshot = await uploadTask;
      imageUrl = await snapshot.ref.getDownloadURL();
      setState(() {
        isLoading = false;
        onSendMessage(imageUrl, MessageType.image);
      });
    } on FirebaseException catch (e) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: e.message ?? e.toString());
    }
  }

  void onSendMessage(String content, int type) {
    if (content.trim().isNotEmpty) {
      textEditingController.clear();
      chatProvider.sendChatMessage(
          content, type, groupChatId, currentUserId, adminId);
      scrollController.animateTo(0,
          duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    } else {
      Fluttertoast.showToast(
          msg: 'Nothing to send', backgroundColor: Colors.grey);
    }
  }

  // checking if received message
  bool isMessageReceived(int index) {
    if ((index > 0 &&
            listMessages[index - 1].get(FirestoreConstants.idFrom) ==
                currentUserId) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  // checking if sent message
  bool isMessageSent(int index) {
    if ((index > 0 &&
            listMessages[index - 1].get(FirestoreConstants.idFrom) !=
                currentUserId) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.greenAccent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
        leading: IconButton(
          splashRadius: ResponsiveFile.height15,
          onPressed: () {},
          icon: const Icon(
            Icons.online_prediction,
            color: Colors.black,
          ),
        ),
        title: StreamBuilder<DocumentSnapshot>(
            stream: firebasestore.collection(FirestoreConstants.pathUserCollection).doc(firebaseAuth.currentUser!.uid).snapshots(),
            builder: (context, snapshot) {
                  return Text(snapshot.data!['online'].toString());
    }
        ),
        // Text('24x7 Live Chat'.trim()),
        actions: [
          IconButton(
            splashRadius: ResponsiveFile.height15,
            onPressed: () {
              ProfileProvider profileProvider;
              profileProvider = context.read<ProfileProvider>();
              String callPhoneNumber =
                  profileProvider.getPrefs(FirestoreConstants.phoneNumber) ??
                      "";
              _callPhoneNumber(callPhoneNumber);
            },
            icon: const Icon(Icons.phone),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Sizes.dimen_8),
          child: Column(
            children: [
              buildListMessage(),
              buildMessageInput(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMessageInput() {
    return Container(
      margin: EdgeInsets.all(ResponsiveFile.height10 / 2),
      width: double.infinity,
      height: ResponsiveFile.height50,
      child: Row(
        children: [
          Flexible(
            child: TextFormField(
              expands: true,
              cursorColor: Colors.black54,
              textInputAction: TextInputAction.newline,
              maxLines: null,
              minLines: null,
              keyboardType: TextInputType.multiline,
              textCapitalization: TextCapitalization.sentences,
              controller: textEditingController,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(ResponsiveFile.height10/1.5),
                focusColor: Colors.black54,
                hintStyle: const TextStyle(
                  color: Colors.black54,
                ),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.grey.withOpacity(0.2), width: 2.0),
                    borderRadius: const BorderRadius.all(
                        Radius.circular(Sizes.dimen_50))),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.grey.withOpacity(0.2), width: 2.0),
                    borderRadius: const BorderRadius.all(
                        Radius.circular(Sizes.dimen_50))),
                hintText: 'Write here...',
                prefixIconColor: Colors.grey,
                prefixIcon: Padding(
                  padding:
                      const EdgeInsetsDirectional.only(start: Sizes.dimen_6),
                  child: IconButton(
                    splashRadius: Sizes.dimen_18,
                    icon: const Icon(Icons.emoji_emotions_outlined),
                    onPressed: (){
                      getSticker();
                    },
                  ),
                ),
                suffixIconColor: Colors.grey,
                suffixIcon: Padding(
                  padding:
                      const EdgeInsetsDirectional.only(end: Sizes.dimen_10),
                  child: Wrap(
                    alignment: WrapAlignment.end,
                    children: [
                      IconButton(
                        splashRadius: Sizes.dimen_18,
                        icon: const Icon(Icons.attach_file),
                        onPressed: getImage,
                      ),
                      IconButton(
                        splashRadius: Sizes.dimen_18,
                        icon: const Icon(Icons.camera),
                        onPressed: getImage,
                      ),
                    ],
                  ),
                ),
              ),
              onFieldSubmitted: (value) {
                onSendMessage(textEditingController.text, MessageType.text);
              },
            ),
          ),
          SizedBox(
            width: ResponsiveFile.height10 / 2,
          ),
          Container(
            padding: EdgeInsets.all(ResponsiveFile.height10 / 3),
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary,
            ),
            child: IconButton(
              splashRadius: ResponsiveFile.height15,
              onPressed: () {
                onSendMessage(textEditingController.text, MessageType.text);
              },
              icon: const Icon(Icons.send_rounded),
              color: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildItem(int index, DocumentSnapshot? documentSnapshot) {
    final firebaseAuth = FirebaseAuth.instance;
    if (documentSnapshot != null) {
      ChatMessages chatMessages = ChatMessages.fromDocument(documentSnapshot);
      if (chatMessages.idFrom == currentUserId) {
        // right side (my message)
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                chatMessages.type == MessageType.text
                    ? messageBubbleSender(
                  chatContent: chatMessages.content,
                  color: AppColors.spaceLight,
                  textColor: AppColors.white,
                  margin: const EdgeInsets.only(right: Sizes.dimen_10), timeText: DateFormat('hh:mm a').format(
                  DateTime.fromMillisecondsSinceEpoch(
                    int.parse(chatMessages.timestamp),
                  ),
                ),
                )
                    : chatMessages.type == MessageType.image
                    ? Container(
                  margin: const EdgeInsets.only(
                      right: Sizes.dimen_10, top: Sizes.dimen_10),
                  child: chatImage(
                      imageSrc: chatMessages.content, onTap: () {}, dateText: DateFormat('hh:mm a').format(
                    DateTime.fromMillisecondsSinceEpoch(
                      int.parse(chatMessages.timestamp),
                    ),
                  )),
                )
                    : const SizedBox.shrink(),
                isMessageSent(index)
                    ? Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Sizes.dimen_20),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: logo,
                    width: Sizes.dimen_40,
                    height: Sizes.dimen_40,
                    fit: BoxFit.contain,
                    errorWidget: (context, url, error) =>
                    const Icon(Icons.account_circle),
                  ),

                )
                    : Container(
                  width: 35,
                ),
              ],
            ),
            isMessageSent(index)
                ? Container(
              margin: const EdgeInsets.only(
                  right: Sizes.dimen_50,
                  top: Sizes.dimen_6,
                  bottom: Sizes.dimen_8),
              child: Text(
                DateFormat('dd MMM yyyy, hh:mm a').format(
                  DateTime.fromMillisecondsSinceEpoch(
                    int.parse(chatMessages.timestamp),
                  ),
                ),
                style: const TextStyle(
                    color: AppColors.lightGrey,
                    fontSize: Sizes.dimen_12,
                    fontStyle: FontStyle.italic),
              ),
            )
                : const SizedBox.shrink(),
          ],
        );
      } else {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                isMessageReceived(index)
                // left side (received message)
                    ? InkWell(

                  onTap: (){
                    Navigator.pushReplacement(
                        context, MaterialPageRoute(builder: (context) => Profile()));
                  },
                      child: Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Sizes.dimen_20),
                  ),
                  child:CachedNetworkImage(
                      imageUrl:firebaseAuth.currentUser!.photoURL!,
                      width: Sizes.dimen_40,
                      height: Sizes.dimen_40,
                      fit: BoxFit.contain,
                      errorWidget: (context, url, error) =>
                      const Icon(Icons.account_circle),
                  ),

                ),
                    )
                    : Container(
                  width: 35,
                ),
                chatMessages.type == MessageType.text
                    ?
                messageBubbleRecever(
                  chatContent: chatMessages.content,
                  color: AppColors.spaceLight,
                  textColor: AppColors.white,
                  margin: const EdgeInsets.only(left: Sizes.dimen_10), timeText: DateFormat('hh:mm a').format(
                  DateTime.fromMillisecondsSinceEpoch(
                    int.parse(chatMessages.timestamp),
                  ),
                ),
                )
                    : chatMessages.type == MessageType.image
                    ? Container(
                  margin: const EdgeInsets.only(
                      left: Sizes.dimen_10, top: Sizes.dimen_10),
                  child: chatImage(
                      imageSrc: chatMessages.content, onTap: () {}, dateText: DateFormat('hh:mm a').format(
                    DateTime.fromMillisecondsSinceEpoch(
                      int.parse(chatMessages.timestamp),
                    ),
                  )),
                )
                    : const SizedBox.shrink(),
              ],
            ),
            isMessageReceived(index)
                ? Container(
              margin: const EdgeInsets.only(
                  left: Sizes.dimen_50,
                  top: Sizes.dimen_6,
                  bottom: Sizes.dimen_8),
              child: Text(
                DateFormat('dd MMM yyyy, hh:mm a').format(
                  DateTime.fromMillisecondsSinceEpoch(
                    int.parse(chatMessages.timestamp),
                  ),
                ),
                style: const TextStyle(
                    color: AppColors.lightGrey,
                    fontSize: Sizes.dimen_12,
                    fontStyle: FontStyle.italic),
              ),
            )
                : const SizedBox.shrink(),
          ],
        );
      }
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget buildListMessage() {
    return Flexible(
      child: groupChatId.isNotEmpty
          ? StreamBuilder<QuerySnapshot>(
              stream: chatProvider.getChatMessage(groupChatId, _limit),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  listMessages = snapshot.data!.docs;
                  if (listMessages.isNotEmpty) {
                    return ListView.builder(
                        padding: const EdgeInsets.all(10),
                        itemCount: snapshot.data?.docs.length,
                        reverse: true,
                        controller: scrollController,
                        itemBuilder: (context, index) =>
                            buildItem(index, snapshot.data?.docs[index]));
                  } else {
                    return const Center(
                      child: Text('No messages...'),
                    );
                  }
                } else {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.burgundy,
                    ),
                  );
                }
              })
          : const Center(
              child: CircularProgressIndicator(
                color: AppColors.burgundy,
              ),
            ),
    );
  }
}
