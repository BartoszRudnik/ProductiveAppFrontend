import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../model/task.dart';
import '../provider/task_provider.dart';
import '../widget/appBar/task_appBar.dart';

class RelatedTaskInfoScreen extends StatefulWidget {
  static const routeName = '/related-task-info-screen';

  @override
  _RelatedTaskInfoScreenState createState() => _RelatedTaskInfoScreenState();
}

class _RelatedTaskInfoScreenState extends State<RelatedTaskInfoScreen> {
  Task originalTask;
  int taskId = 0;
  DateFormat formatter = DateFormat("yyyy-MM-dd");
  TimeOfDay startTime;
  TimeOfDay endTime;
  IconData priorityIcon;

  Future<void> loadData() async {
    taskId = ModalRoute.of(context).settings.arguments as int;

    await Provider.of<TaskProvider>(context, listen: false).fetchSingleTask(taskId);

    originalTask = Provider.of<TaskProvider>(context, listen: false).getSingleTask;
    startTime = TimeOfDay(hour: originalTask.startDate.hour, minute: originalTask.startDate.minute);
    endTime = TimeOfDay(hour: originalTask.endDate.hour, minute: originalTask.endDate.minute);

    if (originalTask.priority == 'LOW') priorityIcon = Icons.arrow_downward_outlined;
    if (originalTask.priority == 'HIGH') priorityIcon = Icons.arrow_upward_outlined;
    if (originalTask.priority == 'HIGHER') priorityIcon = Icons.arrow_upward_outlined;
    if (originalTask.priority == 'HIGHER') priorityIcon = Icons.arrow_upward_outlined;
    if (originalTask.priority == 'CRITICAL') priorityIcon = Icons.warning_amber_sharp;
  }

  @override
  void initState() {
    super.initState();
  }

  Future<void> a() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TaskAppBar(
        title: 'Related task',
      ),
      body: FutureBuilder(
        future: this.loadData(),
        builder: (_, snapshot) {
          if (originalTask == null) {
            return Center(child: Text("Fetching data"));
          } else {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
                child: RefreshIndicator(
                  onRefresh: () => this.a(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: 6, left: 6, bottom: 6),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColorLight,
                          border: Border.all(
                            color: Theme.of(context).primaryColorDark,
                            width: 2.5,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            originalTask.title,
                            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        padding: EdgeInsets.only(top: 6, left: 6, bottom: 6),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColorLight,
                          border: Border.all(
                            color: Theme.of(context).primaryColorDark,
                            width: 2.5,
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                              Icon(Icons.person),
                              Text(
                                "Owner",
                                style: TextStyle(fontSize: 21),
                              ),
                            ]),
                            Divider(),
                            Text(
                              originalTask.supervisorEmail,
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        padding: EdgeInsets.only(top: 6, left: 6, bottom: 6),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColorLight,
                          border: Border.all(
                            color: Theme.of(context).primaryColorDark,
                            width: 2.5,
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                              Icon(Icons.edit),
                              Text(
                                "Description",
                                style: TextStyle(fontSize: 21),
                              ),
                            ]),
                            Divider(),
                            Text(
                              originalTask.description,
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        padding: EdgeInsets.only(top: 6, left: 6, bottom: 6),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColorLight,
                          border: Border.all(
                            color: Theme.of(context).primaryColorDark,
                            width: 2.5,
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                              Icon(Icons.flag),
                              Text(
                                "Priority",
                                style: TextStyle(fontSize: 21),
                              ),
                            ]),
                            Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(priorityIcon),
                                Text(
                                  originalTask.priority,
                                  style: TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        padding: EdgeInsets.only(top: 6, left: 6, bottom: 6),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColorLight,
                          border: Border.all(
                            color: Theme.of(context).primaryColorDark,
                            width: 2.5,
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.calendar_today),
                                Text(
                                  "Start and due date",
                                  style: TextStyle(fontSize: 21),
                                ),
                              ],
                            ),
                            Divider(),
                            formatter.format(originalTask.startDate) == "1970-01-01"
                                ? Text(
                                    'No start date',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  )
                                : Text(
                                    'Start date: ' + formatter.format(originalTask.startDate) + ', ' + startTime.format(context),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                            SizedBox(
                              height: 10,
                            ),
                            formatter.format(originalTask.endDate) == "1970-01-01"
                                ? Text(
                                    'No due date',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  )
                                : Text(
                                    'Due date: ' + formatter.format(originalTask.endDate) + ', ' + endTime.format(context),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
