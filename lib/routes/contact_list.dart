import 'package:flutter/material.dart';

import '../dialog/session.dart';
import '../globals.dart';

import '../partials/chat_list_card.dart';
import '../partials/rooms.dart';
import '../partials/settings.dart';

import '../routes/settings.dart';

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
    Rooms.load();
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() => rooms = Rooms.rooms));
    joinAnimation = AnimationController(value: 0.0, vsync: this, duration: Duration(milliseconds: 200));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final roomIds = Rooms.rooms.keys.toList();
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Secrypto"),
          actions: [
            IconButton(
                icon: Icon(Icons.settings),
                onPressed: () async {
                  if (await SecryptoSettings.shouldNarrate()) tTs.speak("Opened Settings");
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
                    for (int i = 0; i < Rooms.rooms.length; i++)
                      ChatList(
                        roomId: roomIds[i],
                        name: Rooms.rooms[roomIds[i]]['roomName'],
                        lastSendMsg: '', // rooms[roomIds[i]]['lastSendMsg'],
                        time: '', //rooms[roomIds[i]]['time'],
                        profileURL: null,
                      ) //rooms[roomIds[i]]['profileURL']),
                  ],
                )),
          ),
        ),
        floatingActionButton: Wrap(
          children: [
            FloatingActionButton.extended(
              heroTag: 'Join Session',
              onPressed: () async {
                await SessionJoinDialog.render(context);
                setState(() {});
              },
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
                    if (await SecryptoSettings.shouldNarrate()) tTs.speak("Create, If your disabled person, Ask help.");
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
