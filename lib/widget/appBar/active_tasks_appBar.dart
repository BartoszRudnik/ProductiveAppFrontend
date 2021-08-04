import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ActiveTasksAppBar extends StatelessWidget with PreferredSizeWidget {
  final String message;

  ActiveTasksAppBar({
    @required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        this.message,
        style: TextStyle(color: Colors.black),
      ),
      toolbarHeight: 50,
      systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: Colors.black),
      backgroundColor: Theme.of(context).accentColor,
      iconTheme: Theme.of(context).iconTheme,
      brightness: Brightness.dark,
      backwardsCompatibility: false,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(50);
}
