import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:secrypto/partials/accessibility.dart';
import 'package:secrypto/partials/user.dart';
import 'package:secrypto/partials/widgets/msg_bubble.dart';

import '../globals.dart';
import '../partials/chat_history.dart';
import '../partials/widgets/custom_textfield.dart';

class ChatWindow extends StatefulWidget {
  final String roomId;
  final String roomName;
  ChatWindow({Key key, this.roomId, this.roomName}) : super(key: key);

  @override
  _ChatWindowState createState() => _ChatWindowState(roomId, roomName);
}

class _ChatWindowState extends State<ChatWindow> with SingleTickerProviderStateMixin {
  final String roomId;
  final String roomName;

  String dpUrl;

  _ChatWindowState(this.roomId, this.roomName);

  final sendMsgInput = TextEditingController();

  void initAsync() async {
    dpUrl = await User.getDp;
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
          title: Row(
            children: [
              Hero(
                  tag: roomId,
                  child: CircleAvatar(
                      radius: 20.0,
                      backgroundColor: Colors.grey,
                      child: ClipOval(
                          child: Material(
                              child: InkWell(
                                  onTap: () {},
                                  child: CachedNetworkImage(
                                    imageUrl: dpUrl ?? placeHolderDp,
                                    placeholder: (context, url) => CircularProgressIndicator(),
                                    errorWidget: (context, url, error) => Icon(Icons.error),
                                  )))))),
              Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: SizedBox(
                      width: 260,
                      child: Text(
                        roomName ?? 'Chat',
                        overflow: TextOverflow.ellipsis,
                      ))),
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
                        child: StreamBuilder<QuerySnapshot>(
                            stream: ChatHistory.msg(roomId),
                            builder: (context, snapshot) {
                              if (snapshot.data == null) return LinearProgressIndicator();
                              return Column(
                                children: snapshot.data.docs.map((data) {
                                  return SecryptoChatBubble(
                                    msg: data['msg'],
                                    isReceiver: data['userId'] != auth.currentUser.uid,
                                  );
                                }).toList(),
                              );
                            })),
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
                              prefixIconData: Icons.mail)),
                      Expanded(
                          flex: 1,
                          child: Padding(
                              padding: const EdgeInsets.fromLTRB(7, 0, 0, 0),
                              child: RawMaterialButton(
                                  onPressed: () async {
                                    if (sendMsgInput.text != '' || sendMsgInput.text == ' ') {
                                      ChatHistory.send(sendMsgInput.text, roomId);
                                      setState(() => null);
                                      sendMsgInput.text = '';
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
