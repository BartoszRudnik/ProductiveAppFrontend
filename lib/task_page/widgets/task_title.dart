import 'package:flutter/material.dart';

class TaskTitle extends StatelessWidget {
  Function setTaskName;

  TaskTitle({@required this.setTaskName});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: ValueKey('taskName'),
      validator: (value) {
        if (value.isEmpty) {
          return 'Task title cannot be empty';
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
        hintText: 'Task name',
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
      ),
    );
  }
}