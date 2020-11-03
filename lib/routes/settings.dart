import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:secrypto/partials/accessibility.dart';
import 'package:secrypto/partials/user.dart';

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

  String dpUrl;
  String userGeneratedEmail;

  void initAsync() async {
    shouldNarrate = await SecryptoSettings.shouldNarrate();
    shouldMorseCode = await SecryptoSettings.shouldMorseCode();
    shouldReduceNetworkUsage = await SecryptoSettings.shouldReducedNetorkUsage();
    userGeneratedEmail = await User.getEmail;
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
                      title: Text("User Name"),
                      subtitle: Text(userGeneratedEmail ?? "Email"),
                      isThreeLine: true,
                      leading: CircleAvatar(
                        radius: 40.0,
                        backgroundColor: Colors.transparent,
                        child: InkWell(
                          onTap: () async {
                            setState(() => dpUrl = null);
                            await User.uploadDp();
                            setState(() => dpUrl);
                          },
                          child: Image.network(
                            dpUrl ?? placeHolderDp,
                            fit: BoxFit.fill,
                            loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes
                                      : null,
                                ),
                              );
                            },
                          ),
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
                      onChanged: (value) async{
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
