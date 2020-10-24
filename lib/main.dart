import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:secrypto/routes/login.dart';

import 'routes/contact_list.dart';

import 'package:vibrate/vibrate.dart';

void vvvv() async {
  Vibrate.vibrate();

  // Vibrate with pauses between each vibration
  final Iterable<Duration> pauses = [
    const Duration(milliseconds: 500),
    const Duration(milliseconds: 1000),
    const Duration(milliseconds: 500),
  ];
  // vibrate - sleep 0.5s - vibrate - sleep 1s - vibrate - sleep 0.5s - vibrate
  Vibrate.vibrateWithPauses(pauses);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  vvvv();
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  runApp(Secrypto());
}

class Secrypto extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Secrypto',
      theme: ThemeData(
          primarySwatch: Colors.blueGrey,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          textTheme: TextTheme(
            headline1: TextStyle(
              color: Colors.blueGrey,
            ),
            headline6: GoogleFonts.openSans(
              color: Colors.blueGrey,
              fontWeight: FontWeight.w900,
              fontSize: 30.0,
            ),
            headline5: GoogleFonts.openSans(
              color: Colors.blueGrey,
              fontWeight: FontWeight.w900,
              fontSize: 40.0,
            ),
          ),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: Colors.blueGrey,
          ),
          appBarTheme: AppBarTheme(
              iconTheme: IconThemeData(
                color: Colors.blueGrey,
              ),
              color: Colors.transparent,
              elevation: 0.0,
              textTheme: TextTheme(
                  headline6: GoogleFonts.openSans(
                color: Colors.blueGrey,
                fontWeight: FontWeight.w900,
                fontSize: 30.0,
              )))),
      home: LoginRoute(),
      debugShowCheckedModeBanner: false,
    );
  }
}
