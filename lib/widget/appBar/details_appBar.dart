import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../model/task.dart';
import '../../screen/related_task_info_screen.dart';

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
    if (widget.task.isDelegated == null) {
      widget.task.isDelegated = false;
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
              Navigator.of(context).pushNamed(RelatedTaskInfoScreen.routeName, arguments: this.widget.task.childId != null ? this.widget.task.childId : this.widget.task.parentId);
            }
          },
          icon: Icon(Icons.more_vert),
          itemBuilder: (this.widget.task.childId != null || this.widget.task.isDelegated)
              ? (_) => [
                    PopupMenuItem(
                      child: Text('Related task info'),
                      value: 'related',
                    ),
                  ]
              : (_) => [],
        ),
      ],
    );
  }
}
