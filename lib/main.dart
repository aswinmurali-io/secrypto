import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:secrypto/partials/settings.dart';

import 'globals.dart';
import 'routes/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  globalBrightness = (await SecryptoSettings.shouldDarkMode()) ? Brightness.dark : Brightness.light;
  runApp(Secrypto());
}

class Secrypto extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DynamicTheme(
        defaultBrightness: globalBrightness,
        data: (brightness) {
          final primaryColor = (brightness == Brightness.light) ? Colors.blueGrey : Colors.blueGrey[100];
          final primaryStatuBarColor = (brightness == Brightness.light) ? Colors.blueGrey : Colors.transparent;

          SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
              statusBarColor: primaryStatuBarColor,
              statusBarBrightness: Brightness.dark,
              statusBarIconBrightness: Brightness.dark));
          return ThemeData(
              brightness: brightness,
              primarySwatch: Colors.blueGrey,
              visualDensity: VisualDensity.adaptivePlatformDensity,
              textTheme: TextTheme(
                  headline1: TextStyle(color: primaryColor),
                  headline6: GoogleFonts.openSans(
                    color: primaryColor,
                    fontWeight: FontWeight.w900,
                    fontSize: 30.0,
                  ),
                  headline5: GoogleFonts.openSans(
                    color: primaryColor,
                    fontWeight: FontWeight.w900,
                    fontSize: 40.0,
                  )),
              floatingActionButtonTheme: FloatingActionButtonThemeData(
                backgroundColor: primaryColor,
              ),
              appBarTheme: AppBarTheme(
                  iconTheme: IconThemeData(color: primaryColor),
                  color: Colors.transparent,
                  elevation: 0.0,
                  textTheme: TextTheme(
                      headline6: GoogleFonts.openSans(
                    color: primaryColor,
                    fontWeight: FontWeight.w900,
                    fontSize: 30.0,
                  ))));
        },
        themedWidgetBuilder: (context, theme) {
          return MaterialApp(
            title: 'Secrypto',
            theme: theme,
            home: LoginRoute(),
            debugShowCheckedModeBanner: false,
          );
        });
  }
}
