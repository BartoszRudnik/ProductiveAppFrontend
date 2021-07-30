import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(50);
}
