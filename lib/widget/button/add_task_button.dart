import 'package:flutter/material.dart';
import 'package:productive_app/config/color_themes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddTaskButton extends StatelessWidget {
  final Function addNewTask;

  AddTaskButton({
    @required this.addNewTask,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ColorThemes.addTaskButtonStyle(context),
      onPressed: () {
        this.addNewTask(true);
      },
      icon: Icon(Icons.subdirectory_arrow_left_outlined),
      label: Text(
        AppLocalizations.of(context).save,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
