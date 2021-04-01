import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../login/providers/auth_provider.dart';
import 'drawerListTile.dart';

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
            SizedBox(
              height: 15,
            ),
            ListTile(
              minLeadingWidth: 16,
              contentPadding: EdgeInsets.symmetric(horizontal: 0),
              leading: Icon(Icons.logout),
              title: Text('Log out'),
              onTap: () {
                return showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Center(
                      child: Text(
                        'Log out',
                        style: Theme.of(context).textTheme.headline3,
                      ),
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Are you sure you want to log out?'),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Theme.of(context).primaryColor,
                                side: BorderSide(color: Theme.of(context).primaryColor),
                              ),
                              onPressed: () {
                                Provider.of<AuthProvider>(context, listen: false).logout();
                                Navigator.of(context).pop(true);
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                'Yes',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context).accentColor,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Theme.of(context).primaryColor,
                                side: BorderSide(color: Theme.of(context).primaryColor),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop(false);
                              },
                              child: Text(
                                'No',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context).accentColor,
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
