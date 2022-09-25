class User {
  final String uid;

  User({required this.uid});
}

class UserData {
  final String uid;
  final String idStr;
  final String screenName;

  UserData({required this.uid, required this.idStr, required this.screenName});
  //get the data for current user
  UserData.fromFirestore(Map<String, dynamic> firestore, this.uid)
      : idStr = firestore['id_str'],
        screenName = firestore['screen_name'];
}
