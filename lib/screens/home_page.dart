import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:twitterAPP/res/custom_colors.dart';
import 'package:twitterAPP/screens/sign_in_screen.dart';
import 'package:twitterAPP/widgets/app_bar_title.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:http/http.dart' as http;

class MainHomeScreen extends StatefulWidget {
  @override
  _MainHomeScreenState createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  Route _routeToSignInScreen() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => SignInScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(-1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  @override
  void initState() {
    //_user = widget._user;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("API Page"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return FutureBuilder<MyData>(
      future: APIService().get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        }
        if (!snapshot.hasData) {
          return const Center(child: Text("get() returns null!"));
        }
        final data = snapshot.data as MyData; // cast to MyData
        return Container(
          padding: const EdgeInsets.all(10),
          color: Colors.grey,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Field1"),
                  Text(data.field1),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Field2"),
                  Text(data.field2),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

// Rapid API to reach botometer for bot account detection
class APIService {
  static const _authority = "botometer-pro.p.rapidapi.com";
  static const _path = "/4/check_account";
  static const _query = {"sign": "aquarius", "day": "today"};
  static const Map<String, String> _headers = {
    "x-rapidapi-key": "47d20ae0a5msh3a2c52dbfb15a29p19643fjsnb51e398c8d75",
    "x-rapidapi-host": "botometer-pro.p.rapidapi.com",
  };

  // Base API request to get response
  Future<MyData> get() async {
    Uri uri = Uri.https(_authority, _path, _query);
    final response = await http.get(uri, headers: _headers);
    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.
      final jsonMap = json.decode(response.body);
      return MyData.fromJson(jsonMap);
    } else {
      // If that response was not OK, throw an error.
      throw Exception(
          'API call returned: ${response.statusCode} ${response.reasonPhrase}');
    }
  }
}

class MyData {
  final String field1;
  final String field2;

  const MyData({
    this.field1 = '',
    this.field2 = '',
  });

  factory MyData.fromJson(Map<String, dynamic> json) => _$MyDataFromJson(json);
}

MyData _$MyDataFromJson(Map<String, dynamic> json) => MyData(
      field1: json['field1'] as String? ?? '',
      field2: json['field2'] as String? ?? '',
    );
