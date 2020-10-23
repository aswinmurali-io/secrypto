import 'package:flutter/material.dart';

import '../partials/chat_list_card.dart';

class ContactListRoute extends StatefulWidget {
  ContactListRoute({Key key}) : super(key: key);

  @override
  _ContactListRouteState createState() => _ContactListRouteState();
}

Map<String, List<String>> contact = {
  "Aswin Murali": ["Hi", "10:00AM"],
  "Abhinav Basil Shinow": ["Good", "8:00AM"],
  "Paimon": ["I am emergency food!", "12:00AM"],
  "Tim Cook": ["I am greedy", "12:00PM"],
  "Rahul Arjun": ["Good to see you", "3:00PM"],
  "Sunder": ["I am google", "5:00PM"],
  "Jeff": ["I am awesome, hahaha", "8:00PM"],
  "John": ["I am generic", "2:00PM"],
  "Vineeth": ["I in room 43132343421", "5:00PM"],
  "Kashinadth": ["I don't watch cartoon!!", "2:00AM"],
};

class _ContactListRouteState extends State<ContactListRoute> {
  var _k = contact.keys.toList();
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
            child: Column(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
              for (int i = 0; i < contact.keys.length; i++)
                ChatListCard(
                  name: _k[i],
                  lastSendMsg: contact[_k[i]][0],
                  time: contact[_k[i]][1],
                  profileURL: "https://picsum.photos/300/300/?blur",
                ),
            ]),
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
