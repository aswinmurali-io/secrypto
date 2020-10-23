import 'package:flutter/material.dart';

class SettingsCard extends StatefulWidget {
  final String name;
  final Widget settingsOperation;
  SettingsCard({Key key, this.name, this.settingsOperation});

  @override
  _SettingsCardState createState() => _SettingsCardState(name, settingsOperation);
}

class _SettingsCardState extends State<SettingsCard> {
  final String name;
  final Widget settingsOperation;
  _SettingsCardState(this.name, this.settingsOperation);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            CircleAvatar(radius: 30.0, child: Icon(Icons.set_meal)),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 114,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            )),
                        widget
                      ],
                    ),
                  ),
                  Text("Settings Desp\n"),
                ],
              ),
            )
          ],
        ),
      ),
      onTap: () {},
    );
  }
}
