import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:auto_size_text/auto_size_text.dart';

class ActiveTasksAppBar extends StatelessWidget with PreferredSizeWidget {
  final String message;

  ActiveTasksAppBar({
    @required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: 30,
        child: AutoSizeText(
          this.message,
          minFontSize: 16,
          maxFontSize: 28,
          style: TextStyle(
            color: Theme.of(context).primaryColor,
          ),
        ),
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
