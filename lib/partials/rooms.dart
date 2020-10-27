import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Rooms {
  static Map<String, Map<String, String>> _rooms = {};

  // Map keys
  static const roomNameKey = 'roomName';
  static const lastSendMsgKey = 'lastSendMsg';
  static const profileUrlKey = 'profileUrl';
  static const timeKey = 'time';

  // SharedPreferences key
  static const storageKey = 'rooms';

  static void insert(String roomId, String roomName, String lastSendMsg, String profileUrl, String time) {
    _rooms.addAll({
      roomId: {
        roomNameKey: roomName,
        lastSendMsgKey: lastSendMsg,
        profileUrlKey: profileUrl,
        timeKey: time,
      }
    });
    save();
  }

  static Map<String, Map<String, String>> get() {
    return _rooms;
  }

  static void remove(String roomId) {
    _rooms.remove(roomId);
  }

  static void save() async {
    final storage = await SharedPreferences.getInstance();
    storage.setString(storageKey, jsonEncode(_rooms));
  }

  static void load() async {
    final storage = await SharedPreferences.getInstance();
    final Map roomStorage = jsonDecode(storage.getString(storageKey) ?? '{}');
    Map.castFrom(roomStorage).forEach((key, value) {
      _rooms.addAll({key: Map<String, String>.from(value)});
    });
    if (_rooms == null)
      _rooms = {
        "Nothing": {
          roomNameKey: "Nothing",
          lastSendMsgKey: "",
          profileUrlKey: "",
          timeKey: "",
        }
      };
  }
}
