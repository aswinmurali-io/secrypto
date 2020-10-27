import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatHistory {
  static Map<int, Map<String, Object>> _chats = {};
  static int _msgCount = 0;
  static final storage = SharedPreferences.getInstance();
  static final firebase = FirebaseFirestore.instance;

  static void init() async {
    _chats.clear();
    _msgCount = (await storage).getInt("msgCount") ?? 0;
  }

  static Future<Map<int, QueryDocumentSnapshot>> syncChatHistory(String roomId) async {
    return Map<int, QueryDocumentSnapshot>.from((await firebase.collection(roomId).get()).docs.asMap());
  }

  static Map<int, Map<String, Object>> getChatHistory() => _chats;

  static void putMsg(String msg, String time, bool isReceiver, String roomId) async {
    _chats.addAll({
      _msgCount++: {
        "msg": msg,
        "time": time,
        "isReceiver": isReceiver,
        "roomId": roomId,
      }
    });
    (await storage).setInt("msgCount", _msgCount ?? 0);
    final uid = (await storage).getString("UID");
    firebase.collection(roomId).doc(_msgCount.toString()).set({"msg": msg, "userId": uid});
  }


  
}
