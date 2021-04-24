import 'package:flutter/material.dart';

class TaskPriority extends StatefulWidget {
  Function setTaskPriority;
  String priority;
  List<String> priorities;

  TaskPriority({
    @required this.setTaskPriority,
    @required this.priority,
    @required this.priorities,
  });

  @override
  _TaskPriorityState createState() => _TaskPriorityState();
}

class _TaskPriorityState extends State<TaskPriority> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      initialValue: this.widget.priority,
      onSelected: (value) {
        setState(() {
          this.widget.priority = value;
          this.widget.setTaskPriority(value);
        });
      },
      icon: Icon(Icons.flag_outlined),
      itemBuilder: (context) {
        return this.widget.priorities.reversed.map((e) {
          return PopupMenuItem(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text(e),
                SizedBox(
                  width: 5,
                ),
                if (e == 'LOW') Icon(Icons.arrow_downward_outlined),
                if (e == 'HIGH') Icon(Icons.arrow_upward_outlined),
                if (e == 'HIGHER') Icon(Icons.arrow_upward_outlined),
                if (e == 'HIGHER') Icon(Icons.arrow_upward_outlined),
                if (e == 'CRITICAL') Icon(Icons.warning_amber_sharp),
              ],
            ),
            value: e,
          );
        }).toList();
      },
    );
  }
}
