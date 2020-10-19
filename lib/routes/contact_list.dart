import 'package:flutter/material.dart';

import '../partials/chat_list_card.dart';

class ContactListRoute extends StatefulWidget {
  ContactListRoute({Key key}) : super(key: key);

  @override
  _ContactListRouteState createState() => _ContactListRouteState();
}

class _ContactListRouteState extends State<ContactListRoute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Secrypto"),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
      ),
      body: Scrollbar(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                for (int i = 0; i < 10; i++) ChatListCard(),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Add Contact',
        child: Icon(Icons.add),
      ),
    );
  }
}
