import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:twitterAPP/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:twitterAPP/screens/home_page.dart';
import 'package:twitter_login/entity/auth_result.dart';
import 'package:twitter_login/schemes/access_token.dart';
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
      signInWithTwitter(context: context);
    }

    return firebaseApp;
  }

  static Future<AuthResult?> signInWithTwitter(
      {required BuildContext context}) async {
    AuthResult? userTwitAccount;
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

    try {
      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(twitterAuthCredential);
      userTwitAccount = authResult;
      String? fireUid = FirebaseAuth.instance.currentUser?.uid;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => MainHomeScreen(
            authResult: authResult,
            fireUid: fireUid,
          ),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        ScaffoldMessenger.of(context).showSnackBar(
          Authentication.customSnackBar(
            content: 'The account already exists with a different credential',
          ),
        );
      } else if (e.code == 'invalid-credential') {
        ScaffoldMessenger.of(context).showSnackBar(
          Authentication.customSnackBar(
            content: 'Error occurred while accessing credentials. Try again.',
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        Authentication.customSnackBar(
          content: 'Error occurred using Google Sign In. Try again.',
        ),
      );
    }
  }
}
