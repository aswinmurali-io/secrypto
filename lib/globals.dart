import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

final auth = FirebaseAuth.instance;
final cloud = FirebaseStorage.instance;
final db = FirebaseFirestore.instance;
final picker = ImagePicker();
final placeHolderDp = 'http://www.gravatar.com/avatar/3b3be63a4c2a439b013787725dfce802?d=identicon';
final storage = SharedPreferences.getInstance();
final tTs = FlutterTts();
final uuid = Uuid();

Brightness globalBrightness  = Brightness.light;
