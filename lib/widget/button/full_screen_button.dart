import 'package:flutter/material.dart';

class FullScreenButton extends StatelessWidget {
  Function setFullScreen;

  FullScreenButton({@required this.setFullScreen});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        minimumSize: Size(20, 20),
        onPrimary: Theme.of(context).primaryColor,
        primary: Theme.of(context).accentColor,
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
