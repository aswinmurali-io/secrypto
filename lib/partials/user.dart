import 'dart:io';

import 'package:image_picker/image_picker.dart';

import '../globals.dart';

class User {
  static const _userEmailKey = 'userEmail';
  static const _userPasswordKey = 'userPassword';
  static const _userNameKey = 'userName';

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

  static Future<void> setName(String name) async {
    await db.collection('users').doc(auth.currentUser.uid).set({_userNameKey: name});
  }

  static Future<String> getName() async =>
      (await db.collection('users').doc(auth.currentUser.uid).get()).data()[_userNameKey];
  
  static Future<String> getOtherName(String uid) async =>
      (await db.collection('users').doc(uid).get()).data()[_userNameKey];

  static Future<void> signin() async {
    final generatedEmail = (await storage).getString(_userEmailKey);
    final userPassword = (await storage).getString(_userPasswordKey);

    await auth.signInWithEmailAndPassword(
      email: generatedEmail,
      password: userPassword,
    );
  }

  static Future<void> uploadDp() async {
    final pickedFile = await picker.getImage(
      source: ImageSource.camera,
      imageQuality: 80,
      preferredCameraDevice: CameraDevice.front,
    );

    if (pickedFile != null) {
      final imgFile = File(pickedFile.path);
      await cloud.ref(auth.currentUser.uid).putFile(imgFile);
    }
  }

  static Future<String> get getDp async {
    try {
      return await cloud.ref(auth.currentUser.uid).getDownloadURL();
    } catch (error) {
      if (error.code == 'object-not-found') print("No dp");
    }
    return null;
  }

  static Future<String> otherDp(String uid) async {
    try {
      print(await cloud.ref(uid).getDownloadURL());
      return await cloud.ref(uid).getDownloadURL();
    } catch (error) {
      if (error.code == 'object-not-found') print("No dp");
    }
    return null;
  }
}
