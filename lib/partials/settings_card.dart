import 'package:flutter/material.dart';

class SettingsCard extends StatefulWidget {
  SettingsCard({Key key}) : super(key: key);

  @override
  _SettingsCardState createState() => _SettingsCardState();
}

class _SettingsCardState extends State<SettingsCard> {
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
                        Text("Unknown",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            )),
                        Switch(
                          value: true,
                          onChanged: (value) {},
                        ),
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
