import 'package:shared_preferences/shared_preferences.dart';

import '../globals.dart';
import 'rooms.dart';

class Session {
  static const UidKey = 'UID';

  static Future<String> generateDeviceID() async {
    final String uid = uuid.v4();
    final storage = await SharedPreferences.getInstance();
    storage.setString(UidKey, uid);
    return uid;
  }

  static Future<String> auth() async {
    final storage = await SharedPreferences.getInstance();
    String uid = storage.getString(UidKey);

    // Register device-based SecryptoID
    if (uid == null) uid = await generateDeviceID();
    return uid;
  }

  static Future<String> checkAuth() async {
    final storage = await SharedPreferences.getInstance();
    String uid = storage.getString(UidKey);
    return uid;
  }

  static void enterRoom(
      {String generatedSessionCode, String roomName, String lastSendMsg, String profileUrl, String time}) async {
    Rooms.insert(generatedSessionCode, roomName ?? "Untitled", lastSendMsg ?? "You just joined!", profileUrl ?? "",
        time ?? "New");
  }
}
