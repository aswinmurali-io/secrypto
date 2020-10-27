import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import 'rooms.dart';

final Uuid uuid = Uuid();

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

@immutable
abstract class FirestoreDocument {
  DocumentSnapshot get snapshot;
  DocumentReference get document => snapshot?.reference;

  static String encode(String from) => base64.encode(utf8.encode(from));
  static String decode(String cipher) => utf8.decode(base64.decode(cipher));

  Future<void> update(Map<String, dynamic> data) => document.set(data);
  Future<void> delete() => snapshot.reference.delete();
}

class Contact with FirestoreDocument {
  final snapshot;
  Contact.fromSnapshot(this.snapshot) : assert(snapshot != null);

  static const NameKey = 'name';
  static const TimeKey = 'time';
  static const LastSendMsgKey = 'lastSendMsg';
  static const ProfileURLKey = 'profileURL';

  String get name => snapshot[NameKey];
  String get time => snapshot[TimeKey];
  String get lastSendMsg => snapshot[LastSendMsgKey];
  String get profileURL => snapshot[ProfileURLKey];

  static CollectionReference get collection => FirebaseFirestore.instance.collection("users");

  static Future<void> add(
      {@required String name, @required String time, @required String lastSendMsg, @required String profileURL}) async {
    String deviceId = (await SharedPreferences.getInstance()).getString(Session.UidKey);
    assert(deviceId != null);
    await collection.doc(deviceId).collection(deviceId).doc(name).set({
      NameKey: name,
      TimeKey: time,
      LastSendMsgKey: lastSendMsg,
      ProfileURLKey: profileURL,
    });
  }

  static void remove({String name}) async => await collection.doc(name).set(null);

  static List<Contact> contactFromQuery(QuerySnapshot querySnapshot) =>
      querySnapshot.docs.map((contact) => Contact.fromSnapshot(contact)).toList();

  static Stream<List<Contact>> get all => collection.snapshots().map(contactFromQuery);
}
