import 'dart:convert';

import '../globals.dart';

class Rooms {
  static Map<String, Map<String, String>> _rooms = {};

  // Map keys
  static const _roomNameKey = 'roomName';
  static const _lastSendMsgKey = 'lastSendMsg';
  static const _timeKey = 'time';

  // SharedPreferences key
  static const _storageKey = 'rooms';

  static void add(String roomId, String roomName, String lastSendMsg, String profileUrl) {
    _rooms.addAll({
      roomId: {
        _roomNameKey: roomName,
        _lastSendMsgKey: lastSendMsg,
        _timeKey: 'New!',
      }
    });
    save();
  }

  static Map<String, Map<String, String>> get() => _rooms;

  static void remove(String roomId) => _rooms.remove(roomId);

  static void save() async => (await storage).setString(_storageKey, jsonEncode(_rooms));

  static void load() async {
    final storedRoomConfig = (await storage).getString(_storageKey) ?? '{}';
    final roomStorage = jsonDecode(storedRoomConfig);
    Map.castFrom(roomStorage).forEach((key, value) {
      _rooms.addAll({key: Map<String, String>.from(value)});
    });
  }
}
