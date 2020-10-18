import 'package:flutter/material.dart';

import 'routes/contact_list.dart';

void main() => runApp(Secrypto());

class Secrypto extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Secrypto',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ContactList(),
    );
  }
}
