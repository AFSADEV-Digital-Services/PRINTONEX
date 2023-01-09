import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:printonex_final/services/authuser.dart';
import 'package:printonex_final/views/auth_pages/login.dart';
import 'package:printonex_final/views/pages/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {


  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _isSendingVerification = false;
  bool _isSigningOut = false;
  String _userId = '';
  late User _currentUser;
  checklogin(){
    FirebaseAuth.instance
        .authStateChanges()
        .listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });
  }

  @override
  void initState() {
    _currentUser = FirebaseAuth.instance.currentUser!;
    super.initState();

  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 10.0, top: 10, bottom: 10),
          child: InkWell(
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => Settings()));
            },
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: Image.asset(
                "assets/logo/logo.png",
                scale: 7,
              )
            ),
          ),
        ),
        title: _currentUser.uid.isEmpty
            ? FlatButton(
          onPressed: () {
            // method to show the search bar
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => LoginPage()));
          },
          child: Text("Login here"),
        )
            : FlatButton(
          onPressed: () {
            // method to show the search bar
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => Settings()));
          },
          child: Text(_currentUser.displayName.toString(), style: TextStyle(fontSize: 16)),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(25),
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'ID: ${_currentUser.uid}',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            Text(
              'Name: ${_currentUser.displayName}',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            Text(
              'Photo: ${_currentUser.photoURL}',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            SizedBox(height: 16.0),
            Text(
              'EMAIL: ${_currentUser.email}',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            SizedBox(height: 16.0),
            _currentUser.emailVerified
                ? Text(
              'Email verified',
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(color: Colors.green),
            )
                : Text(
              'Email not verified',
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(color: Colors.red),
            ),
            SizedBox(height: 16.0),
            _isSendingVerification
                ? CircularProgressIndicator()
                : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      _isSendingVerification = true;
                    });
                    await _currentUser.sendEmailVerification();
                    setState(() {
                      _isSendingVerification = false;
                    });
                  },
                  child: Text('Verify email'),
                ),
                SizedBox(width: 8.0),
                IconButton(
                  icon: Icon(Icons.refresh),
                  onPressed: () async {
                    User? user = await FireAuth.refreshUser(_currentUser);
                    checklogin();

                    if (user != null) {
                      setState(() {
                        _currentUser = user;

                      });
                    }
                  },
                ),
              ],
            ),
            SizedBox(height: 16.0),
            _isSigningOut
                ? CircularProgressIndicator()
                : ElevatedButton(
              onPressed: () async {
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
              child: Text('Sign out'),
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ],
        ),
      ),

    );
  }
}
