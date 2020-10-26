import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:secrypto/partials/custom_textfield.dart';

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
        title: Text("Contact Name"),
        actions: [],
      ),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height / 1.13,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.max,
                children: [
                  for (int i = 0; i < 10; i++)
                    Bubble(
                      margin: BubbleEdges.only(top: 10),
                      alignment: Alignment.topRight,
                      nipWidth: 8,
                      nipHeight: 15,
                      nip: BubbleNip.rightTop,
                      color: Color.fromRGBO(225, 255, 199, 1.0),
                      child: Text('Hello, World!', textAlign: TextAlign.right),
                    ),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
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
          ),
        ),
      ),
    );
  }
}
