import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../globals.dart';
import '../partials/settings.dart';

// TODO: add logic for profile dp and transfer account
// TODO: remove qr code

class SettingsRoute extends StatefulWidget {
  SettingsRoute({Key key}) : super(key: key);

  @override
  _SettingsRouteState createState() => _SettingsRouteState();
}

class _SettingsRouteState extends State<SettingsRoute> {
  bool shouldNarrate;
  bool shouldMorseCode;
  bool shouldReduceNetworkUsage;

  void initAsync() async {
    shouldNarrate = await SecryptoSettings.shouldNarrate();
    shouldMorseCode = await SecryptoSettings.shouldMorseCode();
    shouldReduceNetworkUsage = await SecryptoSettings.shouldReducedNetorkUsage();
    setState(() {});
  }

  @override
  void initState() {
    initAsync();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (await SecryptoSettings.shouldNarrate()) tTs.speak("Back to contacts");
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Settings"),
        ),
        body: CupertinoScrollbar(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 15, 0, 25),
                  child: ListTile(
                      title: Text("Aswin"),
                      leading: CircleAvatar(
                        radius: 40.0,
                        child: ClipOval(
                          child: Container(), //Image.network(''),
                        ),
                      ),
                      onTap: () {}),
                ),
                ListTile(
                    title: Text("Transfer Account"),
                    subtitle: Text("Transfer account key via QR code into web browser."),
                    onTap: () {}),
                ListTile(
                    title: Text("Narrate Messages"),
                    subtitle: Text("By enabling this all the incoming and outgoing messages are read by the device."),
                    isThreeLine: true,
                    trailing: Switch(
                      value: shouldNarrate ?? false,
                      onChanged: (value) async {
                        setState(() => shouldNarrate = value);
                        SecryptoSettings.enableNarration(value);
                        tTs.speak("Narrate Messages $value");
                      },
                    ),
                    onTap: () {}),
                ListTile(
                    title: Text("Use Morse Code"),
                    subtitle:
                        Text("By enabling this all the incoming and outgoing messages are send via vibration pattern."),
                    isThreeLine: true,
                    trailing: Switch(
                      value: shouldMorseCode ?? false,
                      onChanged: (value) async {
                        setState(() => shouldMorseCode = value);
                        SecryptoSettings.enableMorseCode(value);
                        if (await SecryptoSettings.shouldNarrate()) tTs.speak("Use Morse Code $value");
                      },
                    ),
                    onTap: () {}),
                ListTile(
                    title: Text("Reduce Network Usage"),
                    subtitle:
                        Text("This will reduce network fetch frequency in profile photo refresh and message sync."),
                    isThreeLine: true,
                    trailing: Switch(
                      value: shouldReduceNetworkUsage ?? false,
                      onChanged: (value) async {
                        setState(() => shouldReduceNetworkUsage = value);
                        SecryptoSettings.enableReducedNetorkUsage(value);
                        if (await SecryptoSettings.shouldNarrate()) tTs.speak("Reduce Network Usage $value");
                      },
                    ),
                    onTap: () {}),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
