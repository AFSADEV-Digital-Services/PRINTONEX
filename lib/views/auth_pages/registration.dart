import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:printonex_final/consts/bezierContainer.dart';
import 'package:printonex_final/consts/responsive_file.dart';
import 'package:printonex_final/services/authuser.dart';
import 'package:printonex_final/services/validation.dart';
import 'package:printonex_final/views/auth_pages/login.dart';
import 'package:printonex_final/views/auth_pages/profile.dart';
import 'package:printonex_final/views/pages/home.dart';


class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _registerFormKey = GlobalKey<FormState>();

  final _nameTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  final _focusName = FocusNode();
  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();

  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusName.unfocus();
        _focusEmail.unfocus();
        _focusPassword.unfocus();
      },
      child: Scaffold(
          body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: <Widget>[
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                child: Row(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
                      child: Icon(Icons.keyboard_arrow_left, color: Colors.black),
                    ),
                    Text('Back',
                        style: TextStyle(fontSize: ResponsiveFile.font19, fontWeight: FontWeight.bold))
                  ],
                ),
              ),
            ),
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
                      text:  TextSpan(
                          text: '!',
                          style: TextStyle(
                              fontSize: ResponsiveFile.height30,
                              fontWeight: FontWeight.w700,
                              color: Color(0xffe46b10)),
                          children: [
                            TextSpan(
                              text: 'PRINTO',
                              style:
                                  TextStyle(color: Colors.black, fontSize: ResponsiveFile.height30),
                            ),
                            TextSpan(
                              text: 'NEX',
                              style: TextStyle(
                                  color: Color(0xffe46b10), fontSize: ResponsiveFile.height30),
                            ),
                            TextSpan(
                              text: ' -Register' ,
                              style: TextStyle(
                                  color: Colors.deepPurpleAccent, fontSize: 30),
                            ),
                          ]),
                    ),
                    SizedBox(height: ResponsiveFile.height30),
                    Column(
                      children: <Widget>[
                        // Container(
                        //   //show error message here
                        //   margin: EdgeInsets.only(top: 20),
                        //   padding: EdgeInsets.all(10),
                        //   child: error ? errmsg(errormsg) : Container(),
                        //   //if error == true then show error message
                        //   //else set empty container as child
                        // ),
                        Container(
                          margin:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                          child: Form(
                            key: _registerFormKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                 Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: ResponsiveFile.height20),
                                  child: Text(
                                    "Name",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: ResponsiveFile.font19),
                                  ),
                                ),
                                SizedBox(height: ResponsiveFile.height10),
                                //Password

                                TextFormField(
                                    controller: _nameTextController,
                                    focusNode: _focusName,
                                    validator: (value) =>
                                        Validator.validateName(
                                          name: value,
                                        ),
                                    decoration: InputDecoration(
                                        contentPadding:
                                            EdgeInsets.only(left: ResponsiveFile.height30-5),
                                        //focusColor: Colors.greenAccent,
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(ResponsiveFile.height20+5),
                                          borderSide: const BorderSide(
                                              color: Colors.greenAccent),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(ResponsiveFile.height30),
                                          borderSide: const BorderSide(
                                            color: Colors.white,
                                          ),
                                        ),
                                        //border: InputBorder.none,
                                        fillColor: Color(0xffe46b10),
                                        filled: true)),
                                SizedBox(height: ResponsiveFile.height20),

                                //Password

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
                                        contentPadding:
                                             EdgeInsets.only(left: ResponsiveFile.height20+5),
                                        //focusColor: Colors.greenAccent,
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(ResponsiveFile.height20+5),
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
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: ResponsiveFile.height20),
                                  child: Text(
                                    "Password",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: ResponsiveFile.font19),
                                  ),
                                ),
                                SizedBox(height: ResponsiveFile.height10),
                                TextFormField(
                                    controller: _passwordTextController,
                                    focusNode: _focusPassword,
                                    obscureText: true,
                                    validator: (value) =>
                                        Validator.validatePassword(
                                          password: value,
                                        ),
                                    decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.only(left: 25.0),

                                        focusColor: Colors.greenAccent,
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(25),
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
                              ],
                            ),
                          ),
                        ),
                        // password
                      ],
                    ),
                    SizedBox(height: ResponsiveFile.height20),
                    Container(
                      width: MediaQuery.of(context).size.width / 3,
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(30)),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                color: Colors.grey.shade200,
                                offset: Offset(2, 4),
                                blurRadius: 5,
                                spreadRadius: 2)
                          ],
                          gradient: const LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [Color(0xfffbb448), Color(0xfff7892b)])),
                      child: InkWell(
                        onTap: () async {
                          setState(() {
                            _isProcessing = true;
                          });

                          if (_registerFormKey.currentState!.validate()) {
                            User? user =
                                await FireAuth.registerUsingEmailPassword(
                              name: _nameTextController.text,
                              email: _emailTextController.text,
                              password: _passwordTextController.text,
                            );

                            setState(() {
                              _isProcessing = false;
                            });

                            if (user != null) {
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (context) => Home(),
                                ),
                                ModalRoute.withName('/'),
                              );
                            }
                          }
                        },
                        child: _isProcessing
                            ? SizedBox(
                                height: ResponsiveFile.height20,
                                width: ResponsiveFile.height20,
                                child: CircularProgressIndicator(
                                  backgroundColor: Colors.orange[100],
                                  valueColor: const AlwaysStoppedAnimation<Color>(
                                      Colors.deepOrangeAccent),
                                ),
                              )
                            : Text(
                                "Register",
                                style: TextStyle(fontSize: ResponsiveFile.height20-2),
                              ),
                        //if {showprogress == true then show progress indicator
                        // else show "LOGIN NOW" text
                      ),
                    ),
                    SizedBox(height: ResponsiveFile.height20),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 20),
                      child: Row(
                        children: const <Widget>[
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Divider(
                                thickness: 1,
                              ),
                            ),
                          ),
                          Text('or'),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Divider(
                                thickness: 1,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => LoginPage(),
                          ),
                          ModalRoute.withName('/Login'),
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 5),
                        padding: EdgeInsets.all(15),
                        alignment: Alignment.bottomCenter,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Already have an account ?',
                              style: TextStyle(fontSize: ResponsiveFile.font16, fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Log In',
                              style: TextStyle(
                                  color: Color(0xfff79c4f),
                                  fontSize: ResponsiveFile.font16,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
