import 'package:flutter/material.dart';
import 'package:secrypto/partials/session.dart';
import 'package:secrypto/partials/rooms.dart';

import '../partials/chat_list_card.dart';
import 'settings.dart';

class ContactListRoute extends StatefulWidget {
  ContactListRoute({Key key}) : super(key: key);

  @override
  _ContactListRouteState createState() => _ContactListRouteState();
}

class _ContactListRouteState extends State<ContactListRoute> with SingleTickerProviderStateMixin {
  AnimationController joinAnimation;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Map<String, Map<String, String>> rooms = {};

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Rooms.load();
      setState(() => rooms = Rooms.get());
    });
    joinAnimation = AnimationController(value: 0.0, vsync: this, duration: Duration(milliseconds: 200));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final roomIds = rooms.keys.toList();
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Secrypto"),
          actions: [
            // IconButton(icon: Icon(Icons.search), onPressed: () {}),
            IconButton(
                icon: Icon(Icons.settings),
                onPressed: () {
                  Future.delayed(Duration(milliseconds: 100), () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => SettingsRoute(),
                    ));
                  });
                }),
          ],
        ),
        body: Scrollbar(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Column(
                  children: [
                    for (int i = 0; i < rooms.length; i++)
                      ChatList(
                          name: rooms[roomIds[i]]['roomName'],
                          lastSendMsg: rooms[roomIds[i]]['lastSendMsg'],
                          time: rooms[roomIds[i]]['time'],
                          profileURL: rooms[roomIds[i]]['profileURL']),
                  ],
                )),
          ),
        ),
        floatingActionButton: Wrap(
          children: [
            FloatingActionButton.extended(
              heroTag: 'Join Session',
              onPressed: () => SessionJoinDialog.render(context),
              tooltip: 'Join a session to connect with people.',
              icon: Icon(Icons.connect_without_contact),
              label: Text("Join"),
            ),
            Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                child: FloatingActionButton.extended(
                  heroTag: 'Add Session',
                  onPressed: () async {
                    joinAnimation.forward();
                    _scaffoldKey.currentState.showSnackBar(
                      SnackBar(content: Text("Session created, Link copied into clipboard!")),
                    );
                    await SessionAddDialog.render(context);
                    setState(() {});
                    Future.delayed(Duration(seconds: 2), () {
                      joinAnimation.reverse();
                    });
                  },
                  tooltip: 'Create a session for others to connect',
                  icon: AnimatedIcon(icon: AnimatedIcons.add_event, progress: joinAnimation),
                  label: Text("Create"),
                )),
          ],
        ));
  }
}
