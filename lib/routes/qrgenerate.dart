import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class GeneratePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => GeneratePageState();
}

class GeneratePageState extends State<GeneratePage> {
  String email = "abhinavshinow@gmail.com";
  String pass = "hello";
  GlobalKey globalKey = new GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Generate  Session QR '),
      ),
      body: Container(
        child: QrImage(
                    version: QrVersions.auto,
                    data: email+" "+pass,
                    gapless: true,
                    size: 200.0
                  )
      ),
    );
  }
}