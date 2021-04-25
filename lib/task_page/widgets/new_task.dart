import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../shared/dialogs.dart';
import '../models/tag.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import 'add_task_button.dart';
import 'full_screen_button.dart';
import 'is_done_button.dart';
import 'new_task_tags.dart';
import 'task_date.dart';
import 'task_delegate.dart';
import 'task_description.dart';
import 'task_localization.dart';
import 'task_priority.dart';
import 'task_title.dart';

class NewTask extends StatefulWidget {
  String localization;

  NewTask({
    @required this.localization,
  });

  @override
  _NewTaskState createState() => _NewTaskState();
}

class _NewTaskState extends State<NewTask> {
  var _isFullScreen = false;
  var _isValid = true;

  final _formKey = GlobalKey<FormState>();

  List<Tag> _finalTags = [];

  String _delegatedEmail = '';
  String _localization;
  String _priority = 'NORMAL';
  String _taskName = '';
  String _taskDescription = '';
  bool _isDone = false;

  DateTime _startDate;
  DateTime _endDate;
  TimeOfDay _startTime;
  TimeOfDay _endTime;

  @override
  void initState() {
    super.initState();
    this._localization = this.widget.localization;
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
    setState(() {
      this._isFullScreen = !this._isFullScreen;
    });
  }

  void setTags(List<Tag> newTags) {
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
    );

    print(this._delegatedEmail);

    try {
      await Provider.of<TaskProvider>(context, listen: false).addTask(newTask);

      this._formKey.currentState.reset();
      setState(() {
        this._startDate = null;
        this._endDate = null;
        this._localization = this.widget.localization;
        this._isDone = false;
        this._finalTags.forEach((element) {
          element.isSelected = false;
        });
        this._finalTags = [];
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

    return LayoutBuilder(
      builder: (context, constraint) {
        return SingleChildScrollView(
          child: Container(
            height: this._isFullScreen ? MediaQuery.of(context).size.height - 25 : null,
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
                    trailing: FullScreenButton(setFullScreen: this.setFullScreen),
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
                          IconButton(
                            icon: Icon(Icons.save),
                            onPressed: () {},
                          ),
                          TaskDelegate(
                            setDelegatedEmail: this.setDelegatedEmail,
                          ),
                          IconButton(
                            icon: Icon(Icons.attach_file_outlined),
                            onPressed: () {},
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
                          AddTaskButton(addNewTask: this._addNewTask),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
