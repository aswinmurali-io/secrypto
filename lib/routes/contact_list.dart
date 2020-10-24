import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:secrypto/partials/add_session.dart';

import '../partials/auth.dart';
import '../partials/chat_list_card.dart';

class ContactListRoute extends StatefulWidget {
  ContactListRoute({Key key}) : super(key: key);

  @override
  _ContactListRouteState createState() => _ContactListRouteState();
}

class _ContactListRouteState extends State<ContactListRoute> with SingleTickerProviderStateMixin {
  AnimationController joinAnimation;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    joinAnimation = AnimationController(value: 0.0, vsync: this, duration: Duration(milliseconds: 200));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Secrypto"),
          actions: [
            IconButton(icon: Icon(Icons.search), onPressed: () {}),
            IconButton(icon: Icon(Icons.settings), onPressed: () {}),
          ],
        ),
        body: Scrollbar(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: StreamProvider.value(
                value: Contact.all,
                child: ChatList(),
              ),
            ),
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
                onPressed: () {
                  joinAnimation.forward();
                  _scaffoldKey.currentState.showSnackBar(
                    SnackBar(content: Text("Session created, Link copied into clipboard!")),
                  );
                  Future.delayed(Duration(seconds: 2), () {
                    joinAnimation.reverse();
                  });
                },
                tooltip: 'Create a session for others to connect',
                icon: AnimatedIcon(icon: AnimatedIcons.add_event, progress: joinAnimation),
                label: Text("Create"),
              ),
            ),
          ],
        ));
  }
}
