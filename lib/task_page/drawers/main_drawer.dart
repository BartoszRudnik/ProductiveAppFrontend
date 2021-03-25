import 'package:flutter/material.dart';
import 'package:productive_app/task_page/widgets/drawerListTile.dart';

class MainDrawer extends StatelessWidget {
  final String username;

  MainDrawer({
    @required this.username,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        margin: EdgeInsets.only(
          left: 47,
          top: 84,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: 80,
              height: 80,
              child: CircleAvatar(
                backgroundColor: Theme.of(context).primaryColor,
              ),
            ),
            Container(
              width: 210,
              height: 72,
              child: ListView(
                children: username
                    .split(' ')
                    .map((e) => Text(
                          e,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 21,
                          ),
                        ))
                    .toList(),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            DrawerListTile(
              icon: Icons.settings,
              title: 'Settings',
            ),
            SizedBox(
              height: 15,
            ),
            DrawerListTile(
              icon: Icons.save,
              title: 'Projects',
            ),
            SizedBox(
              height: 15,
            ),
            DrawerListTile(icon: Icons.tag, title: 'Tags'),
            SizedBox(
              height: 15,
            ),
            DrawerListTile(
              icon: Icons.analytics_outlined,
              title: 'Analytics',
            ),
          ],
        ),
      ),
    );
  }
}