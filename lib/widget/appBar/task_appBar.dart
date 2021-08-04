import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TaskAppBar extends StatelessWidget with PreferredSizeWidget {
  final String title;
  final IconButton leadingButton;

  TaskAppBar({@required this.title, this.leadingButton});

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
      backwardsCompatibility: false,
      iconTheme: Theme.of(context).iconTheme,
      brightness: Brightness.dark,
      leading: (leadingButton != null) ? leadingButton : null,
      actions: [
        PopupMenuButton(
          icon: Icon(Icons.more_vert),
          itemBuilder: (_) => [],
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(50);
}
