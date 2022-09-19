import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:twitterAPP/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:twitterAPP/screens/home_page.dart';
import 'package:twitter_login/twitter_login.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class Authentication {
  static SnackBar customSnackBar({required String content}) {
    return SnackBar(
      backgroundColor: Colors.black,
      content: Text(
        content,
        style: TextStyle(color: Colors.redAccent, letterSpacing: 0.5),
      ),
    );
  }

  static Future<FirebaseApp> initializeFirebase({
    required BuildContext context,
  }) async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => MainHomeScreen(),
        ),
      );
    }

    return firebaseApp;
  }

  static Future<UserCredential> signInWithTwitter() async {
    // Create a TwitterLogin instance
    final twitterLogin = new TwitterLogin(
        apiKey: 'r87tVVHxtaMMbwIHUGPOwN3ny',
        apiSecretKey: '41Sd9SuSYxhaVRqCWXbb3mn4jKPs5nm4x0gibqpjNzzbuRoBBN',
        redirectURI: 'TwitAccChecker://');

    // Trigger the sign-in flow
    final authResult = await twitterLogin.loginV2();

    // Create a credential from the access token
    final twitterAuthCredential = TwitterAuthProvider.credential(
      accessToken: authResult.authToken!,
      secret: authResult.authTokenSecret!,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance
        .signInWithCredential(twitterAuthCredential);
  }
}
