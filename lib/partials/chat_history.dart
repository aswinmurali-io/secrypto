import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:secrypto/partials/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../globals.dart';

class ChatHistory {
  static Map<int, Map<String, Object>> _chats = {};
  static int _msgCount = 0;

  static void init() async {
    _chats.clear();
    _msgCount = (await storage).getInt("msgCount") ?? 0;
  }

  static Future<Map<int, QueryDocumentSnapshot>> syncChatHistory(String roomId) async {
    return Map<int, QueryDocumentSnapshot>.from((await db.collection(roomId).get()).docs.asMap());
  }

  static Map<int, Map<String, Object>> getChatHistory() => _chats;

  static void send(String msg, String roomId) {
    db.collection(roomId).doc(_msgCount.toString()).set({
      "msg": msg,
      "userId": auth.currentUser.uid,
      "timestamp": FieldValue.serverTimestamp(),
    });
  }
}
