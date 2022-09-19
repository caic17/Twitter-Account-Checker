// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCH71Y2n0HdLxjW4nGHaMtaT1_REkjunCM',
    appId: '1:530957821576:web:94fa7a568b030babcfe13d',
    messagingSenderId: '530957821576',
    projectId: 'twitaccountchecker',
    authDomain: 'twitaccountchecker.firebaseapp.com',
    storageBucket: 'twitaccountchecker.appspot.com',
    measurementId: 'G-X4SWPGJMBB',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCYIONGXtJILIR8NShHcX95vPdVlI_SOZE',
    appId: '1:530957821576:android:6153315037885697cfe13d',
    messagingSenderId: '530957821576',
    projectId: 'twitaccountchecker',
    storageBucket: 'twitaccountchecker.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAPoubhEpiXFNT7aEZC0liZKVaBW9-zJT4',
    appId: '1:530957821576:ios:54155810988e0045cfe13d',
    messagingSenderId: '530957821576',
    projectId: 'twitaccountchecker',
    storageBucket: 'twitaccountchecker.appspot.com',
    iosClientId: '530957821576-9g8ua6n6ae5ru9alobnjktogk4naeoqh.apps.googleusercontent.com',
    iosBundleId: 'com.example.myApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAPoubhEpiXFNT7aEZC0liZKVaBW9-zJT4',
    appId: '1:530957821576:ios:54155810988e0045cfe13d',
    messagingSenderId: '530957821576',
    projectId: 'twitaccountchecker',
    storageBucket: 'twitaccountchecker.appspot.com',
    iosClientId: '530957821576-9g8ua6n6ae5ru9alobnjktogk4naeoqh.apps.googleusercontent.com',
    iosBundleId: 'com.example.myApp',
  );
}
