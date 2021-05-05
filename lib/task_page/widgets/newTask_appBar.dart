import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:productive_app/task_page/providers/settings_provider.dart';
import 'package:productive_app/task_page/task_screens/filters_screen.dart';
import 'package:provider/provider.dart';

class NewTaskAppBar extends StatefulWidget with PreferredSizeWidget {
  final String title;
  final IconButton leadingButton;
  NewTaskAppBar({@required this.title, this.leadingButton});

  @override
  Size get preferredSize => Size.fromHeight(50);

  @override
  _NewTaskAppBarState createState() => _NewTaskAppBarState();
}

class _NewTaskAppBarState extends State<NewTaskAppBar> {
  @override
  Widget build(BuildContext context) {
    bool onlyUnfinished = false;
    if (Provider.of<SettingsProvider>(context).userSettings.showOnlyUnfinished != null) {
      onlyUnfinished = Provider.of<SettingsProvider>(context).userSettings.showOnlyUnfinished;
    }

    return AppBar(
      elevation: 0,
      title: Text(
        this.widget.title,
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
      leading: (widget.leadingButton != null) ? widget.leadingButton : null,
      actions: <Widget>[
        PopupMenuButton(
          onSelected: (value) {
            if (value == 'done') {
              setState(() {
                onlyUnfinished = !onlyUnfinished;
                Provider.of<SettingsProvider>(context, listen: false).changeShowOnlyUnfinished();
              });
            } else if (value == 'filters') {
              Navigator.of(context).pushNamed(FiltersScreen.routeName);
            }
          },
          icon: Icon(Icons.more_vert),
          itemBuilder: (_) => [
            PopupMenuItem(
              child: onlyUnfinished == true
                  ? Text(
                      'Show all',
                    )
                  : Text(
                      'Only unfinished',
                    ),
              value: 'done',
            ),
            PopupMenuItem(
              child: Text('Filters'),
              value: 'filters',
            ),
          ],
        ),
      ],
    );
  }
}
