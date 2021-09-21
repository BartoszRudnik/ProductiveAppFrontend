import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:productive_app/config/const_values.dart';
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
  String taskUuid;
  DateFormat formatter = DateFormat("yyyy-MM-dd");
  TimeOfDay startTime;
  TimeOfDay endTime;
  IconData priorityIcon;

  Future<void> loadData() async {
    taskUuid = ModalRoute.of(context).settings.arguments as String;

    await Provider.of<TaskProvider>(context, listen: false).fetchSingleTask(taskUuid);

    originalTask = Provider.of<TaskProvider>(context, listen: false).getSingleTask;
    startTime = TimeOfDay(hour: originalTask.startDate.hour, minute: originalTask.startDate.minute);
    endTime = TimeOfDay(hour: originalTask.endDate.hour, minute: originalTask.endDate.minute);

    if (originalTask.priority == 'LOW') priorityIcon = Icons.arrow_downward_outlined;
    if (originalTask.priority == 'HIGH') priorityIcon = Icons.arrow_upward_outlined;
    if (originalTask.priority == 'HIGHER') priorityIcon = Icons.arrow_upward_outlined;
    if (originalTask.priority == 'HIGHER') priorityIcon = Icons.arrow_upward_outlined;
    if (originalTask.priority == 'CRITICAL') priorityIcon = Icons.warning_amber_sharp;
  }

  Future<void> a() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TaskAppBar(
        title: AppLocalizations.of(context).relatedTask,
      ),
      body: FutureBuilder(
        future: this.loadData(),
        builder: (_, snapshot) {
          if (originalTask == null) {
            return Center(child: Text(AppLocalizations.of(context).fetchingData));
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
                                AppLocalizations.of(context).owner,
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
                                AppLocalizations.of(context).description,
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
                                AppLocalizations.of(context).priority,
                                style: TextStyle(fontSize: 21),
                                textAlign: TextAlign.center,
                              ),
                            ]),
                            Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(priorityIcon),
                                Text(
                                  ConstValues.priorities(originalTask.priority, context),
                                  style: TextStyle(fontSize: 18),
                                  textAlign: TextAlign.center,
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
                                  AppLocalizations.of(context).startAndEndDate,
                                  style: TextStyle(fontSize: 21),
                                ),
                              ],
                            ),
                            Divider(),
                            formatter.format(originalTask.startDate) == "1970-01-01"
                                ? Text(
                                    AppLocalizations.of(context).noStartDate,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  )
                                : Text(
                                    AppLocalizations.of(context).startDate + ": " + formatter.format(originalTask.startDate) + ', ' + startTime.format(context),
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
                                    AppLocalizations.of(context).noEndDate,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  )
                                : Text(
                                    AppLocalizations.of(context).endDate + ": " + formatter.format(originalTask.endDate) + ', ' + endTime.format(context),
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
