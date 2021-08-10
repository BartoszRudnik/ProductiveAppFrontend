import 'package:flutter/material.dart';
import 'package:productive_app/config/color_themes.dart';

class FullScreenButton extends StatelessWidget {
  final Function setFullScreen;

  FullScreenButton({
    @required this.setFullScreen,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ColorThemes.addTaskButtonStyle(context),
      onPressed: () {
        this.setFullScreen();
      },
      icon: Icon(Icons.open_in_full),
      label: Text(''),
    );
  }
}
