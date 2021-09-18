import 'dart:io';

import 'package:flutter/material.dart';
import 'package:productive_app/utils/task_validate.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../model/tag.dart';
import '../model/task.dart';
import '../model/taskLocation.dart';
import '../provider/attachment_provider.dart';
import '../provider/location_provider.dart';
import '../provider/task_provider.dart';
import 'button/add_task_button.dart';
import 'button/full_screen_button.dart';
import 'button/is_done_button.dart';
import 'new_task_attachment.dart';
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
  bool _isFullScreen = false;
  bool _isValid = true;
  bool _waiting = false;

  final newTaskTitleKey = GlobalKey<FormState>();
  final newTaskDescriptionKey = GlobalKey<FormState>();

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

  String _notificationLocalizationUuid;
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
  }

  void setNotificationLocalization(TaskLocation taskLocation) {
    setState(() {
      if (taskLocation != null && taskLocation.location != null) {
        this._notificationLocalizationUuid = taskLocation.location.uuid;
        this._notificationLocalizationRadius = taskLocation.notificationRadius;
        this._notificationOnEnter = taskLocation.notificationOnEnter;
        this._notificationOnExit = taskLocation.notificationOnExit;
      } else {
        this._notificationLocalizationUuid = null;
        this._notificationLocalizationRadius = null;
        this._notificationOnEnter = null;
        this._notificationOnExit = null;
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

  void clearForm() {
    this.newTaskTitleKey.currentState.reset();
    this.newTaskDescriptionKey.currentState.reset();
    setState(() {
      this._startDate = null;
      this._endDate = null;
      this._startTime = null;
      this._endTime = null;
      this._localization = this.widget.localization;
      this._isDone = false;
      this._priority = 'NORMAL';
      this._finalTags.forEach((element) {
        element.isSelected = false;
      });
      this._finalTags = [];
      this._notificationLocalizationUuid = null;
      this._notificationLocalizationRadius = null;
      this._notificationOnEnter = null;
      this._notificationOnExit = null;
      this._delegatedEmail = null;
      this._files = [];
    });
  }

  Future<void> _addNewTask() async {
    bool isValidTitle = this.newTaskTitleKey.currentState.validate();
    bool isValidRest = await TaskValidate.validateNewTask(this._startDate, this._endDate, this._localization, this._isDone, this._delegatedEmail, context);

    if (!isValidRest || !isValidTitle) {
      this._isValid = false;
    } else {
      this._isValid = true;
    }

    if (!this._isValid) {
      return;
    }

    setState(() {
      this._waiting = true;
    });

    this.newTaskTitleKey.currentState.save();
    this.newTaskDescriptionKey.currentState.save();

    if (this._startDate != null && this._startTime != null) {
      this._startDate = DateTime(this._startDate.year, this._startDate.month, this._startDate.day, this._startTime.hour, this._startTime.minute);
    }

    if (this._endDate != null && this._endTime != null) {
      this._endDate = DateTime(this._endDate.year, this._endDate.month, this._endDate.day, this._endTime.hour, this._endTime.minute);
    }

    final uuid = Uuid();

    final newTask = Task(
      uuid: uuid.v1(),
      id: null,
      title: this._taskName,
      startDate: this._startDate,
      endDate: this._endDate,
      done: this._isDone,
      priority: this._priority,
      tags: this._finalTags,
      description: this._taskDescription,
      localization: this._localization,
      delegatedEmail: this._delegatedEmail,
      isDelegated: false,
      taskStatus: null,
      isCanceled: false,
    );

    if (this._notificationLocalizationUuid != null) {
      newTask.notificationLocalizationUuid = this._notificationLocalizationUuid;
      newTask.notificationLocalizationRadius = this._notificationLocalizationRadius;
      newTask.notificationOnEnter = this._notificationOnEnter;
      newTask.notificationOnExit = this._notificationOnExit;
    }

    try {
      if (this._notificationLocalizationUuid == null) {
        await Provider.of<TaskProvider>(context, listen: false).addTask(newTask);

        await Provider.of<AttachmentProvider>(context, listen: false).setAttachments(this._files, newTask.uuid, false);
      } else {
        final latitude = Provider.of<LocationProvider>(context, listen: false).getLatitude(this._notificationLocalizationUuid);
        final longitude = Provider.of<LocationProvider>(context, listen: false).getLongitude(this._notificationLocalizationUuid);

        final taskId = await Provider.of<TaskProvider>(context, listen: false).addTaskWithGeolocation(newTask, latitude, longitude);

        await Provider.of<AttachmentProvider>(context, listen: false).setAttachments(this._files, newTask.uuid, false);
      }

      this.clearForm();

      setState(() {
        this._waiting = false;
      });
    } on SocketException catch (_) {
      this.clearForm();

      setState(() {
        this._waiting = false;
      });
    } catch (error) {
      setState(() {
        this._waiting = false;
      });
      print(error);
      throw (error);
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
      child: SingleChildScrollView(
        child: Container(
          height: this._screenHeight == null ? MediaQuery.of(context).size.height * 0.33 : this._screenHeight,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: ListTile(
                  isThreeLine: false,
                  horizontalTitleGap: 5,
                  minLeadingWidth: 20,
                  contentPadding: EdgeInsets.all(0),
                  leading: IsDoneButton(
                    isDone: this._isDone,
                    changeIsDoneStatus: this.changeIsDone,
                  ),
                  title: TaskTitle(setTaskName: this.setTaskName, newTaskTitleKey: this.newTaskTitleKey),
                  trailing: FullScreenButton(setFullScreen: this.setFullScreen),
                  subtitle: TaskDescription(
                    setTaskDescription: this.setTaskDescription,
                    newTaskDescriptionKey: this.newTaskDescriptionKey,
                    isFullScreen: this._isFullScreen,
                  ),
                ),
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
                        notificationLocalizationUuid: this._notificationLocalizationUuid,
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
                      if (this._waiting == true)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(backgroundColor: Theme.of(context).primaryColor),
                        )
                      else
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
      ),
    );
  }
}
