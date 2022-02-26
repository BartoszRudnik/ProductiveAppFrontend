import 'package:flutter/material.dart';
import 'package:productive_app/config/color_themes.dart';

class AddTaskNoClosingButton extends StatelessWidget {
  final Function addTask;

  AddTaskNoClosingButton({
    @required this.addTask,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ColorThemes.addTaskButtonStyle(context),
      onPressed: () {
        this.addTask(false);
      },
      icon: Icon(Icons.arrow_upward_outlined),
      label: Text(''),
    );
  }
}
