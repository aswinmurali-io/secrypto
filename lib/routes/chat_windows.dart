import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:secrypto/partials/chat_history.dart';

import 'package:intl/intl.dart';
import 'package:secrypto/partials/settings_logic.dart';

import '../partials/custom_textfield.dart';
import '../partials/msg_bubble.dart';

class ChatWindow extends StatefulWidget {
  ChatWindow({Key key}) : super(key: key);

  @override
  _ChatWindowState createState() => _ChatWindowState();
}

class _ChatWindowState extends State<ChatWindow> with SingleTickerProviderStateMixin {
  final sendMsgInput = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final chatHistory = ChatHistory.getChatHistory();
    final chatHistoryKeys = chatHistory.keys.toList();
    String buffer;

    return WillPopScope(
      onWillPop: () async {
        if (await Settings.shouldNarrate()) flutterTts.speak("Back to contacts");
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              CircleAvatar(
                  child: ClipOval(
                      child: InkWell(
                    onTap: () {},
                    child: Image.network(
                        'https://images-ext-1.discordapp.net/external/D4rWYQqsn8UnHC5u_rUDzsrKAkAl64FlPW8aqdPzLA0/%3Fixlib%3Drb-1.2.1%26auto%3Dformat%26fit%3Dcrop%26w%3D500%26q%3D60/https/images.unsplash.com/photo-1498837167922-ddd27525d352'),
                  )),
                  radius: 20.0),
              Padding(padding: const EdgeInsets.fromLTRB(10, 0, 0, 0), child: Text("Aswin")),
            ],
          ),
          actions: [],
        ),
        body: Container(
          height: MediaQuery.of(context).size.height / 1.13,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: CupertinoScrollbar(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    reverse: true,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(children: [
                        for (int chatId in chatHistoryKeys)
                          SecryptoChatBubble(
                            msg: (() {
                              final msg = chatHistory[chatId]["msg"];
                              buffer = msg;
                              return msg;
                            }()),
                            isReceiver: chatHistory[chatId]["isReceiver"],
                          ),
                      ]),
                    ),
                  ),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.fromLTRB(10, 20, 10, 5),
                  child: Row(
                    children: [
                      Expanded(
                          flex: 5,
                          child: SecryptoTextField(
                              controller: sendMsgInput,
                              obscureText: false,
                              hintText: "Type your message",
                              prefixIconData: Icons.mms)),
                      Expanded(
                          flex: 1,
                          child: Padding(
                              padding: const EdgeInsets.fromLTRB(7, 0, 0, 0),
                              child: RawMaterialButton(
                                  onPressed: () async {
                                    if (sendMsgInput.text != '' || sendMsgInput.text == ' ') {
                                      final DateTime now = DateTime.now();
                                      final DateFormat formatter = DateFormat('yyyy-MM-dd');
                                      final String formatted = formatter.format(now);
                                      if (await Settings.shouldNarrate()) flutterTts.speak(sendMsgInput.text);
                                      buffer = sendMsgInput.text;
                                      setState(() {
                                        ChatHistory.putMsg(sendMsgInput.text, formatted, false, "0");
                                      });
                                      sendMsgInput.text = '';
                                    } else {
                                      if (await Settings.shouldNarrate()) flutterTts.speak(buffer ?? "Nothing");
                                    }
                                  },
                                  elevation: 2.0,
                                  fillColor: Colors.blueGrey,
                                  child: Icon(Icons.send, color: Colors.white),
                                  padding: EdgeInsets.all(15),
                                  shape: CircleBorder()))),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
