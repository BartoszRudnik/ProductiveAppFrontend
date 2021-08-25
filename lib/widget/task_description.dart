import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TaskDescription extends StatelessWidget {
  final Function setTaskDescription;
  final newTaskDescriptionKey;

  TaskDescription({
    @required this.setTaskDescription,
    @required this.newTaskDescriptionKey,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: this.newTaskDescriptionKey,
      child: TextFormField(
        maxLines: null,
        key: ValueKey('taskDescription'),
        onSaved: (value) {
          this.setTaskDescription(value);
        },
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w400,
        ),
        decoration: InputDecoration(
          hintText: AppLocalizations.of(context).taskDescription,
          hintStyle: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 15,
          ),
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
      ),
    );
  }
}
