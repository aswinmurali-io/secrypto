import 'dart:io';

import 'package:image_picker/image_picker.dart';
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

class User {
  static const _userEmailKey = 'userEmail';
  static const _userPasswordKey = 'userPassword';

  static bool get checkIfloggedIn => auth.currentUser != null;

  static Future<void> signup() async {
    final userId = uuid.v4();
    final userPassword = uuid.v4();
    final generatedEmail = '$userId@secrypto.com';

    (await storage).setString(_userEmailKey, generatedEmail);
    (await storage).setString(_userPasswordKey, userPassword);

    await auth.createUserWithEmailAndPassword(
      email: generatedEmail,
      password: userPassword,
    );
  }


  static Future<String> get getEmail async => (await storage).getString(_userEmailKey);

  static Future<void> signin() async {
    final generatedEmail = (await storage).getString(_userEmailKey);
    final userPassword = (await storage).getString(_userPasswordKey);

    await auth.signInWithEmailAndPassword(
      email: generatedEmail,
      password: userPassword,
    );
  }

  static Future<void> uploadDp() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    if (pickedFile != null) {
      final imgFile = File(pickedFile.path);
      await cloud.ref(auth.currentUser.uid).putFile(imgFile);
    }
  }

  static Future<String> getDp() async {
    try {
      await cloud.ref(auth.currentUser.uid).getDownloadURL();
    } catch (e) {
      print(e);
    }
    return 'http://www.gravatar.com/avatar/3b3be63a4c2a439b013787725dfce802?d=identicon';
  }
}
