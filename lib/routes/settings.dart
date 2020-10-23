import 'package:flutter/material.dart';
import 'package:secrypto/partials/settings_card.dart';

class SettingsRoute extends StatefulWidget {
  SettingsRoute({Key key}) : super(key: key);

  @override
  _SettingsRouteState createState() => _SettingsRouteState();
}

var settings = {
  "Profile": {
    "type": "button",
    "button-name": "Change",
    "on-tap": null,
  },
  "Dark Mode": {
    "type": "bool",
    "value": "false",
  },
  "Storage Usage": {
    "type": "route",
    "route": "storage-route",
  },
  "Network Usage": {},
  "Transfer Account": {}
};

class _SettingsRouteState extends State<SettingsRoute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: Scrollbar(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: <Widget>[],
          ),
        ),
      ),
    );
  }
}
