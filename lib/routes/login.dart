import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();

class LoginRoute extends StatefulWidget {
  LoginRoute({Key key}) : super(key: key);

  @override
  _LoginRouteState createState() => _LoginRouteState();
}

Future<String> autoLogin() async {
  await Future.delayed(Duration(seconds: 2));
  return "TOKEN";
}

// uuid.v5(Uuid.NAMESPACE_URL, 'www.test.com');

class _LoginRouteState extends State<LoginRoute> {
  bool _registerButtonStatus = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Secrypto")),
      body: FutureBuilder<String>(
          future: autoLogin(),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (snapshot.hasData) {
              return Center(
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
                            style: TextStyle(
                              color: Colors.blueGrey[400],
                              fontWeight: FontWeight.bold,
                            )),
                        TextSpan(
                            text: " is an end-to-end 🔓 encrypted chat service with",
                            style: TextStyle(
                              color: Colors.blueGrey[400],
                            )),
                        TextSpan(
                            text: " accessiblity",
                            style: TextStyle(
                              color: Colors.blueGrey[400],
                              fontWeight: FontWeight.bold,
                            )),
                        TextSpan(
                            text: " for",
                            style: TextStyle(
                              color: Colors.blueGrey[400],
                            )),
                        TextSpan(
                            text: " differentially-abled people",
                            style: TextStyle(
                              color: Colors.blueGrey[400],
                              fontWeight: FontWeight.bold,
                            )),
                        TextSpan(
                            text: ".",
                            style: TextStyle(
                              color: Colors.blueGrey[400],
                            )),
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
                            color: Colors.amber,
                            onPressed: (_registerButtonStatus)
                                ? () {
                                    setState(() {
                                      return _registerButtonStatus = !_registerButtonStatus;
                                    });
                                  }
                                : null,
                          ),
                        )),
                  ],
                ),
              );
            } else
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                ),
              );
          }),
    );
  }
}
