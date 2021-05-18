import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:productive_app/task_page/models/task.dart';
import 'package:productive_app/task_page/providers/settings_provider.dart';
import 'package:productive_app/task_page/task_screens/related_task_info_screen.dart';
import 'package:provider/provider.dart';

class DetailsAppBar extends StatefulWidget with PreferredSizeWidget {
  final String title;
  final IconButton leadingButton;
  final Task task;
  DetailsAppBar({@required this.title, this.leadingButton, @required this.task});

  @override
  Size get preferredSize => Size.fromHeight(50);

  @override
  _DetailsAppBarState createState() => _DetailsAppBarState();
}

class _DetailsAppBarState extends State<DetailsAppBar> {
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
            if (value == 'related') {
              Navigator.of(context).pushNamed(RelatedTaskInfoScreen.routeName);
            }
          },
          icon: Icon(Icons.more_vert),
          itemBuilder: (this.widget.task.childId != null || this.widget.task.parentId != null)? (_) => [
            PopupMenuItem(
              child: Text('Related task info'),
              value: 'related',
            ),
          ]: (_) =>[

          ],
        ),
      ],
    );
  }
}