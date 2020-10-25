import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:secrypto/partials/auth.dart';
import 'package:uuid/uuid.dart';

import 'custom_textfield.dart';

class SessionJoinDialog {
  static bool connectPressed = false;
  static final sessionCodeInputController = TextEditingController();

  static void connectSession(BuildContext context, setState) {
    setState(() => connectPressed = true);

    Future.delayed(Duration(seconds: 1), () {
      setState(() => connectPressed = false);
      Navigator.of(context).pop();
    });
  }

  static void pasteSession(BuildContext context, setState) async {
    ClipboardData data = await Clipboard.getData('text/plain');
    sessionCodeInputController.text = data.text;
    connectSession(context, setState);
  }

  static Future<void> render(BuildContext context) {
    return showGeneralDialog<void>(
        context: context,
        pageBuilder: (_, __, ___) => null,
        transitionDuration: Duration(milliseconds: 300),
        transitionBuilder: (context, anim1, anim2, child) {
          return Transform.scale(
            scale: Curves.easeInOutBack.transform(anim1.value),
            child: Opacity(
              opacity: anim1.value,
              child: StatefulBuilder(builder: (context, setState) {
                return AlertDialog(
                    title: Text('Connect with session code'),
                    content: SingleChildScrollView(
                      child: ListBody(
                        children: <Widget>[
                          const Text(
                              'Session code is how you can connect with other people to chat. Secrypto does not ask your phone number.'),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
                            child: SecryptoTextField(
                                obscureText: false,
                                prefixIconData: Icons.code,
                                suffixIconData: Icons.paste,
                                suffixIconOnTap: () => pasteSession(context, setState),
                                hintText: "Enter Session Code",
                                controller: sessionCodeInputController),
                          ),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      if (!connectPressed)
                        TextButton.icon(
                          label: Text('QR Code'),
                          icon: Icon(Icons.qr_code),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      TextButton.icon(
                        label:
                            (connectPressed) ? Text('Cancel', style: TextStyle(color: Colors.black38)) : Text('Cancel'),
                        icon: (connectPressed) ? Icon(Icons.cancel, color: Colors.black38) : Icon(Icons.cancel),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      TextButton.icon(
                          label: (connectPressed) ? Text('Connecting...') : Text('Join'),
                          icon: (connectPressed)
                              ? Transform.scale(scale: 0.7, child: CircularProgressIndicator())
                              : Icon(Icons.connect_without_contact),
                          onPressed: () => connectSession(context, setState)),
                    ]);
              }),
            ),
          );
        });
  }
}

class SessionAddDialog {
  static String validationStatusText;
  static final sessionCodeController = TextEditingController();
  static final sessionNameController = TextEditingController();

  static void connectSession(BuildContext context, setState) {
    if (sessionNameController.text == '') sessionNameController.text = 'Untitled';
    Session.enterRoom(generatedSessionCode: Uuid().v4(), roomName: sessionNameController.text);
    setState(() {});
    Future.delayed(Duration(seconds: 1), () {
      Navigator.of(context).pop();
    });
  }

  static void copySession(BuildContext context, setState) async {
    if (sessionCodeController.text != '')
      await Clipboard.setData(
        ClipboardData(text: sessionCodeController.text),
      );
  }

  static Future<void> render(BuildContext context) {
    sessionCodeController.text = Uuid().v4();
    return showGeneralDialog<void>(
        context: context,
        pageBuilder: (_, __, ___) => null,
        transitionDuration: Duration(milliseconds: 300),
        transitionBuilder: (context, anim1, anim2, child) {
          return Transform.scale(
            scale: Curves.easeInOutBack.transform(anim1.value),
            child: Opacity(
              opacity: anim1.value,
              child: StatefulBuilder(builder: (context, setState) {
                return AlertDialog(
                    title: Text('New session code'),
                    content: SingleChildScrollView(
                      child: ListBody(
                        children: <Widget>[
                          const Text(
                              'Enter a name for this session/contact/group. The session code is copied into your clipboard.'),
                          Padding(
                              padding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
                              child: SecryptoTextField(
                                  hintText: "Name",
                                  obscureText: false,
                                  prefixIconData: Icons.person,
                                  controller: sessionNameController)),
                          Padding(
                              padding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
                              child: SecryptoTextField(
                                  obscureText: false,
                                  hintText: "Session Code",
                                  prefixIconData: Icons.code,
                                  suffixIconData: Icons.copy,
                                  controller: sessionCodeController,
                                  suffixIconOnTap: () => copySession(context, setState))),
                          Padding(
                              padding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
                              child: Text(validationStatusText ?? '', style: TextStyle(color: Colors.red))),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      TextButton.icon(
                          label: Text('Make QR'),
                          icon: Icon(Icons.qr_code),
                          onPressed: () => Navigator.of(context).pop()),
                      TextButton.icon(
                          label: Text('Cancel'),
                          icon: Icon(Icons.cancel),
                          onPressed: () => Navigator.of(context).pop()),
                      TextButton.icon(
                          label: Text('OK'),
                          icon: Icon(Icons.done),
                          onPressed: () {
                            if (sessionNameController.text != '') return connectSession(context, setState);
                            setState(() => validationStatusText = 'Specify a name for the session');
                          }),
                    ]);
              }),
            ),
          );
        });
  }
}
