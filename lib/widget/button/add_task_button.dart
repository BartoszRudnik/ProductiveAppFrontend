import 'package:flutter/material.dart';

class AddTaskButton extends StatelessWidget {
  final Function addNewTask;

  AddTaskButton({
    @required this.addNewTask,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        onPrimary: Theme.of(context).primaryColor,
        side: BorderSide(color: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).primaryColorDark : Theme.of(context).accentColor),
        primary: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).primaryColorDark : Theme.of(context).accentColor,
        elevation: 0,
      ),
      onPressed: () {
        this.addNewTask();
      },
      icon: Icon(Icons.subdirectory_arrow_left_outlined),
      label: Text(
        'Save',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
