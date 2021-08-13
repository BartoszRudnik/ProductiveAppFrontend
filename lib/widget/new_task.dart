import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:productive_app/provider/attachment_provider.dart';
import 'package:productive_app/widget/new_task_attachment.dart';
import 'package:provider/provider.dart';
import '../model/tag.dart';
import '../model/task.dart';
import '../model/taskLocation.dart';
import '../provider/location_provider.dart';
import '../provider/task_provider.dart';
import '../utils/dialogs.dart';
import 'button/add_task_button.dart';
import 'button/full_screen_button.dart';
import 'button/is_done_button.dart';
import 'new_task_notification_localization.dart';
import 'new_task_tags.dart';
import 'task_date.dart';
import 'task_delegate.dart';
import 'task_description.dart';
import 'task_localization.dart';
import 'task_priority.dart';
import 'task_title.dart';

class NewTask extends StatefulWidget {
  final String localization;

  NewTask({
    @required this.localization,
  });

  @override
  _NewTaskState createState() => _NewTaskState();
}

class _NewTaskState extends State<NewTask> {
  double _screenHeight;
  var _isFullScreen = false;
  var _isValid = true;

  final _formKey = GlobalKey<FormState>();

  List<Tag> _finalTags = [];
  List<File> _files = [];

  String _delegatedEmail;
  String _localization;
  String _priority = 'NORMAL';
  String _taskName = '';
  String _taskDescription = '';
  bool _isDone = false;

  DateTime _startDate;
  DateTime _endDate;
  TimeOfDay _startTime;
  TimeOfDay _endTime;

  int _notificationLocalizationId;
  double _notificationLocalizationRadius;
  bool _notificationOnEnter;
  bool _notificationOnExit;

  @override
  void initState() {
    super.initState();
    this._localization = this.widget.localization;
  }

  void _setAttachment(List<File> result) {
    if (result == null) return;

    setState(() {
      this._files = result;
    });

    this._files.forEach((element) {
      print(element.path);
    });
  }

  void setNotificationLocalization(TaskLocation taskLocation) {
    setState(() {
      if (taskLocation.location != null) {
        this._notificationLocalizationId = taskLocation.location.id;
        this._notificationLocalizationRadius = taskLocation.notificationRadius;
        this._notificationOnEnter = taskLocation.notificationOnEnter;
        this._notificationOnExit = taskLocation.notificationOnExit;
      }
    });
  }

  void setDate(DateTime startDate, DateTime endDate, TimeOfDay startTime, TimeOfDay endTime) {
    this._startDate = startDate;
    this._endDate = endDate;
    this._startTime = startTime;
    this._endTime = endTime;
  }

  void setDelegatedEmail(String value) {
    if (value == null) return;

    this._delegatedEmail = value;
  }

  void changeIsDone() {
    this._isDone = !this._isDone;
  }

  void setTaskName(String value) {
    this._taskName = value;
  }

  void setTaskDescription(String value) {
    this._taskDescription = value;
  }

  void setPriority(String value) {
    this._priority = value;
  }

  void setLocalization(String value) {
    this._localization = value;
  }

  void setFullScreen() {
    setState(
      () {
        this._isFullScreen = !this._isFullScreen;

        if (this._isFullScreen) {
          this._screenHeight = MediaQuery.of(context).size.height * 0.95;
        } else {
          this._screenHeight = MediaQuery.of(context).size.height * 0.33;
        }
      },
    );
  }

  void setTags(List<Tag> newTags) {
    if (newTags == null) return;

    this._finalTags = newTags;
  }

