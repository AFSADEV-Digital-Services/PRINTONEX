import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:printonex_final/consts/bezierContainer.dart';
import 'package:printonex_final/consts/responsive_file.dart';
import 'package:printonex_final/services/authuser.dart';
import 'package:printonex_final/services/validation.dart';
import 'package:printonex_final/views/auth_pages/login.dart';
import 'package:printonex_final/views/auth_pages/profile.dart';
import 'package:printonex_final/views/pages/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
class ForgetPassword extends StatefulWidget {
  const ForgetPassword({Key? key}) : super(key: key);

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final _formKey = GlobalKey<FormState>();
  final _emailTextController = TextEditingController();
  final _focusEmail = FocusNode();
  bool _isProcessing = false;
  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => Home(),
        ),
      );
    }
    return firebaseApp;
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(

      onTap: () {
        _focusEmail.unfocus();
        },
      child: Scaffold(
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: <Widget>[

              Positioned(
                  top: -MediaQuery.of(context).size.height * .15,
                  right: -MediaQuery.of(context).size.width * .4,
                  child: const BezierContainer()),

              Container(
                padding:
                EdgeInsets.symmetric(horizontal: ResponsiveFile.height20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: ResponsiveFile.screenHeight * .2),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                            text: '!',
                            style: TextStyle(
                                fontSize: ResponsiveFile.height30,
                                fontWeight: FontWeight.w700,
                                color: Color(0xffe46b10)),
                            children: [
                              TextSpan(
                                text: 'PRINTO',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: ResponsiveFile.height30),
                              ),
                              TextSpan(
                                text: 'NEX',
                                style: TextStyle(
                                    color: Color(0xffe46b10),
                                    fontSize: ResponsiveFile.height30),
                              ),
                              TextSpan(
                                text: '-Reset Password',
                                style: TextStyle(
                                    color: Colors.deepPurpleAccent,
                                    fontSize: ResponsiveFile.height30),
                              ),
                              // TextSpan(
                              //   text: 'box.read('email')' ,
                              //   style: TextStyle(
                              //       color: Color(0xffe46b10), fontSize: 30),
                              // ),
                            ]),
                      ),
                      SizedBox(height: ResponsiveFile.height30),
                      Column(
                        children: <Widget>[

                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 5),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: ResponsiveFile.height20),
                                    child: Text(
                                      "Email",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: ResponsiveFile.font19),
                                    ),
                                  ),
                                  SizedBox(height: ResponsiveFile.height10),
                                  //Password

                                  TextFormField(
                                      controller: _emailTextController,
                                      focusNode: _focusEmail,
                                      validator: (value) =>
                                          Validator.validateEmail(
                                            email: value,
                                          ),
                                      decoration: InputDecoration(
                                          contentPadding: EdgeInsets.only(
                                              left:
                                              ResponsiveFile.height20 + 5),
                                          //focusColor: Colors.greenAccent,
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                                ResponsiveFile.height20 + 5),
                                            borderSide: const BorderSide(
                                                color: Colors.greenAccent),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                            BorderRadius.circular(30),
                                            borderSide: const BorderSide(
                                              color: Colors.white,
                                            ),
                                          ),
                                          //border: InputBorder.none,
                                          fillColor: const Color(0xffe46b10),
                                          filled: true)),
                                  SizedBox(height: ResponsiveFile.height20),

                                ],
                              ),
                            ),
                          ),
                          // password
                        ],
                      ),
                      SizedBox(height: ResponsiveFile.height20 - 10),
                      SizedBox(height: ResponsiveFile.height20),

                      InkWell(
                        onTap: () async {
                          _focusEmail.unfocus();
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              _isProcessing = true;
                            });
                            await FireAuth.sendPasswordResetEmail(
                              email: _emailTextController.text,

                            );

                            setState(() {
                              _isProcessing = false;
                            });
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => LoginPage(),
                                ),
                              );

                          }

                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width/5*2,
                          padding: EdgeInsets.symmetric(vertical: 15),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.all(Radius.circular(30)),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                    color: Colors.grey.shade200,
                                    offset: Offset(2, 4),
                                    blurRadius: 5,
                                    spreadRadius: 2)
                              ],
                              gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    Color(0xfffbb448),
                                    Color(0xfff7892b)
                                  ])),
                          child: _isProcessing
                              ? SizedBox(
                            height: ResponsiveFile.height20,
                            width: ResponsiveFile.height20,
                            child: CircularProgressIndicator(
                              backgroundColor: Colors.orange[100],
                              valueColor:
                              const AlwaysStoppedAnimation<Color>(
                                  Colors.deepOrangeAccent),
                            ),
                          )
                              : Text(
                            "Reset Password",
                            style: TextStyle(
                                fontSize: ResponsiveFile.font19, color: Colors.white),
                          ),
                        ),
                      ),



                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // body: FutureBuilder(
        //   future: _initializeFirebase(),
        //   builder: (context, snapshot) {
        //     if (snapshot.connectionState == ConnectionState.done){
        //       return SizedBox(
        //         height: ResponsiveFile.screenHeight,
        //         child: Stack(
        //           children: <Widget>[
        //             Positioned(
        //                 top: ResponsiveFile.screenHeight * .15,
        //                 right: -MediaQuery.of(context).size.width * .4,
        //                 child: const BezierContainer()),
        //             Container(
        //               padding:
        //               EdgeInsets.symmetric(horizontal: ResponsiveFile.height20),
        //               child: SingleChildScrollView(
        //                 child: Column(
        //                   crossAxisAlignment: CrossAxisAlignment.center,
        //                   mainAxisAlignment: MainAxisAlignment.center,
        //                   children: <Widget>[
        //                     SizedBox(height: ResponsiveFile.screenHeight * .2),
        //                     RichText(
        //                       textAlign: TextAlign.center,
        //                       text:  TextSpan(
        //                           text: '!',
        //                           style: TextStyle(
        //                               fontSize: ResponsiveFile.height30,
        //                               fontWeight: FontWeight.w700,
        //                               color: Color(0xffe46b10)),
        //                           children: [
        //                             TextSpan(
        //                               text: 'PRINTO',
        //                               style:
        //                               TextStyle(color: Colors.black, fontSize: ResponsiveFile.height30),
        //                             ),
        //                             TextSpan(
        //                               text: 'NEX',
        //                               style: TextStyle(
        //                                   color: Color(0xffe46b10), fontSize: ResponsiveFile.height30),
        //                             ),
        //                             // TextSpan(
        //                             //   text: 'box.read('email')' ,
        //                             //   style: TextStyle(
        //                             //       color: Color(0xffe46b10), fontSize: 30),
        //                             // ),
        //                           ]),
        //                     ),
        //                     SizedBox(height: ResponsiveFile.height30),
        //                     Column(
        //                       children: <Widget>[
        //                         // Container(
        //                         //   //show error message here
        //                         //   margin: EdgeInsets.only(top: 20),
        //                         //   padding: EdgeInsets.all(10),
        //                         //   child: error ? errmsg(errormsg) : Container(),
        //                         //   //if error == true then show error message
        //                         //   //else set empty container as child
        //                         // ),
        //                         Container(
        //                           margin:
        //                           EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        //                           child: Form(
        //                             key: _formKey,
        //                             child: Column(
        //                               crossAxisAlignment: CrossAxisAlignment.start,
        //                               children: <Widget>[
        //
        //                                 Padding(
        //                                   padding: EdgeInsets.symmetric(
        //                                       horizontal: ResponsiveFile.height20),
        //                                   child: Text(
        //                                     "Email",
        //                                     style: TextStyle(
        //                                         fontWeight: FontWeight.bold,
        //                                         fontSize: ResponsiveFile.font14),
        //                                   ),
        //                                 ),
        //                                 SizedBox(height: ResponsiveFile.height10),
        //                                 //Password
        //
        //                                 TextFormField(
        //                                     controller: _emailTextController,
        //                                     focusNode: _focusEmail,
        //                                     validator: (value) =>
        //                                         Validator.validateEmail(
        //                                           email: value,
        //                                         ),
        //                                     decoration: InputDecoration(
        //                                         contentPadding:
        //                                         EdgeInsets.only(left: ResponsiveFile.height20+5),
        //                                         //focusColor: Colors.greenAccent,
        //                                         focusedBorder: OutlineInputBorder(
        //                                           borderRadius:
        //                                           BorderRadius.circular(ResponsiveFile.height20+5),
        //                                           borderSide: const BorderSide(
        //                                               color: Colors.greenAccent),
        //                                         ),
        //                                         enabledBorder: OutlineInputBorder(
        //                                           borderRadius:
        //                                           BorderRadius.circular(30),
        //                                           borderSide: const BorderSide(
        //                                             color: Colors.white,
        //                                           ),
        //                                         ),
        //                                         //border: InputBorder.none,
        //                                         fillColor: const Color(0xffe46b10),
        //                                         filled: true)),
        //                                 SizedBox(height: ResponsiveFile.height20),
        //                                 Padding(
        //                                   padding: EdgeInsets.symmetric(
        //                                       horizontal: ResponsiveFile.height20),
        //                                   child: Text(
        //                                     "Password",
        //                                     style: TextStyle(
        //                                         fontWeight: FontWeight.bold,
        //                                         fontSize: ResponsiveFile.font14),
        //                                   ),
        //                                 ),
        //                                 SizedBox(height: ResponsiveFile.height10),
        //                                 TextFormField(
        //                                     controller: _passwordTextController,
        //                                     focusNode: _focusPassword,
        //                                     obscureText: true,
        //                                     validator: (value) =>
        //                                         Validator.validatePassword(
        //                                           password: value,
        //                                         ),
        //                                     decoration: InputDecoration(
        //                                         contentPadding:
        //                                         const EdgeInsets.only(left: 25.0),
        //
        //                                         focusColor: Colors.greenAccent,
        //                                         focusedBorder: OutlineInputBorder(
        //                                           borderRadius:
        //                                           BorderRadius.circular(25),
        //                                           borderSide: const BorderSide(
        //                                               color: Colors.greenAccent),
        //                                         ),
        //                                         enabledBorder: OutlineInputBorder(
        //                                           borderRadius:
        //                                           BorderRadius.circular(30),
        //                                           borderSide: const BorderSide(
        //                                             color: Colors.white,
        //                                           ),
        //                                         ),
        //                                         //border: InputBorder.none,
        //                                         fillColor: const Color(0xffe46b10),
        //                                         filled: true)),
        //                               ],
        //                             ),
        //                           ),
        //                         ),
        //                         // password
        //                       ],
        //                     ),
        //                     SizedBox(height: ResponsiveFile.height20),
        //                     Container(
        //                       width: MediaQuery.of(context).size.width / 3,
        //                       margin: const EdgeInsets.symmetric(horizontal: 20),
        //                       padding: const EdgeInsets.symmetric(vertical: 15),
        //                       alignment: Alignment.center,
        //                       decoration: BoxDecoration(
        //                           borderRadius: const BorderRadius.all(Radius.circular(30)),
        //                           boxShadow: <BoxShadow>[
        //                             BoxShadow(
        //                                 color: Colors.grey.shade200,
        //                                 offset: Offset(2, 4),
        //                                 blurRadius: 5,
        //                                 spreadRadius: 2)
        //                           ],
        //                           gradient: const LinearGradient(
        //                               begin: Alignment.centerLeft,
        //                               end: Alignment.centerRight,
        //                               colors: [Color(0xfffbb448), Color(0xfff7892b)])),
        //                       child: InkWell(
        //                         onTap: () async {
        //
        //                             _focusEmail.unfocus();
        //                             _focusPassword.unfocus();
        //
        //                             if (_formKey.currentState!
        //                                 .validate()) {
        //                               setState(() {
        //                                 _isProcessing = true;
        //                               });
        //
        //                               User? user = await FireAuth
        //                                   .signInUsingEmailPassword(
        //                                 email: _emailTextController.text,
        //                                 password:
        //                                 _passwordTextController.text,
        //                               );
        //
        //                               setState(() {
        //                                 _isProcessing = false;
        //                               });
        //
        //                               if (user != null) {
        //                                 Navigator.of(context)
        //                                     .pushReplacement(
        //                                   MaterialPageRoute(
        //                                     builder: (context) =>
        //                                         ProfilePage(user: user),
        //                                   ),
        //                                 );
        //                               }
        //                             }
        //
        //                         },
        //                         child: _isProcessing
        //                             ? SizedBox(
        //                           height: ResponsiveFile.height20,
        //                           width: ResponsiveFile.height20,
        //                           child: CircularProgressIndicator(
        //                             backgroundColor: Colors.orange[100],
        //                             valueColor: const AlwaysStoppedAnimation<Color>(
        //                                 Colors.deepOrangeAccent),
        //                           ),
        //                         )
        //                             : Text(
        //                           "Login",
        //                           style: TextStyle(fontSize: ResponsiveFile.height20-2),
        //                         ),
        //                         //if {showprogress == true then show progress indicator
        //                         // else show "LOGIN NOW" text
        //                       ),
        //                     ),
        //                     SizedBox(height: ResponsiveFile.height20),
        //                     InkWell(
        //                       onTap: (){
        //                         Navigator.of(context).push(
        //                           MaterialPageRoute(
        //                             builder: (context) =>
        //                                 RegisterPage(),
        //                           ),
        //                         );
        //                       },
        //                       child: Container(
        //                         width: MediaQuery.of(context).size.width / 3,
        //                         margin: const EdgeInsets.symmetric(horizontal: 20),
        //                         padding: const EdgeInsets.symmetric(vertical: 15),
        //                         alignment: Alignment.center,
        //                         decoration: BoxDecoration(
        //                             borderRadius: const BorderRadius.all(Radius.circular(30)),
        //                             boxShadow: <BoxShadow>[
        //                               BoxShadow(
        //                                   color: Colors.grey.shade200,
        //                                   offset: Offset(2, 4),
        //                                   blurRadius: 5,
        //                                   spreadRadius: 2)
        //                             ],
        //                             gradient: const LinearGradient(
        //                                 begin: Alignment.centerLeft,
        //                                 end: Alignment.centerRight,
        //                                 colors: [Color(0xfffbb448), Color(0xfff7892b)])),
        //                         child: Text(
        //                           "Not Yet Register?",
        //                           style: TextStyle(fontSize: ResponsiveFile.height20-2),
        //                         ),
        //                       ),
        //                     )
        //                   ],
        //                 ),
        //               ),
        //             ),
        //           ],
        //         ),
        //       );
        //     }
        //     return Center(
        //       child: CircularProgressIndicator(),
        //     );
        //   },
        // )
      ),
    );
  }
}
