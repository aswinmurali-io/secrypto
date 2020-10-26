import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../partials/custom_textfield.dart';
import '../partials/msg_bubble.dart';

class ChatWindow extends StatefulWidget {
  ChatWindow({Key key}) : super(key: key);

  @override
  _ChatWindowState createState() => _ChatWindowState();
}

class _ChatWindowState extends State<ChatWindow> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      for (int i = 0; i < 5; i++) SecryptoChatBubble(msg: "Hi", isReceiver: true, isNarrated: true),
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
                            obscureText: false,
                            suffixIconData: Icons.attach_file,
                            suffixIconOnTap: () {},
                            hintText: "Type your message",
                            prefixIconData: Icons.mms)),
                    Expanded(
                        flex: 1,
                        child: Padding(
                            padding: const EdgeInsets.fromLTRB(7, 0, 0, 0),
                            child: RawMaterialButton(
                                onPressed: () {},
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
    );
  }
}