  Future<void> _addNewTask() async {
    var isValid = this._formKey.currentState.validate();

    if (this._localization == 'SCHEDULED' && this._startDate == null) {
      Dialogs.showWarningDialog(context, 'Planned task need to have start date');
      return;
    }

    if (this._startDate != null && this._endDate != null && this._endDate.isBefore(this._startDate)) {
      Dialogs.showWarningDialog(context, 'End date must be before start date');
      return;
    }

    if (this._localization == 'DELEGATED' && this._delegatedEmail == null) {
      Dialogs.showWarningDialog(context, "Delegated tasks must have delegated person");
      return;
    }

    setState(() {
      this._isValid = isValid;
    });

    if (!this._isValid) {
      return;
    }

    this._formKey.currentState.save();

    if (this._startDate != null && this._startTime != null) {
      this._startDate = DateTime(this._startDate.year, this._startDate.month, this._startDate.day, this._startTime.hour, this._startTime.minute);
    }

    if (this._endDate != null && this._endTime != null) {
      this._endDate = DateTime(this._endDate.year, this._endDate.month, this._endDate.day, this._endTime.hour, this._endTime.minute);
    }

    final newTask = Task(
      id: null,
      title: this._taskName,
      startDate: this._startDate,
      endDate: this._endDate,
      done: this._isDone,
      priority: this._priority,
      tags: this._finalTags,
      description: this._taskDescription,
      localization: this._localization,
      position: null,
      delegatedEmail: this._delegatedEmail,
      isDelegated: false,
      taskStatus: null,
      isCanceled: false,
    );

    if (this._notificationLocalizationId != null) {
      newTask.notificationLocalizationId = this._notificationLocalizationId;
      newTask.notificationLocalizationRadius = this._notificationLocalizationRadius;
      newTask.notificationOnEnter = this._notificationOnEnter;
      newTask.notificationOnExit = this._notificationOnExit;
    }

    try {
      if (this._notificationLocalizationId == null) {
        final taskId = await Provider.of<TaskProvider>(context, listen: false).addTask(newTask);

        await Provider.of<AttachmentProvider>(context, listen: false).setAttachments(this._files, taskId, false);
      } else {
        final latitude = Provider.of<LocationProvider>(context, listen: false).getLatitude(this._notificationLocalizationId);
        final longitude = Provider.of<LocationProvider>(context, listen: false).getLongitude(this._notificationLocalizationId);

        final taskId = await Provider.of<TaskProvider>(context, listen: false).addTaskWithGeolocation(newTask, latitude, longitude);

        await Provider.of<AttachmentProvider>(context, listen: false).setAttachments(this._files, taskId, false);
      }

      this._formKey.currentState.reset();
      setState(() {
        this._startDate = null;
        this._endDate = null;
        this._startTime = null;
        this._endTime = null;
        this._localization = this.widget.localization;
        this._isDone = false;
        this._finalTags.forEach((element) {
          element.isSelected = false;
        });
        this._finalTags = [];
        this._notificationLocalizationId = null;
        this._notificationLocalizationRadius = null;
        this._notificationOnEnter = null;
        this._notificationOnExit = null;
        this._delegatedEmail = null;
      });
    } catch (error) {
      print(error);
      throw error;
    }
  }

  @override
  Widget build(BuildContext context) {
    final priorities = Provider.of<TaskProvider>(context, listen: false).priorities;
    final localizations = Provider.of<TaskProvider>(context, listen: false).localizations;

    return AnimatedContainer(
      color: Theme.of(context).brightness == Brightness.dark ? Colors.grey[700] : Colors.white,
      curve: Curves.easeInOut,
      duration: Duration(milliseconds: 300),
      height: this._screenHeight == null ? MediaQuery.of(context).size.height * 0.33 : this._screenHeight,
      padding: EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Form(
        key: this._formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ListTile(
              isThreeLine: true,
              horizontalTitleGap: 5,
              minLeadingWidth: 20,
              contentPadding: EdgeInsets.all(0),
              leading: IsDoneButton(
                isDone: this._isDone,
                changeIsDoneStatus: this.changeIsDone,
              ),
              title: TaskTitle(setTaskName: this.setTaskName),
              trailing: FullScreenButton(
                setFullScreen: this.setFullScreen,
              ),
              subtitle: TaskDescription(setTaskDescription: this.setTaskDescription),
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TaskPriority(
                      setTaskPriority: this.setPriority,
                      priority: this._priority,
                      priorities: priorities,
                    ),
                    TaskDate(
                      startValue: this._startDate,
                      endValue: this._endDate,
                      startTime: this._startTime,
                      endTime: this._endTime,
                      setDate: this.setDate,
                    ),
                    NewTaskTags(
                      setTags: this.setTags,
                      finalTags: this._finalTags,
                    ),
                    NewTaskNotificationLocalization(
                      setNotificationLocalization: this.setNotificationLocalization,
                      notificationLocalizationId: this._notificationLocalizationId,
                      notificationOnEnter: this._notificationOnEnter,
                      notificationOnExit: this._notificationOnExit,
                      notificationRadius: this._notificationLocalizationRadius,
                    ),
                    TaskDelegate(
                      setDelegatedEmail: this.setDelegatedEmail,
                      collaboratorEmail: this._delegatedEmail,
                    ),
                    NewTaskAttachment(
                      setAttachments: this._setAttachment,
                      files: this._files,
                    ),
                  ],
                ),
                Divider(
                  thickness: 1.5,
                  color: Theme.of(context).primaryColor,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TaskLocalization(
                      localization: this._localization,
                      localizations: localizations,
                      setLocalization: this.setLocalization,
                    ),
                    AddTaskButton(
                      addNewTask: this._addNewTask,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
