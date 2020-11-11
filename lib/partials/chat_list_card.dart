import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../globals.dart';
import '../routes/chat_windows.dart';
import 'accessibility.dart';
import 'chat_history.dart';

class ChatList extends StatefulWidget {
  final String name;
  final String time;
  final String lastSendMsg;
  final String roomId;

  ChatList({Key key, this.name, this.lastSendMsg, this.time, this.roomId}) : super(key: key);

  @override
  _ChatListState createState() => _ChatListState(name, lastSendMsg, time, roomId);
}

class _ChatListState extends State<ChatList> {
  final String name;
  final String time;
  final String lastSendMsg;
  final String roomId;

  String profileURL;

  _ChatListState(this.name, this.lastSendMsg, this.time, this.roomId);

  File _image;

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      await cloud.ref(roomId).putFile(_image);
      profileURL = await cloud.ref(roomId).getDownloadURL();
      setState(() => profileURL);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Hero(
              tag: roomId,
              child: Material(
                child: CircleAvatar(
                    radius: 30.0,
                    child: ClipOval(
                      child: profileURL != null
                          ? CachedNetworkImage(
                              imageUrl: profileURL,
                              width: 210,
                              fit: BoxFit.fill,
                              progressIndicatorBuilder: (context, url, progress) =>
                                  CircularProgressIndicator(value: progress.progress, backgroundColor: Colors.white),
                              errorWidget: (context, url, error) => Icon(Icons.error),
                            )
                          : IconButton(
                              color: Colors.white,
                              icon: Icon(Icons.upload_outlined),
                              onPressed: getImage,
                            ),
                    )),
              ),
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

  void initChatDpLoad() async {
    profileURL = await ChatHistory.getDp(roomId);
    setState(() => profileURL);
  }

  @override
  void initState() {
    initChatDpLoad();
    super.initState();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }
}
