import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'routes/contact_list.dart';
import 'routes/login.dart';

void main() => runApp(Secrypto());

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
      home: ContactList(),
      debugShowCheckedModeBanner: false,
    );
  }
}
