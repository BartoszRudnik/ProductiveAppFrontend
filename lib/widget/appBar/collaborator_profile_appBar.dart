import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CollaboratorProfileAppBar extends StatelessWidget with PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 40,
      systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: Colors.black),
      backgroundColor: Theme.of(context).accentColor,
      iconTheme: Theme.of(context).iconTheme,
      brightness: Brightness.dark,
      backwardsCompatibility: false,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(40);
}
