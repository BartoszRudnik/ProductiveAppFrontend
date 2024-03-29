import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:productive_app/config/const_values.dart';
import 'package:productive_app/provider/attachment_provider.dart';
import 'package:productive_app/provider/locale_provider.dart';
import 'package:productive_app/provider/synchronize_provider.dart';
import 'package:productive_app/screen/task_details_loading_screen.dart';
import 'package:provider/provider.dart';

import '../model/task.dart';
import '../provider/location_provider.dart';
import '../provider/task_provider.dart';
import 'button/is_done_button.dart';
import 'task_tags.dart';

class TaskWidget extends StatefulWidget {
  final Task task;
  final key;

  TaskWidget({
    @required this.task,
    @required this.key,
  }) : super(key: key);

  @override
  _TaskWidgetState createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  void changeTaskStatus() async {
    this.widget.task.taskState = "COMPLETED";
    this.widget.task.done = true;

    if (this.widget.task.notificationLocalizationUuid == null) {
      await Provider.of<TaskProvider>(context, listen: false).updateTask(this.widget.task, 'COMPLETED');
    } else {
      final latitude = Provider.of<LocationProvider>(context, listen: false).getLatitude(this.widget.task.notificationLocalizationUuid);
      final longitude = Provider.of<LocationProvider>(context, listen: false).getLongitude(this.widget.task.notificationLocalizationUuid);

      await Provider.of<TaskProvider>(context, listen: false).updateTaskWithGeolocation(this.widget.task, 'COMPLETED', longitude, latitude);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isArchived = (this.widget.task.localization == 'COMPLETED' || this.widget.task.localization == 'TRASH');
    bool isPlanDo = !isArchived && !(this.widget.task.localization == 'INBOX');

    DateTime taskEndDate;
    DateTime today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

    if (this.widget.task.endDate != null) {
      taskEndDate = DateTime(this.widget.task.endDate.year, this.widget.task.endDate.month, this.widget.task.endDate.day);
    }

    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () {
            if (this.widget.task.isCanceled == null || !this.widget.task.isCanceled) {
              Navigator.of(context).pushNamed(
                TaskDetailsLoadingScreen.routeName,
                arguments: this.widget.task,
              );
            }
          },
          child: Dismissible(
            key: this.widget.key,
            background: this.widget.task.isCanceled == null || !this.widget.task.isCanceled
                ? Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    alignment: Alignment.centerLeft,
                    color: Theme.of(context).primaryColor,
                    child: Row(
                      children: [
                        Icon(
                          isArchived
                              ? Icons.restore_from_trash_outlined
                              : isPlanDo
                                  ? Icons.done_outline_outlined
                                  : Icons.navigate_next_outlined,
                          color: Theme.of(context).accentColor,
                          size: 50,
                        ),
                        Text(
                          isArchived
                              ? AppLocalizations.of(context).restore
                              : (isPlanDo ? AppLocalizations.of(context).completed : AppLocalizations.of(context).organize),
                          style: TextStyle(color: Theme.of(context).accentColor, fontSize: 20, fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  )
                : Container(),
            secondaryBackground: Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              alignment: Alignment.centerRight,
              color: Theme.of(context).primaryColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    isArchived ? AppLocalizations.of(context).delete : AppLocalizations.of(context).archive,
                    style: TextStyle(color: Theme.of(context).accentColor, fontSize: 20, fontWeight: FontWeight.w400),
                  ),
                  Icon(
                    Icons.archive_outlined,
                    color: Theme.of(context).accentColor,
                    size: 40,
                  ),
                ],
              ),
            ),
            // ignore: missing_return
            confirmDismiss: (direction) {
              if (direction == DismissDirection.endToStart) {
                return showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Center(
                      child: Text(
                        isArchived ? AppLocalizations.of(context).delete : AppLocalizations.of(context).archive,
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          isArchived ? AppLocalizations.of(context).areYouSureDeleteTask : AppLocalizations.of(context).areYouSureDeleteTask,
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                if (!isArchived) {
                                  String newLocation = 'TRASH';
                                  this.widget.task.taskState = "COMPLETED";

                                  await Provider.of<TaskProvider>(context, listen: false).updateTask(this.widget.task, newLocation);
                                } else {
                                  Provider.of<SynchronizeProvider>(context, listen: false).addTaskToDelete(
                                    this.widget.task.uuid,
                                  );
                                  Provider.of<AttachmentProvider>(context, listen: false)
                                      .deleteTasksAttachments(this.widget.task.uuid, this.widget.task.parentUuid);
                                  await Provider.of<TaskProvider>(context, listen: false).deleteTask(this.widget.task.uuid, this.widget.task.id);
                                }

                                Navigator.of(context).pop(true);
                              },
                              child: Text(AppLocalizations.of(context).yes),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop(false);
                              },
                              child: Text(
                                AppLocalizations.of(context).no,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              }
              if (direction == DismissDirection.startToEnd && (this.widget.task.isCanceled == null || !this.widget.task.isCanceled)) {
                String newLocation;

                if (this.widget.task.taskState == "COMPLETED") {
                  this.widget.task.done = false;
                  this.widget.task.taskState = "PLAN&DO";
                  if (this.widget.task.delegatedEmail == null) {
                    if (this.widget.task.startDate != null) {
                      newLocation = 'SCHEDULED';
                    } else {
                      newLocation = 'ANYTIME';
                    }
                  } else {
                    newLocation = 'DELEGATED';
                  }
                } else if (isPlanDo || this.widget.task.done) {
                  this.widget.task.taskState = "COMPLETED";
                  newLocation = "COMPLETED";
                  this.widget.task.done = true;
                } else {
                  this.widget.task.taskState = "PLAN&DO";
                  if (this.widget.task.delegatedEmail == null) {
                    if (this.widget.task.startDate != null) {
                      newLocation = 'SCHEDULED';
                    } else {
                      newLocation = 'ANYTIME';
                    }
                  } else {
                    newLocation = 'DELEGATED';
                  }
                }

                if (this.widget.task.notificationLocalizationUuid == null) {
                  Provider.of<TaskProvider>(context, listen: false).updateTask(this.widget.task, newLocation);
                } else {
                  final longitude = Provider.of<LocationProvider>(context, listen: false).getLongitude(this.widget.task.notificationLocalizationUuid);
                  final latitude = Provider.of<LocationProvider>(context, listen: false).getLatitude(this.widget.task.notificationLocalizationUuid);

                  Provider.of<TaskProvider>(context, listen: false).updateTaskWithGeolocation(this.widget.task, newLocation, longitude, latitude);
                }
              }
            },
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    if (!isArchived && (this.widget.task.isCanceled == null || !this.widget.task.isCanceled))
                      IsDoneButton(
                        isDone: this.widget.task.done,
                        changeIsDoneStatus: this.changeTaskStatus,
                      ),
                    SizedBox(
                      width: 7,
                    ),
                    Flexible(
                      child: Text(
                        this.widget.task.title,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'RobotoCondensed',
                          decoration: this.widget.task.localization == "COMPLETED" ||
                                  this.widget.task.done ||
                                  (this.widget.task.isCanceled != null && this.widget.task.isCanceled)
                              ? TextDecoration.lineThrough
                              : null,
                          color: this.widget.task.done || (this.widget.task.isCanceled != null && this.widget.task.isCanceled)
                              ? Colors.grey
                              : Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                    SizedBox(width: 7),
                    if (this.widget.task.isDelegated != null && this.widget.task.isDelegated) Icon(Icons.supervisor_account_outlined),
                    if (this.widget.task.delegatedEmail != null && this.widget.task.localization == 'DELEGATED' && this.widget.task.taskStatus != null)
                      Container(
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
                            ConstValues.taskStatus(this.widget.task.taskStatus, context),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    if (this.widget.task.isCanceled != null && this.widget.task.isCanceled)
                      Container(
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
                            AppLocalizations.of(context).canceled,
                            textAlign: TextAlign.center,
                          ),
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            child: Row(
                              children: [
                                if (this.widget.task.priority == 'LOW') Icon(Icons.arrow_downward_outlined),
                                if (this.widget.task.priority == 'HIGH') Icon(Icons.arrow_upward_outlined),
                                if (this.widget.task.priority == 'HIGHER') Icon(Icons.arrow_upward_outlined),
                                if (this.widget.task.priority == 'HIGHER') Icon(Icons.arrow_upward_outlined),
                                if (this.widget.task.priority == 'CRITICAL') Icon(Icons.warning_amber_sharp),
                                SizedBox(width: 6),
                                if (this.widget.task.startDate != null || this.widget.task.endDate != null) Icon(Icons.calendar_today),
                                SizedBox(width: 6),
                                this.widget.task.startDate != null
                                    ? Text(
                                        DateFormat.MMMd(Provider.of<LocaleProvider>(context, listen: false).locale.languageCode)
                                                .format(this.widget.task.startDate) +
                                            ' - ',
                                      )
                                    : Text(''),
                                this.widget.task.endDate != null
                                    ? Text(
                                        DateFormat.MMMd(Provider.of<LocaleProvider>(context, listen: false).locale.languageCode)
                                            .format(this.widget.task.endDate),
                                      )
                                    : Text(''),
                              ],
                            ),
                          ),
                          if (this.widget.task.endDate != null)
                            Container(
                              child: Row(
                                children: [
                                  if (taskEndDate.difference(today).inDays == 0 && this.widget.task.endDate.hour != 0 && this.widget.task.endDate.minute != 0)
                                    Icon(Icons.access_time_outlined),
                                  if (taskEndDate.difference(today).inDays == 0 && this.widget.task.endDate.hour != 0 && this.widget.task.endDate.minute != 0)
                                    Text(
                                      DateFormat('Hm').format(this.widget.task.endDate),
                                    ),
                                  if (taskEndDate.difference(today).inDays < 0) Icon(Icons.fireplace_outlined),
                                  if (taskEndDate.difference(today).inDays < 0)
                                    Text(today.difference(taskEndDate).inDays.toString() + AppLocalizations.of(context).overdue),
                                  if (taskEndDate.difference(today).inDays > 0) Icon(Icons.hourglass_bottom_outlined),
                                  if (taskEndDate.difference(today).inDays > 0)
                                    Text(AppLocalizations.of(context).left(taskEndDate.difference(today).inDays.toString())),
                                ],
                              ),
                            )
                        ],
                      ),
                    if (this.widget.task.priority != 'NORMAL' ||
                        this.widget.task.startDate != null ||
                        this.widget.task.endDate != null ||
                        this.widget.task.isDelegated != null)
                      SizedBox(
                        height: 4,
                      ),
                    TaskTags(tags: this.widget.task.tags),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
