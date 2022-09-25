import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  DatabaseService({required this.uid});
  final CollectionReference collection =
      FirebaseFirestore.instance.collection('users');
  Future updateUserData(String idStr, String name, String screenName) async {
    return await collection
        .doc(uid)
        .set({'id_str': idStr, 'name': name, 'screen_name': screenName});
  }
}
