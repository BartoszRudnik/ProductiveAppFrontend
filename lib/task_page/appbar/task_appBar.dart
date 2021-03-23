import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TaskAppBar extends StatelessWidget with PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        'Today',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).primaryColor,
        ),
      ),
      systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: Colors.black),
      backgroundColor: Theme.of(context).accentColor,
      iconTheme: Theme.of(context).iconTheme,
      brightness: Brightness.dark,
      actions: <Widget>[
        PopupMenuButton(
          icon: Icon(Icons.more_vert),
          itemBuilder: (_) => [],
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(40);
}
