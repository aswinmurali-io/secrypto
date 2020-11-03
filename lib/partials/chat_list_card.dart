import 'package:flutter/material.dart';
import 'package:secrypto/routes/chat_windows.dart';

import 'accessibility.dart';

class ChatList extends StatefulWidget {
  final String name;
  final String time;
  final String profileURL;
  final String lastSendMsg;
  final String roomId;

  ChatList({Key key, this.name, this.lastSendMsg, this.time, this.profileURL, this.roomId}) : super(key: key);

  @override
  _ChatListState createState() => _ChatListState(name, lastSendMsg, time, profileURL, roomId);
}

class _ChatListState extends State<ChatList> {
  final String name;
  final String time;
  final String profileURL;
  final String lastSendMsg;
  final String roomId;

  _ChatListState(this.name, this.lastSendMsg, this.time, this.profileURL, this.roomId);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Hero(
              tag: roomId,
              child: CircleAvatar(
                  radius: 30.0,
                  child: ClipOval(
                    child: (profileURL == null) ? Icon(Icons.portrait_rounded) : Image.network(profileURL),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 200,
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(time, style: TextStyle(color: Colors.blueGrey)),
                    ]),
                  ),
                  Padding(padding: const EdgeInsets.fromLTRB(0, 6, 0, 0), child: Text(lastSendMsg)),
                ],
              ),
            )
          ],
        ),
      ),
      onTap: () async {
        await msgAccesiblity(name);
        return Future.delayed(Duration(milliseconds: 200)).then(
          (_) => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ChatWindow(roomId: roomId, roomName: name),
          )),
        );
      },
    );
  }
}
