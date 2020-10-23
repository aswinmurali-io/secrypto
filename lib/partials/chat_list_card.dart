import 'package:flutter/material.dart';
import 'package:secrypto/routes/contact_list.dart';

class ChatListCard extends StatefulWidget {
  ChatListCard({Key key, this.name, this.lastSendMsg, this.time, this.profileURL}) : super(key: key);

  final String name;
  final String lastSendMsg;
  final String time;
  final String profileURL;

  @override
  _ChatListCardState createState() => _ChatListCardState(name, lastSendMsg, time, profileURL);
}

class _ChatListCardState extends State<ChatListCard> {
  final String name;
  final String lastSendMsg;
  final String time;
  final String profileURL;

  _ChatListCardState(this.name, this.lastSendMsg, this.time, this.profileURL);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30.0,
              child: ClipOval(
                child: (profileURL == null) ? Icon(Icons.portrait_rounded) : Image.network(profileURL),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 114,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(name ?? "Unknown",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            )),
                        Text(time ?? "No Time", style: TextStyle(color: Colors.blueGrey)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 6, 0, 0),
                    child: Text(lastSendMsg ?? "Last Sent Message"),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      onTap: () => Future.delayed(Duration(milliseconds: 200),).then(
        (value) => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ContactListRoute(),
          ),
        ),
      ),
    );
  }
}
