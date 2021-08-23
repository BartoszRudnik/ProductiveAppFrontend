import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TaskDescription extends StatelessWidget {
  Function setTaskDescription;

  TaskDescription({@required this.setTaskDescription});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
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
    );
  }
}
