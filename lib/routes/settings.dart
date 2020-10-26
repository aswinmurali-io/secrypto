import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:secrypto/partials/settings_logic.dart';

// TODO: add logic for profile dp and transfer account

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
    shouldNarrate = await Settings.shouldNarrate();
    shouldMorseCode = await Settings.shouldMorseCode();
    shouldReduceNetworkUsage = await Settings.shouldReducedNetorkUsage();
    setState(() {});
  }

  @override
  void initState() {
    initAsync();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    title: Text("Person Name"),
                    leading: CircleAvatar(
                      radius: 40.0,
                      child: ClipOval(
                        child: Image.network(''),
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
                    onChanged: (value) {
                      setState(() => shouldNarrate = value);
                      Settings.enableNarration(value);
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
                    onChanged: (value) {
                      setState(() => shouldMorseCode = value);
                      Settings.enableMorseCode(value);
                    },
                  ),
                  onTap: () {}),
              ListTile(
                  title: Text("Reduce Network Usage"),
                  subtitle: Text("This will reduce network fetch frequency in profile photo refresh and message sync."),
                  isThreeLine: true,
                  trailing: Switch(
                    value: shouldReduceNetworkUsage ?? false,
                    onChanged: (value) {
                      setState(() => shouldReduceNetworkUsage = value);
                      Settings.enableReducedNetorkUsage(value);
                    },
                  ),
                  onTap: () {}),
            ],
          ),
        ),
      ),
    );
  }
}
