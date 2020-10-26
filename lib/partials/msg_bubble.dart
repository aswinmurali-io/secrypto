import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

FlutterTts flutterTts = FlutterTts();

class SecryptoChatBubble extends StatelessWidget {
  final String msg;
  final bool isReceiver;
  final bool isNarrated;
  const SecryptoChatBubble({Key key, this.msg, this.isReceiver, this.isNarrated}) : super(key: key);

  void doAccessibility() async {
    if (!isNarrated) await flutterTts.speak(msg);
  }

  @override
  Widget build(BuildContext context) {
    doAccessibility();
    return Bubble(
      margin: BubbleEdges.only(top: 10),
      alignment: (isReceiver) ? Alignment.topLeft : Alignment.topRight,
      nipWidth: 8,
      nipHeight: 15,
      nip: BubbleNip.no,
      color: (isReceiver) ? Colors.white.withOpacity(0.8) : Colors.blueGrey,
      child: Text(
        msg ?? 'Unknown msg',
        textAlign: TextAlign.right,
        style: TextStyle(color: (isReceiver) ? Colors.black : Colors.white),
      ),
    );
  }
}
