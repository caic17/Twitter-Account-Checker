import 'dart:ffi';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:twitterAPP/res/custom_colors.dart';
import 'package:twitterAPP/screens/sign_in_screen.dart';
import 'package:twitterAPP/widgets/app_bar_title.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:twitterAPP/data/user_db.dart' as user_db;
import 'package:twitter_login/entity/auth_result.dart';
// database stuff
import 'package:twitterAPP/data/account_info.dart';
import 'package:twitterAPP/data/user_db.dart';
import 'package:twitterAPP/data/users.dart';

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({String? fireUid, required AuthResult authResult})
      : _authResult = authResult,
        _fireUid = fireUid;

  final AuthResult _authResult;
  final String? _fireUid;

  @override
  _MainHomeScreenState createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  late AuthResult _authResult;
  late String _fireUid;

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
    _authResult = widget._authResult;

    super.initState();
  }

  Future testBotometer() async {
    const authority = "botometer-pro.p.rapidapi.com";
    const path = "/4/check_account";
    const query = {
      "mentions": [],
      "timeline": [
        {
          "contributors": null,
          "coordinates": null,
          "created_at": "Fri Aug 07 14:26:36 +0000 2020",
          "entities": {
            "hashtags": [],
            "symbols": [],
            "urls": [],
            "user_mentions": [
              {
                "id": 2584,
                "id_str": "2584",
                "indices": [0, 12],
                "name": "mentined user",
                "screen_name": "mentioned_user"
              }
            ]
          },
          "favorite_count": 0,
          "favorited": false,
          "geo": null,
          "id": 12917,
          "id_str": "12917",
          "in_reply_to_screen_name": "mentioned_user",
          "in_reply_to_status_id": 1291741,
          "in_reply_to_status_id_str": "1291741",
          "in_reply_to_user_id": 2584,
          "in_reply_to_user_id_str": "2584",
          "is_quote_status": false,
          "lang": "und",
          "place": null,
          "retweet_count": 0,
          "retweeted": false,
          "text": "@mentioned_user Yes",
          "truncated": false,
          "user": {
            "contributors_enabled": false,
            "created_at": "Mon May 27 17:57:42 +0000 2019",
            "default_profile": true,
            "default_profile_image": false,
            "description": "description",
            "entities": {
              "description": {"urls": []},
              "url": {"urls": []}
            },
            "favourites_count": 754,
            "follow_request_sent": false,
            "followers_count": 130,
            "following": false,
            "friends_count": 295,
            "geo_enabled": false,
            "has_extended_profile": true,
            "id": 11330,
            "id_str": "11330",
            "is_translation_enabled": false,
            "is_translator": false,
            "lang": null,
            "listed_count": 3,
            "location": "location",
            "name": "test user 1",
            "notifications": false,
            "profile_background_color": "F5F8FA",
            "profile_background_image_url": null,
            "profile_background_image_url_https": null,
            "profile_background_tile": false,
            "profile_banner_url": null,
            "profile_image_url": null,
            "profile_image_url_https": null,
            "profile_link_color": "1DA1F2",
            "profile_sidebar_border_color": "C0DEED",
            "profile_sidebar_fill_color": "DDEEF6",
            "profile_text_color": "333333",
            "profile_use_background_image": true,
            "protected": false,
            "screen_name": "screen_name_2",
            "statuses_count": 283,
            "time_zone": null,
            "translator_type": "none",
            "url": null,
            "utc_offset": null,
            "verified": false
          }
        }
      ],
      "user": {"id_str": "11330", "screen_name": "screen_name"}
    };
    const Map<String, String> headers = {
      "content-type": "application/json",
      "X-RapidAPI-Key": "edc90ee20fmsh0685d7a380d59dep130e93jsn099c8a71b848",
      "X-RapidAPI-Host": "botometer-pro.p.rapidapi.com",
    };

    List<Map<String, Object?>> botScore;
    List<Double> allScores;
    Uri uri = Uri.https(authority, path);
    Map<String, dynamic> data;

    final response =
        await http.post(uri, headers: headers, body: json.encode(query));
    //body = GET users/show + GET statuses/user_timeline + GET statuses/user_mentions
    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.
      //final jsonMap = json.decode(response.body.toString());
      data = json.decode(response.body.toString());
      //botScore = data['cap']['universal'];
      //allScores = data['cap']['display_scores']['universal'];
      print(data);
      return data;
      //return MyData.fromJson(jsonMap);
    } else {
      // If that response was not OK, throw an error.
      throw Exception(
          'API call returned: ${response.statusCode} ${response.reasonPhrase}');
    }
  }

  Future initializeFirestore(
      String id_str, String screenName, String botScore) async {
    final CollectionReference recipeCollection =
        FirebaseFirestore.instance.collection("account_info");
    recipeCollection.doc(FirebaseAuth.instance.currentUser!.uid).set({
      'id_str': _authResult.user!.id.toString(),
      'screen_name': _authResult.user!.screenName
    });

    recipeCollection
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('following_ids')
        .add({
      "id_str": id_str,
      "screenName": screenName,
      "botScore": botScore,
    });
  }

  Future runSystem() async {
    // Debug cases:
    String id_str = "01234567890";
    String screenName = "BU ENG Stud";
    //String botScore = "3.2";
    // Runs Twitter API "GET followers/ids" on _authResult.user!.screenName and _authResult.user!.id_str
    // get a list of following ids and screenName, for each item do the following
    // fetch RAPID API AND GET BOT SCORE
    Map allstuff = await testBotometer();
    double botscore = allstuff['cap']['universal'];
    //print(botscore);
    // save the Twitter ID, twitter @ScreenName and BotScore into FireStore and will display as list
    initializeFirestore(id_str, screenName, botscore.toString());
  }

  @override
  Widget build(BuildContext context) {
    _fireUid = "TFoYzXh53iONvzBqrLp9eKJIz343";
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 186, 242, 248),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color.fromARGB(255, 15, 132, 209),
        title: AppBarTitle(),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            bottom: 20.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(),
              SizedBox(height: 16.0),
              Text(
                'Hello @' + _authResult.user!.screenName,
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 25),
              ),
              SizedBox(height: 8.0),
              Text(
                '\nClick button to generate list of your following accounts.\nAccount info and Bot-like score will be printed\nThe lower the score, the more unlikely it is a bot account',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      Color.fromARGB(255, 11, 71, 120)),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  )),
                ),
                onPressed: () => runSystem(),
                //onPressed: () => fetchAPI(),
                child: Padding(
                  padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: Text(
                    'Get a list of following accounts',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 8.0),
              StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("account_info")
                      .doc("TFoYzXh53iONvzBqrLp9eKJIz343")
                      .collection('following_ids')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Text('DB cannot be reached');
                    } else {
                      //print(snapshot.data!.docs.length);
                      return Expanded(
                          child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                    title: buildCard(
                                  context,
                                  snapshot.data!.docs[index]['id_str'],
                                  snapshot.data!.docs[index]['screenName'],
                                  snapshot.data!.docs[index]['botScore'],
                                ));
                              }));
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }
}

Widget buildCard(
  BuildContext context,
  String idStr,
  String screenName,
  String name,
) {
  return GestureDetector(
    child: Card(
      color: Color.fromARGB(255, 148, 246, 255),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 1,
      child: Container(
        height: 100,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          children: <Widget>[
            AutoSizeText(
              '@' + screenName,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              maxLines: 1,
            ),
            Expanded(
              child: Container(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Twitter UID:  ",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        "Twitter Tag:",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        "BotoMeterScore: ",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      AutoSizeText(
                        idStr,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                        maxLines: 1,
                      ),
                      AutoSizeText(
                        screenName,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                        maxLines: 1,
                      ),
                      AutoSizeText(
                        name,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
