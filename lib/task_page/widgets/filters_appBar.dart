import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:productive_app/task_page/providers/settings_provider.dart';
import 'package:provider/provider.dart';

class FiltersAppBar extends StatelessWidget with PreferredSizeWidget {
  final String title;
  final IconButton leadingButton;
  FiltersAppBar({@required this.title, this.leadingButton});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      title: Text(
        this.title,
        style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.w400,
          color: Theme.of(context).primaryColor,
        ),
      ),
      systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: Colors.black),
      backgroundColor: Theme.of(context).accentColor,
      iconTheme: Theme.of(context).iconTheme,
      brightness: Brightness.dark,
      leading: (leadingButton != null) ? leadingButton : null,
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.all(4),
              primary: Theme.of(context).primaryColor,
              side: BorderSide(color: Theme.of(context).primaryColor),
            ),
            onPressed: () {
              final userSettings = Provider.of<SettingsProvider>(context, listen: false).userSettings;

              if (userSettings.showOnlyDelegated != null && userSettings.showOnlyDelegated) {
                Provider.of<SettingsProvider>(context, listen: false).changeShowOnlyDelegated();
              }
              if (userSettings.showOnlyUnfinished != null && userSettings.showOnlyUnfinished) {
                Provider.of<SettingsProvider>(context, listen: false).changeShowOnlyUnfinished();
              }
              if (userSettings.collaborators != null) {
                Provider.of<SettingsProvider>(context, listen: false).clearFilterCollaborators();
              }
              if (userSettings.priorities != null) {
                Provider.of<SettingsProvider>(context, listen: false).clearFilterPriorities();
              }
            },
            child: Text(
              'Clear filters',
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).accentColor,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(50);
}
