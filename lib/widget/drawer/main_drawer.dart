import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:productive_app/config/images.dart';
import 'package:productive_app/screen/locations_screen.dart';
import 'package:productive_app/utils/dialogs.dart';
import 'package:provider/provider.dart';
import '../../provider/auth_provider.dart';
import '../../provider/delegate_provider.dart';
import '../../screen/completed_screen.dart';
import '../../screen/settings_tabs_screen.dart';
import '../../screen/tags_screen.dart';
import '../../screen/trash_screen.dart';
import '../drawerListTile.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).user;

    print('notify');
    print(user.removed);

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
          children: [
            if (user != null && !user.removed)
              Container(
                width: 100,
                height: 100,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: user.userImage != null
                      ? user.userImage
                      : user.localImage != null
                          ? MemoryImage(user.localImage)
                          : null,
                ),
              )
            else
              Container(
                width: 100,
                height: 100,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage(Images.profilePicturePlacholder),
                ),
              ),
            Container(
              alignment: Alignment.centerLeft,
              width: 180,
              height: 72,
              child: (user.firstName != null && user.firstName.length > 0) || (user.lastName != null && user.lastName.length > 0)
                  ? Text(
                      user.firstName != null
                          ? user.firstName + ' ' + (user.lastName != null ? user.lastName : '')
                          : '' + ' ' + (user.lastName != null ? user.lastName : ''),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 21,
                      ),
                      softWrap: true,
                      maxLines: 3,
                    )
                  : Text(
                      user.email,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 21,
                      ),
                    ),
            ),
            SizedBox(
              height: 15,
            ),
            Badge(
              position: BadgePosition.topStart(),
              showBadge: Provider.of<DelegateProvider>(context).received.length > 0 || Provider.of<DelegateProvider>(context).numberOfPermissionRequest > 0,
              badgeColor: Theme.of(context).primaryColor,
              badgeContent: Text(
                (Provider.of<DelegateProvider>(context).received.length + Provider.of<DelegateProvider>(context).numberOfPermissionRequest).toString(),
                style: TextStyle(color: Theme.of(context).accentColor),
              ),
              child: DrawerListTile(
                icon: Icons.settings,
                title: AppLocalizations.of(context).settings,
                routeName: SettingsTabsScreen.routeName,
              ),
            ),
            DrawerListTile(
              icon: Icons.tag,
              title: AppLocalizations.of(context).tags,
              routeName: TagsScreen.routeName,
            ),
            DrawerListTile(
              icon: Icons.analytics_outlined,
              title: AppLocalizations.of(context).analytics,
            ),
            DrawerListTile(
              icon: Icons.location_on,
              title: AppLocalizations.of(context).locations,
              routeName: LocationsScreen.routeName,
            ),
            DrawerListTile(
              icon: Icons.done_all_outlined,
              title: AppLocalizations.of(context).completed,
              routeName: CompletedScreen.routeName,
            ),
            DrawerListTile(
              icon: Icons.delete_outline_outlined,
              title: AppLocalizations.of(context).trash,
              routeName: TrashScreen.routeName,
            ),
            ListTile(
              minLeadingWidth: 16,
              contentPadding: EdgeInsets.symmetric(horizontal: 0),
              leading: Icon(Icons.logout),
              title: Text(AppLocalizations.of(context).logout),
              onTap: () => Dialogs.logoutDialog(context),
            ),
          ],
        ),
      ),
    );
  }
}
