import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:printonex_final/Providers/auth_provider.dart';
import 'package:printonex_final/consts/bezierContainer.dart';
import 'package:printonex_final/consts/firebase/color_constants.dart';
import 'package:printonex_final/consts/responsive_file.dart';
import 'package:printonex_final/consts/text_class.dart';
import 'package:printonex_final/main_screen.dart';
import 'package:printonex_final/services/authuser.dart';
import 'package:printonex_final/services/validation.dart';
import 'package:printonex_final/views/auth_pages/registration.dart';
import 'package:printonex_final/views/auth_pages/forgetpassword.dart';
import 'package:provider/provider.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    switch (authProvider.status) {
      case Status.authenticateError:
        Fluttertoast.showToast(msg: 'Authentication Failed Check Email/Password', backgroundColor:Colors.red);
        break;
      case Status.uninitialized:
        print('Starting....');
        break;
      case Status.authenticating:
       print('Checking For Authentication');
        break;
      case Status.authenticated:
        Fluttertoast.showToast(msg: 'Authentication Has Success', backgroundColor:Colors.greenAccent);
        break;
      default:
        break;
    }
    return GestureDetector(
      onTap: () {
        _focusEmail.unfocus();
        _focusPassword.unfocus();
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
                                text: '-Log In',
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
                          // Container(
                          //   //show error message here
                          //   margin: EdgeInsets.only(top: 20),
                          //   padding: EdgeInsets.all(10),
                          //   child: error ? errmsg(errormsg) : Container(),
                          //   //if error == true then show error message
                          //   //else set empty container as child
                          // ),
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
                                      autofillHints: [AutofillHints.email],
                                      keyboardType: TextInputType.emailAddress,
                                      validator: (value) =>
                                          Validator.validateEmail(
                                            email: value,
                                          ),
                                      decoration: InputDecoration(
                                          contentPadding: EdgeInsets.only(
                                              left:
                                                  ResponsiveFile.height20 + 10),
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
                                      autofillHints: [AutofillHints.password],
                                      keyboardType: TextInputType.text,
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
                      SizedBox(height: ResponsiveFile.height20 - 10),
                      InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ForgetPassword(),
                              ),
                            );
                          },
                          child: Container(
                              width: ResponsiveFile.screenWidth,
                              child: const AppText(
                                text: "Forget Password?",
                                fontStyle: FontStyle.italic,
                                textAlign: TextAlign.right,
                                fontWeight: FontWeight.bold,
                              ))),
                      SizedBox(height: ResponsiveFile.height20),
                      InkWell(
                        onTap: () async {
                          _focusEmail.unfocus();
                          _focusPassword.unfocus();

                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              _isProcessing = true;
                            });
                            bool isSuccess =
                                await authProvider.signInUsingEmailPassword(
                              email: _emailTextController.text,
                              password: _passwordTextController.text,
                            );

                            setState(() {
                              _isProcessing = false;
                            });
                            if (isSuccess) {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const MainScreen()));
                            }
                          }
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width / 5 * 2,
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
                                  "Login",
                                  style: TextStyle(
                                      fontSize: ResponsiveFile.font19,
                                      color: Colors.white),
                                ),
                        ),
                      ),
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
                        onTap: () async {
                          _focusEmail.unfocus();
                          _focusPassword.unfocus();

                          setState(() {
                            _isProcessing = true;
                          });
                          User? user = await FireAuth.signInAnonymously();
                          setState(() {
                            _isProcessing = false;
                          });
                          if (user != null) {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => MainScreen(),
                              ),
                            );
                          }
                        },
                        child: Container(
                          height: 40,
                          margin:
                              EdgeInsets.symmetric(horizontal: 50, vertical: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white70,
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(5),
                                        topLeft: Radius.circular(5)),
                                  ),
                                  alignment: Alignment.center,
                                  child: GradientText(
                                    "G",
                                    style: TextStyle(
                                        fontSize: 35,
                                        fontWeight: FontWeight.bold),
                                    colors: [
                                      Colors.red,
                                      Colors.greenAccent,
                                      Colors.blueAccent,
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 5,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.only(
                                        bottomRight: Radius.circular(5),
                                        topRight: Radius.circular(5)),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text('Sing In As Guest',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w400)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: 40,
                        margin:
                            EdgeInsets.symmetric(horizontal: 50, vertical: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(5),
                                      topLeft: Radius.circular(5)),
                                ),
                                alignment: Alignment.center,
                                child: Image.asset("images/google.png"),
                              ),
                            ),
                            Expanded(
                              flex: 5,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.blueAccent,
                                  borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(5),
                                      topRight: Radius.circular(5)),
                                ),
                                alignment: Alignment.center,
                                child: Text('Log in with Google',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => RegisterPage(),
                            ),
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
                                'Don\'t have an account ?',
                                style: TextStyle(
                                    fontSize: ResponsiveFile.font16,
                                    fontWeight: FontWeight.w600),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Register',
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
              if (authProvider.status == Status.authenticating)
                const Opacity(
                  opacity: 0.8,
                  child: ModalBarrier(dismissible: false, color: Colors.black),
                )
              else
                Container(),
              Center(
                child: authProvider.status == Status.authenticating
                    ? const CircularProgressIndicator()
                    : SizedBox.shrink(),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
