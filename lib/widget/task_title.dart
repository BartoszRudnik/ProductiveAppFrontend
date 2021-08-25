import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TaskTitle extends StatelessWidget {
  final Function setTaskName;
  final newTaskTitleKey;

  TaskTitle({
    @required this.setTaskName,
    @required this.newTaskTitleKey,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: this.newTaskTitleKey,
      child: TextFormField(
        key: ValueKey('taskTitle'),
        validator: (value) {
          if (value.isEmpty) {
            return AppLocalizations.of(context).taskTitleEmpty;
          }

          return null;
        },
        onSaved: (value) {
          this.setTaskName(value);
        },
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w400,
        ),
        decoration: InputDecoration(
          hintStyle: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 20,
          ),
          hintText: AppLocalizations.of(context).taskName,
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
      ),
    );
  }
}
