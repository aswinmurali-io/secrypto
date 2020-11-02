import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

final db = FirebaseFirestore.instance;
final auth = FirebaseAuth.instance;
final flutterTts = FlutterTts();
final uuid = Uuid();
final storage = SharedPreferences.getInstance();
