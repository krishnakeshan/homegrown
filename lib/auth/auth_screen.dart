import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:homegrown/main.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() {
    return _AuthScreenState();
  }
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  void initState() {
    super.initState();

    // check for auth status
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (buildContext) {
              return HomePage();
            },
          ),
        );
      }
    });
  }

  @override
  Widget build(context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Heading
            Text(
              "Welcome to Homegrown",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),

            // Login with Google
            Container(
              margin: EdgeInsets.only(top: 24),
              child: RaisedButton.icon(
                color: Colors.white,
                icon: Icon(
                  Icons.login,
                  color: Colors.blue,
                ),
                label: Text(
                  "Sign in with Google",
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
                onPressed: _signInWithGoogle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<UserCredential> _signInWithGoogle() async {
  final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
  final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
  final GoogleAuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );

  return await FirebaseAuth.instance.signInWithCredential(credential);
}
