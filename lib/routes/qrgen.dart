import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class GeneratePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => GeneratePageState();
}

class GeneratePageState extends State<GeneratePage> {
  String email = "abhinavshinow@gmail.com";
  String pass = "hello";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Generate QR code'),
      ),
      body: Container(
        child:QrImage(
                  version: QrVersions.auto,
                  data: email+" "+pass,
                  gapless: true,
                  size: 200.0
                ),
      ),
    );
  }
}