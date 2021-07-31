import 'package:flutter/material.dart';

class FullScreenButton extends StatelessWidget {
  Function setFullScreen;
  final isDarkMode;

  FullScreenButton({
    @required this.setFullScreen,
    @required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        minimumSize: Size(20, 20),
        onPrimary: Theme.of(context).primaryColor,
        primary: this.isDarkMode ? Theme.of(context).primaryColorDark : Theme.of(context).accentColor,
        elevation: 0,
      ),
      onPressed: () {
        this.setFullScreen();
      },
      icon: Icon(Icons.open_in_full),
      label: Text(''),
    );
  }
}
