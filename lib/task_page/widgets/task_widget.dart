import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/task_provider.dart';
import '../task_screens/task_details_screen.dart';

class TaskWidget extends StatefulWidget {
  final task;
  final taskKey;

  TaskWidget({
    @required this.task,
    @required this.taskKey,
  });

  @override
  _TaskWidgetState createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      //height: 94,
      width: 319,
      padding: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 7,
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed(TaskDetailScreen.routeName);
        },
        child: Slidable(
          key: this.widget.taskKey,
          actionPane: SlidableStrechActionPane(),
          actionExtentRatio: 0.3,
          closeOnScroll: true,
          actions: [
            IconSlideAction(
              caption: 'Move to Anytime',
              color: Theme.of(context).primaryColor,
              onTap: () {},
              iconWidget: Icon(
                Icons.access_time_sharp,
                color: Theme.of(context).accentColor,
              ),
            ),
            IconSlideAction(
              caption: 'Move to Scheduled',
              color: Theme.of(context).primaryColor,
              onTap: () {},
              iconWidget: Icon(
                Icons.calendar_today,
                color: Theme.of(context).accentColor,
              ),
            )
          ],
          secondaryActions: [
            IconSlideAction(
              caption: 'Edit',
              color: Theme.of(context).primaryColor,
              onTap: () {},
              iconWidget: Icon(
                Icons.edit_outlined,
                color: Theme.of(context).accentColor,
              ),
            ),
            IconSlideAction(
              caption: this.widget.task.done ? 'Mark as undone' : 'Mark as done',
              color: Theme.of(context).primaryColor,
              onTap: () {
                Provider.of<TaskProvider>(context, listen: false).toggleTaskStatus(this.widget.task.id);
              },
              iconWidget: Icon(
                this.widget.task.done ? Icons.not_interested_outlined : Icons.done,
                color: Theme.of(context).accentColor,
              ),
            ),
            IconSlideAction(
              closeOnTap: false,
              caption: 'Archive',
              color: Theme.of(context).primaryColor,
              onTap: () {
                return showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Center(
                      child: Text(
                        'Archive',
                        style: Theme.of(context).textTheme.headline3,
                      ),
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Are you sure you want to archive this task?'),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Theme.of(context).primaryColor,
                                side: BorderSide(color: Theme.of(context).primaryColor),
                              ),
                              onPressed: () {
                                Provider.of<TaskProvider>(context, listen: false).deleteTask(this.widget.task.id);
                                Navigator.of(context).pop(true);
                              },
                              child: Text(
                                'Yes',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context).accentColor,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Theme.of(context).primaryColor,
                                side: BorderSide(color: Theme.of(context).primaryColor),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop(false);
                              },
                              child: Text(
                                'No',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context).accentColor,
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
                // Task tmpTask = this.widget.task;
                // ScaffoldMessenger.of(context).hideCurrentSnackBar();
                // ScaffoldMessenger.of(context).showSnackBar(
                //   SnackBar(
                //     duration: Duration(
                //       seconds: 3,
                //     ),
                //     content: Text(
                //       'Task archived',
                //       style: TextStyle(
                //         fontSize: 16,
                //       ),
                //     ),
                //     action: SnackBarAction(
                //       label: 'UNDO',
                //       onPressed: () {
                //         Provider.of<TaskProvider>(context, listen: false).addTask(tmpTask);
                //       },
                //     ),
                //   ),
                // );
                // Provider.of<TaskProvider>(context, listen: false).deleteTask(this.widget.task.id);
              },
              iconWidget: Icon(
                Icons.delete,
                color: Theme.of(context).accentColor,
              ),
            ),
          ],
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  RawMaterialButton(
                    focusElevation: 0,
                    child: this.widget.task.done
                        ? Icon(
                            Icons.done,
                            color: Colors.white,
                            size: 14,
                          )
                        : null,
                    onPressed: () {
                      Provider.of<TaskProvider>(context, listen: false).toggleTaskStatus(this.widget.task.id);
                    },
                    constraints: BoxConstraints(minWidth: 20, minHeight: 18),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    fillColor: this.widget.task.done ? Colors.grey : Theme.of(context).accentColor,
                    shape: CircleBorder(
                      side: BorderSide(
                        color: Theme.of(context).primaryColor,
                        width: 1,
                      ),
                    ),
                    padding: EdgeInsets.zero,
                  ),
                  SizedBox(
                    width: 7,
                  ),
                  Text(
                    this.widget.task.title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'RobotoCondensed',
                      decoration: this.widget.task.done ? TextDecoration.lineThrough : null,
                      color: this.widget.task.done ? Colors.grey : Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 9,
              ),
              Column(
                children: <Widget>[
                  if (this.widget.task.priority != 'NORMAL' || this.widget.task.startDate != null || this.widget.task.endDate != null)
                    Row(
                      children: <Widget>[
                        if (this.widget.task.priority == 'SMALL') Icon(Icons.arrow_downward_outlined),
                        if (this.widget.task.priority == 'HIGH') Icon(Icons.arrow_upward_outlined),
                        if (this.widget.task.priority == 'HIGHER') Icon(Icons.arrow_upward_outlined),
                        if (this.widget.task.priority == 'HIGHER') Icon(Icons.arrow_upward_outlined),
                        if (this.widget.task.priority == 'CRITICAL') Icon(Icons.warning_amber_sharp),
                        SizedBox(width: 6),
                        if (this.widget.task.startDate != null || this.widget.task.endDate != null) Icon(Icons.calendar_today),
                        SizedBox(width: 6),
                        this.widget.task.startDate != null
                            ? Text(
                                DateFormat('MMM d').format(this.widget.task.startDate) + ' - ',
                              )
                            : Text(''),
                        this.widget.task.endDate != null
                            ? Text(
                                DateFormat('MMM d').format(this.widget.task.endDate),
                              )
                            : Text(''),
                      ],
                    ),
                  if (this.widget.task.priority != 'NORMAL' || this.widget.task.startDate != null || this.widget.task.endDate != null)
                    SizedBox(
                      height: 4,
                    ),
                  Container(
                    alignment: Alignment.centerLeft,
                    height: 20,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemCount: this.widget.task.tags.length,
                      itemBuilder: (ctx, secondIndex) => Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(horizontal: 4),
                        margin: EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Theme.of(context).primaryColor,
                            width: 0.2,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            this.widget.task.tags[secondIndex],
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
