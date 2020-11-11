import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../partials/user.dart';
import '../partials/widgets/custom_textfield.dart';
import '../routes/contact_list.dart';

Future<bool> autoLogin() async {
  await Firebase.initializeApp();
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  if (User.checkIfloggedIn)
    return true;
  else if (await User.getEmail != null) {
    User.signin();
    return true;
  }
  return false;
}

class LoginRoute extends StatefulWidget {
  LoginRoute({Key key}) : super(key: key);

  @override
  _LoginRouteState createState() => _LoginRouteState();
}

class _LoginRouteState extends State<LoginRoute> {
  bool _register = true;
  String _userName;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        future: autoLogin(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          final userLoggedIn = snapshot.data;
          if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
            if (!userLoggedIn)
              return Scaffold(
                appBar: AppBar(title: Text("Secrypto")),
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
                        padding: const EdgeInsets.fromLTRB(50, 30, 50, 35),
                        child: SecryptoTextField(
                          prefixIconData: Icons.person,
                          hintText: "Enter your name",
                          obscureText: false,
                          onChanged: (value) => _userName = value,
                        ),
                      ),
                      SizedBox(
                        width: 155.0,
                        height: 35.0,
                        child: RaisedButton.icon(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(17.0),
                          ),
                          label: Text(
                            (_register) ? "Register" : "Registering...",
                            style: TextStyle(color: Colors.white),
                          ),
                          icon: (_register)
                              ? Icon(Icons.app_registration, color: Colors.white)
                              : Transform.scale(
                                  scale: 0.6,
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  )),
                          color: Colors.orange[300],
                          onPressed: (_register)
                              ? () async {
                                  if (_userName != null) {
                                    setState(() => _register = !_register);
                                    await User.signup().then((_) {
                                      User.setName(_userName);
                                      Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(builder: (context) => ContactListRoute()),
                                      );
                                    });
                                  }
                                }
                              : null,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            return ContactListRoute();
          } else
            return Scaffold(
                body: Center(
              child: Text("Secrypto", style: Theme.of(context).textTheme.headline5),
            ));
        });
  }
}
