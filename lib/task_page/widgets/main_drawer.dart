import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:productive_app/task_page/task_screens/locations_screen.dart';
import 'package:provider/provider.dart';

import '../../login/providers/auth_provider.dart';
import '../providers/delegate_provider.dart';
import '../task_screens/completed_screen.dart';
import '../task_screens/settings_tabs_screen.dart';
import '../task_screens/tags_screen.dart';
import '../task_screens/trash_screen.dart';
import 'drawerListTile.dart';

class MainDrawer extends StatefulWidget {
  final String username;

  MainDrawer({
    @required this.username,
  });

  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  @override
  Widget build(BuildContext context) {
    Provider.of<AuthProvider>(context, listen: false).getUserData();
    Provider.of<AuthProvider>(context, listen: false).checkIfAvatarExists();
    final user = Provider.of<AuthProvider>(context).user;

    if (!user.removed) {
      Provider.of<AuthProvider>(context, listen: false).getUserImage();
    }

    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(
          left: 47,
          top: 64,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            !user.removed
                ? Container(
                    width: 100,
                    height: 100,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: user.userImage != null ? user.userImage : null,
                    ),
                  )
                : Container(
                    width: 100,
                    height: 100,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                  ),
            Container(
              alignment: Alignment.centerLeft,
              width: 210,
              height: 72,
              child: user.firstName != null && user.firstName.length > 0 && user.lastName != null && user.lastName.length > 0
                  ? Text(
                      user.firstName + ' ' + user.lastName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 21,
                      ),
                    )
                  : ListView(
                      children: widget.username
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
              height: 15,
            ),
            Badge(
              position: BadgePosition.topStart(),
              showBadge: Provider.of<DelegateProvider>(context).received.length > 0,
              badgeColor: Theme.of(context).primaryColor,
              badgeContent: Text(
                Provider.of<DelegateProvider>(context).received.length.toString(),
                style: TextStyle(color: Theme.of(context).accentColor),
              ),
              child: DrawerListTile(
                icon: Icons.settings,
                title: 'Settings',
                routeName: SettingsTabsScreen.routeName,
              ),
            ),
            DrawerListTile(
              icon: Icons.save,
              title: 'Projects',
            ),
            DrawerListTile(
              icon: Icons.tag,
              title: 'Tags',
              routeName: TagsScreen.routeName,
            ),
            DrawerListTile(
              icon: Icons.analytics_outlined,
              title: 'Analytics',
            ),
            DrawerListTile(
              icon: Icons.location_on,
              title: 'Locations',
              routeName: LocationsScreen.routeName,
            ),
            DrawerListTile(
              icon: Icons.done_all_outlined,
              title: 'Completed',
              routeName: CompletedScreen.routeName,
            ),
            DrawerListTile(
              icon: Icons.delete_outline_outlined,
              title: 'Trash',
              routeName: TrashScreen.routeName,
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
