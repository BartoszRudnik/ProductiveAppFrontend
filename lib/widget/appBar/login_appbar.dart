import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginAppBar extends StatelessWidget with PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Theme.of(context).accentColor,
      brightness: Brightness.dark,
      backwardsCompatibility: false,
      systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: Colors.black),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(50);
}
