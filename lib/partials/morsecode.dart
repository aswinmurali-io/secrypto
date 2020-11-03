import 'dart:io';

import 'package:torch/torch.dart';
import 'package:vibration/vibration.dart';

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

void morseCodeVibrate(String code) {
  for (int i = 0; i < code.length - 1; i++) {
    int time = timimg[code[i]];
    if (time > 0) {
      Vibration.vibrate(duration: time);
      sleep(Duration(milliseconds: time + 100));
    }
  }
}

void morseCodeFlash(String code) {
  for (int i = 0; i < code.length - 1; i++) {
    int time = timimg[code[i]];
    if (time > 0) {
      Torch.turnOn();
      sleep(Duration(milliseconds: time));
      Torch.turnOff();
      sleep(Duration(milliseconds: 100));
    }
  }
}
