import 'package:bubble/bubble.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:secrypto/globals.dart';

import '../accessibility.dart';
import '../user.dart';

class SecryptoChatBubble extends StatefulWidget {
  final String msg;
  final bool isReceiver;
  final String uid;
  final String timestamp;
  SecryptoChatBubble({Key key, this.msg, this.isReceiver, this.uid, this.timestamp}) : super(key: key);

  @override
  _SecryptoChatBubbleState createState() => _SecryptoChatBubbleState(msg, isReceiver, uid, timestamp);
}

class _SecryptoChatBubbleState extends State<SecryptoChatBubble> {
  final String msg;
  final bool isReceiver;
  final String uid;
  final String timestamp;

  _SecryptoChatBubbleState(this.msg, this.isReceiver, this.uid, this.timestamp);

  String userName;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => Future.delayed(
          Duration(microseconds: 10),
          () async => await msgAccesiblity(msg),
        ));
    super.initState();
  }

  bool expandDetails = false;

  @override
  Widget build(BuildContext context) {
    return Bubble(
      margin: BubbleEdges.only(top: 10),
      alignment: (isReceiver) ? Alignment.topLeft : Alignment.topRight,
      nipWidth: 8,
      nipHeight: 15,
      nip: BubbleNip.no,
      color: (isReceiver) ? Colors.white.withOpacity(0.8) : Colors.blueGrey,
      child: InkWell(
          onTap: () async {
            userName = await User.getName();
            setState(() => expandDetails = !expandDetails);
            await msgAccesiblity(msg);
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isReceiver)
                CircleAvatar(
                  radius: 13.0,
                  child: ClipOval(
                      child: FutureBuilder<String>(
                    future: User.otherDp(uid),
                    builder: (context, snapshot) {
                      if (snapshot.hasData)
                        return CachedNetworkImage(
                          imageUrl: snapshot.data,
                          progressIndicatorBuilder: (context, url, progress) =>
                              CircularProgressIndicator(value: progress.progress, backgroundColor: Colors.white),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                        );
                      return Container();
                    },
                  )),
                ),
              if (expandDetails)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    ' ${userName ?? ""}@${timestamp ?? ""}',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ),
              Padding(
                padding: EdgeInsets.fromLTRB(isReceiver ? 5 : 0, 0, 0, 0),
                child: Text(
                  msg ?? 'Unknown msg',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: (isReceiver) ? Colors.black : Colors.white,
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
