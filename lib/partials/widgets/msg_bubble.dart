import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:secrypto/partials/settings_logic.dart';

import '../../globals.dart';

class SecryptoChatBubble extends StatelessWidget {
  final String msg;
  final bool isReceiver;

  const SecryptoChatBubble({Key key, this.msg, this.isReceiver}) : super(key: key);

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
            if (await Settings.shouldNarrate()) tTs.speak(msg);
          },
          child: Text(
            msg ?? 'Unknown msg',
            textAlign: TextAlign.right,
            style: TextStyle(color: (isReceiver) ? Colors.black : Colors.white),
          )),
    );
  }
}
