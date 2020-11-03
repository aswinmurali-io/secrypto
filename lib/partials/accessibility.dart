import 'dart:io';

import 'package:secrypto/globals.dart';
import 'package:torch/torch.dart';
import 'package:vibration/vibration.dart';

import 'settings.dart';

final Map<String, int> timimg = {
  '-': 200,
  '.': 50,
  ' ': 0,
};

final Map<String, String> mapper = {
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

String encodeToMorseCode(String msg) {
  String temp = msg.toLowerCase();
  String code = '';
  for (int i = 0; i < temp.length; i++) code += mapper[temp[i]] + ' ';
  return code;
}

void morseCodeVibrate(String msg) async {
  if (await SecryptoSettings.shouldMorseCode()) {
    String code = encodeToMorseCode(msg);
    for (int i = 0; i < code.length - 1; i++) {
      int time = timimg[code[i]];
      if (time > 0) {
        await Future.delayed(
          Duration(milliseconds: time + 100),
          () async => await Vibration.vibrate(duration: time),
        );
      }
    }
  }
}

Future<void> morseCodeFlash(String msg) async {
  String code = encodeToMorseCode(msg);
  for (int i = 0; i < code.length - 1; i++) {
    int time = timimg[code[i]];
    if (time > 0) {
      await Future.delayed(Duration(milliseconds: time), () async => await Torch.turnOn());
      await Future.delayed(Duration(milliseconds: time), () async => await Torch.turnOff());
    }
  }
}

Future<void> msgAccesiblity(String msg) async {
  if (await SecryptoSettings.shouldNarrate()) tTs.speak(msg);
  //morseCodeVibrate(msg);
}
