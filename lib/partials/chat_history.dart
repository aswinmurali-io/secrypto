import 'package:shared_preferences/shared_preferences.dart';

class ChatHistory {
  static Map<int, Map<String, Object>> _chats = {};
  static int _msgCount = 0;
  static final storage = SharedPreferences.getInstance();

  static void init() async {
    _msgCount = (await storage).getInt("msgCount");
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
    (await storage).setInt("msgCount", _msgCount);
  }
}
