import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

final Uuid uuid = Uuid();

class Session {
  static Future<String> generateDeviceID() async {
    final String uid = uuid.v4();
    final storage = await SharedPreferences.getInstance();
    storage.setString("UID", uid);
    return uid;
  }

  static void auth() async {
    final storage = await SharedPreferences.getInstance();
    String uid = storage.getString("UID");

    // Register device-based SecryptoID
    if (uid == null) {
      uid = await generateDeviceID();
    }
    
  }
}
