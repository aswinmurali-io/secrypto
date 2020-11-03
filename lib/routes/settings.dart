import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../globals.dart';
import '../partials/accessibility.dart';
import '../partials/settings.dart';
import '../partials/user.dart';

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
  bool sendSos;
  bool darkModeEnabled;

  String dpUrl;
  String userGeneratedEmail;
  String userName;

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  void initAsync() async {
    shouldNarrate = await SecryptoSettings.shouldNarrate();
    shouldMorseCode = await SecryptoSettings.shouldMorseCode();
    shouldReduceNetworkUsage = await SecryptoSettings.shouldReducedNetorkUsage();
    sendSos = await SecryptoSettings.shouldSosMorseFlash();
    userGeneratedEmail = await User.getEmail;
    userName = await User.getName();
    darkModeEnabled = await SecryptoSettings.shouldDarkMode();
    setState(() => {shouldNarrate, shouldMorseCode, shouldReduceNetworkUsage, userGeneratedEmail});

    // This will take time so we set state later on
    try {
      dpUrl = await User.getDp;
    } catch (error) {
      switch (error.code) {
        case 'object-not-found':
          print("Error at initAsync() Display picture not avaliable!");
          break;
        default:
          print("Error at initAsync() $error");
          break;
      }
    }
    setState(() => dpUrl);
  }

  @override
  void initState() {
    initAsync();

    Timer.periodic(Duration(seconds: 4), (Timer t) async {
      if (await SecryptoSettings.shouldSosMorseFlash() ?? false) await morseCodeFlash("SOS");
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await msgAccesiblity("Back to contacts");
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
                  padding: const EdgeInsets.fromLTRB(0, 15, 15, 25),
                  child: ListTile(
                      title: Text(userName ?? '...'),
                      subtitle: Text(userGeneratedEmail ?? "..."),
                      isThreeLine: true,
                      leading: Hero(
                        tag: 'me',
                        child: Material(
                          child: CircleAvatar(
                            radius: 40.0,
                            backgroundColor: Colors.grey,
                            child: InkWell(
                              onTap: () async {
                                setState(() => dpUrl = null);
                                await User.uploadDp();
                                setState(() => dpUrl);
                              },
                              child: ClipOval(
                                child: CachedNetworkImage(
                                  imageUrl: dpUrl ?? placeHolderDp,
                                  placeholder: (context, url) => CircularProgressIndicator(),
                                  errorWidget: (context, url, error) => Icon(Icons.error),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      onTap: () {}),
                ),
                ListTile(
                    title: Text("Mirror Account"),
                    subtitle: Text("Mirror account key via QR code into another device."),
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
                        await msgAccesiblity("Narrate Messages $value");
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
                        await msgAccesiblity("Use Morse Code $value");
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
                        await msgAccesiblity("Reduce Network Usage $value");
                      },
                    ),
                    onTap: () {}),
                ListTile(
                    title: Text("Send SOS Flash"),
                    subtitle: Text("Your mobile phone will send a SOS morse code flash signal"),
                    isThreeLine: true,
                    trailing: Switch(
                      value: sendSos ?? false,
                      onChanged: (value) async {
                        setState(() => sendSos = value);
                        await msgAccesiblity("Send SOS Flash $value");
                        SecryptoSettings.enableSosMorseFlash(value);
                      },
                    ),
                    onTap: () {}),
                ListTile(
                    title: Text("Dark Mode"),
                    subtitle: Text("Toggle dark mode for this application."),
                    isThreeLine: true,
                    trailing: Switch(
                      value: darkModeEnabled ?? false,
                      onChanged: (value) async {
                        DynamicTheme.of(context).setBrightness(value ? Brightness.dark : Brightness.light);
                        setState(() => darkModeEnabled = value);
                        await msgAccesiblity("Dark Mode $value");
                        SecryptoSettings.enableDarkMode(value);
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
