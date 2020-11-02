import 'dart:convert';

import '../globals.dart';

class Rooms {
  static Map<String, Map<String, String>> _rooms = {};

  // Map keys
  static const _roomNameKey = 'roomName';

  // SharedPreferences key
  static const _storageKey = 'rooms';

  static void add(String roomId, String roomName) {
    _rooms.addAll({
      roomId: {_roomNameKey: roomName}
    });
    save();
  }

  static Map<String, Map<String, String>> get rooms => _rooms;

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
