import 'package:flutter/material.dart';

class AccountInfo {
  String idStr;
  String screenName;

  AccountInfo({
    required this.idStr,
    required this.screenName,
  });

  Map<String, dynamic> mapUsers() {
    return {
      'id_str': idStr,
      'screen_name': screenName,
    };
  }

  AccountInfo.fromFirestore(Map<String, dynamic> firestore)
      : idStr = firestore['id_str'],
        screenName = firestore['screen_name'];
}
