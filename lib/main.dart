import 'package:flutter/material.dart';
import 'package:twitterAPP/res/custom_colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:twitterAPP/firebase_options.dart';

import 'screens/sign_in_screen.dart';

void main() {
  runApp(TwitterAccountChecker());
}

class TwitterAccountChecker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CaloriesCounter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.yellow,
        brightness: Brightness.dark,
      ),
      home: SignInScreen(),
    );
  }
}
