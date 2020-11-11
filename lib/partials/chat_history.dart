import 'package:cloud_firestore/cloud_firestore.dart';

import '../globals.dart';

class ChatHistory {
  static const _msgKey = 'msg';
  static const _userIdKey = 'userId';
  static const _timestampKey = 'timestamp';

  static Stream<QuerySnapshot> msg(String roomId) =>
      db.collection(roomId).orderBy(_timestampKey, descending: false).snapshots();

  static void send(String msg, String roomId) async => db.collection(roomId).add({
        _msgKey: msg,
        _userIdKey: auth.currentUser.uid,
        _timestampKey: FieldValue.serverTimestamp(),
      });

  static void remove(FieldValue timestamp, String roomId) async =>
      (await db.collection(roomId).where(_timestampKey, isEqualTo: timestamp).get()).docs.remove({
        _timestampKey: timestamp,
      });

  static Future<String> getDp(String roomId) async {
    try {
      return await cloud.ref(roomId).getDownloadURL();
    } catch (error) {
      if (error.code == 'object-not-found') print("No dp");
    }
    return null;
  }
}
