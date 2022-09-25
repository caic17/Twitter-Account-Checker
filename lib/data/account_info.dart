import 'package:flutter/material.dart';

class AccountInfo {
  String idStr;
  String screenName;
  String name;
  //String location;
  //String description;
  //String url;
  //String profileImageUrl;

  AccountInfo({
    required this.idStr,
    required this.screenName,
    required this.name,
    //required this.location,
    //required this.description,
    //required this.url,
    //required this.profileImageUrl
  });

  Map<String, dynamic> mapUsers() {
    return {
      'id_str': idStr,
      'screen_name': screenName,
      'name': name,
    };
  }

  AccountInfo.fromFirestore(Map<String, dynamic> firestore)
      : idStr = firestore['id_str'],
        screenName = firestore['screen_name'],
        name = firestore['name'];
}
