import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../globals.dart';
import '../partials/auth.dart';

import 'contact_list.dart';

class LoginRoute extends StatefulWidget {
  LoginRoute({Key key}) : super(key: key);

  @override
  _LoginRouteState createState() => _LoginRouteState();
}

Future<String> autoLogin(BuildContext context) async {
  String userName = (await storage).getString('userName');

  if (auth.currentUser == null)
    auth.signInWithEmailAndPassword(email: null, password: uuid.v5(Uuid.NAMESPACE_X500, userName));
  if (await Session.checkAuth() != null)
    Future.delayed(Duration.zero, () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => ContactListRoute(),
        ),
      );
    });
  await Firebase.initializeApp().then((_) => FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError);
  await Future.delayed(Duration(seconds: 2));
  return "TOKEN";
}

class _LoginRouteState extends State<LoginRoute> {
  bool _registerButtonStatus = true;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        future: autoLogin(context),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
              appBar: AppBar(
                title: Text("Secrypto"),
              ),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Hello there 🖐",
                      style: Theme.of(context).textTheme.headline6,
                      textAlign: TextAlign.center,
                    ),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(children: [
                        TextSpan(
                            text: "\nSecrypto",
                            style: TextStyle(color: Colors.blueGrey[400], fontWeight: FontWeight.bold)),
                        TextSpan(
                            text: " is an end-to-end 🔓 encrypted chat service with",
                            style: TextStyle(color: Colors.blueGrey[400])),
                        TextSpan(
                            text: " accessiblity",
                            style: TextStyle(color: Colors.blueGrey[400], fontWeight: FontWeight.bold)),
                        TextSpan(text: " for", style: TextStyle(color: Colors.blueGrey[400])),
                        TextSpan(
                            text: " differentially-abled people",
                            style: TextStyle(color: Colors.blueGrey[400], fontWeight: FontWeight.bold)),
                        TextSpan(text: ".", style: TextStyle(color: Colors.blueGrey[400])),
                      ]),
                    ),
                    Padding(
                        padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                        child: SizedBox(
                          width: 155.0,
                          height: 35.0,
                          child: RaisedButton.icon(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(17.0),
                            ),
                            label: Text((_registerButtonStatus) ? "Register" : "Registering...",
                                style: TextStyle(
                                  color: Colors.white,
                                )),
                            icon: (_registerButtonStatus)
                                ? Icon(
                                    Icons.app_registration,
                                    color: Colors.white,
                                  )
                                : Transform.scale(
                                    scale: 0.6,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  ),
                            color: Colors.orange[300],
                            onPressed: (_registerButtonStatus)
                                ? () {
                                    setState(() {
                                      return _registerButtonStatus = !_registerButtonStatus;
                                    });
                                    Session.auth();
                                    Future.delayed(Duration(milliseconds: 200)).then(
                                      (_) => Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(builder: (context) => ContactListRoute()),
                                      ),
                                    );
                                  }
                                : null,
                          ),
                        )),
                  ],
                ),
              ),
            );
          } else
            return Scaffold(
                body: Center(
              child: Text("Secrypto", style: Theme.of(context).textTheme.headline5),
            ));
        });
  }
}
