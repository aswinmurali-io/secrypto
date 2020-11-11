import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:secrypto/partials/rooms.dart';
import 'package:secrypto/partials/user.dart';
import 'package:secrypto/routes/contact_list.dart';

import '../globals.dart';

class GroupMembersRoute extends StatefulWidget {
  final Set allUsers;
  final String roomId;
  GroupMembersRoute({Key key, this.allUsers, this.roomId}) : super(key: key);

  @override
  _GroupMembersRouteState createState() => _GroupMembersRouteState(allUsers, roomId);
}

class _GroupMembersRouteState extends State<GroupMembersRoute> {
  final Set _allUsers;
  final String roomId;

  _GroupMembersRouteState(this._allUsers, this.roomId);

  Future<List<String>> _get(i) async {
    return [await User.getOtherName(i), await User.otherDp(i)];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Members"),
          actions: [
            RaisedButton.icon(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                Rooms.remove(roomId);
                Rooms.save();
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => ContactListRoute(),
                ));
              },
              label: Text("Leave"),
            )
          ],
        ),
        body: Scrollbar(
          child: SingleChildScrollView(
            child: Column(
              children: [
                for (String i in _allUsers)
                  FutureBuilder(
                    future: _get(i),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListTile(
                          title: Text(snapshot.data[0]),
                          leading: CircleAvatar(
                            backgroundColor: Colors.black,
                            radius: 25.0,
                            child: ClipOval(
                              child: CachedNetworkImage(
                                fit: BoxFit.fill,
                                imageUrl: snapshot.hasData ? snapshot.data[1] : placeHolderDp,
                                placeholder: (context, url) => CircularProgressIndicator(),
                                errorWidget: (context, url, error) => Icon(Icons.error),
                              ),
                            ),
                          ),
                        );
                      }
                      return Container();
                    },
                  ),
              ],
            ),
          ),
        ));
  }
}
