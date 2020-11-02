import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';
import 'package:torch/torch.dart';
import 'dart:io';

Map timimg = {'-': 200, '.': 50, ' ': 0};
Map mapper = {
  'a': '.-',
  'b': '-...',
  'c': '-.-.',
  'd': '-..',
  'e': '.',
  'f': '..-.',
  'g': '--.',
  'h': '....',
  'i': '..',
  'j': '.---',
  'k': '-.-',
  'l': '.-..',
  'm': '--',
  'n': '-.',
  'o': '---',
  'p': '.--.',
  'q': '--.-',
  'r': '.-.',
  's': '...',
  't': '-',
  'u': '..-',
  'v': '...-',
  'w': '.--',
  'x': '-..-',
  'y': '-.--',
  'z': '--..',
  ' ': '     '
};


class Morse extends StatefulWidget {
  _MorseState createState() => _MorseState();
}

class _MorseState extends State<Morse> {
  TextEditingController texty = new TextEditingController();

  String code = '';

  void encoder() {
    setState(() {
      String temp = texty.text.toLowerCase();
      code = '';
      for (int i = 0; i < temp.length; i++) {
        code += mapper[temp[i]] + ' ';
      }
    });
  }

  void vibe() {
    for (int i = 0; i < code.length - 1; i++) {
      int time = timimg[code[i]];
      time > 0 ? Vibration.vibrate(duration: time): Null;
      time> 0 ? sleep(Duration(milliseconds: time + 100)): Null;
    }
  }

  void lit() {
    for (int i = 0; i < code.length - 1; i++) {
      int time = timimg[code[i]];
      time > 0 ? Torch.turnOn() : 1;
      sleep(Duration(milliseconds: time));
      Torch.turnOff();
      sleep(Duration(milliseconds: 100));
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Text > Morse > Vibe'),
      ),
      body: Column(children: <Widget>[
        TextField(
          controller: texty,
        ),
        RaisedButton(
            onPressed: encoder,
            child: Text(
              "Convert To Morse Code",
            )),
        Text(
          code,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
                onPressed: vibe,
                child: Text(
                  "🥁",
                )),
            RaisedButton(
                onPressed: lit,
                child: Text(
                  "🔥",
                ))
          ],
        )
      ]),
    );
  }
}