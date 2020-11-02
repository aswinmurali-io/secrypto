import 'package:barcode_scan/barcode_scan.dart';

import 'package:flutter/material.dart';



class ScanPage extends StatefulWidget {
  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  String qrCodeResult;
  bool backCamera = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Scan using:" + (backCamera ? "Front Cam" : "Back Cam")),
          actions: <Widget>[
            IconButton(
              icon: backCamera ? Icon(Icons.ac_unit) : Icon(Icons.camera),
              onPressed: () {
                setState(() {
                  backCamera = !backCamera;
                  camera = backCamera ? 1 : -1;
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.ac_unit_outlined),
              onPressed: () {
                scan();
              },
            )
          ],
        ),
        body: Center(
          child: Text(
            (qrCodeResult == null) || (qrCodeResult == "")
                ? "Scan"
                : qrCodeResult,
            style: TextStyle(
                fontSize: 20.0, fontWeight: FontWeight.w900, color: Colors.red),
          ),
        ));
  }

  Future<List> scan() async {
    ScanResult codeSanner = await BarcodeScanner.scan(
      options: ScanOptions(
        useCamera: 0,
      ),
    );
    setState(() {
      qrCodeResult = codeSanner.rawContent;
    });
    List q = qrCodeResult.split(" ");
    return q;
  }
}

int camera = 1;
