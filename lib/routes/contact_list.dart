import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../dialog/session.dart';
import '../globals.dart';
import '../partials/accessibility.dart';
import '../partials/chat_list_card.dart';
import '../partials/rooms.dart';
import '../partials/user.dart';
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

  String dpUrl;
  @override
  Widget build(BuildContext context) {
    final roomIds = Rooms.rooms.keys.toList();
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.fromLTRB(5, 5, 0, 0),
            child: Hero(
                tag: 'me',
                child: Material(
                    child: Transform.scale(
                        scale: 0.8,
                        child: CircleAvatar(
                          backgroundColor: Colors.grey,
                          child: ClipOval(
                            child: InkWell(
                                onTap: () async {
                                  await User.uploadDp();
                                  setState(() => dpUrl);
                                },
                                child: CachedNetworkImage(
                                  imageUrl: dpUrl ?? placeHolderDp,
                                  fit: BoxFit.fill,
                                  width: 100,
                                  placeholder: (context, url) => CircularProgressIndicator(),
                                  errorWidget: (context, url, error) => Icon(Icons.error),
                                )),
                          ),
                        )))),
          ),
          title: Text("Secrypto"),
          actions: [
            IconButton(
                icon: Icon(Icons.settings),
                onPressed: () async {
                  await msgAccesiblity("Opened Settings");
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
                          time: '')
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
                    await msgAccesiblity("Create, If your disabled person, Ask help.");
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

  void initAsync() async {
    dpUrl = await User.getDp;
    setState(() => dpUrl);
  }

  @override
  void dispose() {
    joinAnimation.dispose();
    super.dispose();
  }

  @override
  void initState() {
    initAsync();
    Rooms.load();
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() => rooms = Rooms.rooms));
    joinAnimation = AnimationController(value: 0.0, vsync: this, duration: Duration(milliseconds: 200));
    super.initState();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }
}
