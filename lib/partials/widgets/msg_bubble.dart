import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:secrypto/partials/settings.dart';

import '../../globals.dart';

class SecryptoChatBubble extends StatefulWidget {
  final String msg;
  final bool isReceiver;
  SecryptoChatBubble({Key key, this.msg, this.isReceiver}) : super(key: key);

  @override
  _SecryptoChatBubbleState createState() => _SecryptoChatBubbleState(msg, isReceiver);
}

class _SecryptoChatBubbleState extends State<SecryptoChatBubble> {
  final String msg;
  final bool isReceiver;
  _SecryptoChatBubbleState(this.msg, this.isReceiver);

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration(microseconds: 10), () => tTs.speak(msg));
    });
    super.initState();
  }

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
            if (await SecryptoSettings.shouldNarrate()) tTs.speak(msg);
          },
          child: Text(
            msg ?? 'Unknown msg',
            textAlign: TextAlign.right,
            style: TextStyle(
              color: (isReceiver) ? Colors.black : Colors.white,
            ),
          )),
    );
  }
}
