import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../config/color_themes.dart';
import '../model/attachment.dart';
import '../model/task.dart';
import '../model/taskLocation.dart';
import '../provider/attachment_provider.dart';
import '../provider/location_provider.dart';
import '../provider/task_provider.dart';
import '../utils/date_time_pickers.dart';
import '../utils/dialogs.dart';
import '../utils/notifications.dart';
import '../widget/appBar/details_appBar.dart';
import '../widget/dialog/delegate_dialog.dart';
import '../widget/dialog/notification_location_dialog.dart';
import '../widget/dialog/tags_dialog.dart';
import '../widget/task_details_attachments.dart';
import '../widget/task_details_attributes.dart';
import '../widget/task_details_bottom_bar.dart';
import '../widget/task_details_dates.dart';
import '../widget/task_details_map.dart';
import '../widget/task_tags_edit.dart';

class TaskDetailScreen extends StatefulWidget {
  static const routeName = "/task-details";

  @override
  _TaskDetailScreenState createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> with TickerProviderStateMixin {
  FocusNode _descriptionFocus = new FocusNode();
  final _formKey = GlobalKey<FormState>();
  Task taskToEdit;
  Task originalTask;

  TimeOfDay startTime;
  TimeOfDay endTime;

  List<int> newAttachments = [];

  bool _locationChanged = false;
  bool _isFocused = false;
  bool _isDescriptionInitial = true;
  String _description = "";
  DateFormat formatter = DateFormat("yyyy-MM-dd");

  @override
  void initState() {
    _descriptionFocus.addListener(onDescriptionFocusChange);
    taskToEdit = null;

    Provider.of<AttachmentProvider>(context, listen: false).prepare();

    super.initState();
  }

  void setNewAttachments(List<int> newAttachments) {
    this.newAttachments = newAttachments;
  }

  void onDescriptionFocusChange() {
    setState(() {
      _isFocused = !_isFocused;
    });
    checkColor();
  }

  void onDescriptionChanged(String text) {
    setState(() {
      _description = text;
    });
    checkColor();
  }

  bool differentNotification(Task newTask, Task oldTask) {
    if (newTask.notificationLocalizationId != null && oldTask.notificationLocalizationId == null) {
      return true;
    } else if (newTask.notificationLocalizationId != null && oldTask.notificationLocalizationId != null) {
      if (newTask.notificationLocalizationId != oldTask.notificationLocalizationId ||
          newTask.notificationLocalizationRadius != oldTask.notificationLocalizationRadius ||
          newTask.notificationOnEnter != oldTask.notificationOnEnter ||
          newTask.notificationOnExit != oldTask.notificationOnExit) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  void checkColor() {
    setState(() {
      _isDescriptionInitial = true;
      if (_description.isNotEmpty) {
        _isDescriptionInitial = false;
      }
      if (_isFocused) {
        _isDescriptionInitial = false;
      }
    });
  }

  Future<void> selectStartTime() async {
    final TimeOfDay pickTime = await DateTimePickers.pickTime(context);

    setState(() {
      this.startTime = pickTime;
    });
  }

  Future<void> selectEndTime() async {
    final TimeOfDay pickTime = await DateTimePickers.pickTime(context);

    setState(() {
      this.endTime = pickTime;
    });
  }

  Future<void> selectStartDate() async {
    DateTime initDate = taskToEdit.startDate;
    if (taskToEdit.startDate == null) {
      initDate = DateTime.now();
    }
    final DateTime pick = await DateTimePickers.pickDate(initDate, context);

    taskToEdit.startDate = pick;
    this.setTaskListAutomatically();
  }

  Future<void> selectEndDate() async {
    DateTime initDate = taskToEdit.endDate;
    if (taskToEdit.endDate == null) {
      initDate = DateTime.now();
    }
    final DateTime pick = await DateTimePickers.pickDate(initDate, context);

    taskToEdit.endDate = pick;

    this.setTaskListAutomatically();
  }

  Future<void> saveTask() async {
    bool isValid = this._formKey.currentState.validate();

    if (taskToEdit.startDate == null && taskToEdit.localization == "SCHEDULED") {
      isValid = false;
      Dialogs.showWarningDialog(context, "Scheduled tasks have to specify start date");
    }

    if (taskToEdit.startDate != null && taskToEdit.localization == "ANYTIME") {
      isValid = false;
      Dialogs.showWarningDialog(context, "Tasks with start date should be scheduled");
    }

    if (taskToEdit.localization == "COMPLETED" && !taskToEdit.done) {
      isValid = false;
      Dialogs.showWarningDialog(context, "Completed tasks have to be marked as done");
    }

    if (originalTask.localization != "INBOX" && taskToEdit.localization == "INBOX") {
      isValid = false;
      Dialogs.showWarningDialog(context, "Task cannot return to inbox");
    }

    if (taskToEdit.localization == 'DELEGATED' && (taskToEdit.delegatedEmail == null || taskToEdit.delegatedEmail.length <= 1)) {
      isValid = false;
      Dialogs.showWarningDialog(context, "Delegated task must have delegated person");
    }

    if (originalTask.localization == 'DELEGATED' && taskToEdit.localization != 'DELEGATED' && taskToEdit.delegatedEmail != null) {
      isValid = false;
      Dialogs.showWarningDialog(context, "Task with specified delegated person must be on delegated list");
    }

    if (originalTask.supervisorEmail != null && originalTask.supervisorEmail == taskToEdit.delegatedEmail) {
      isValid = false;
      Dialogs.showWarningDialog(context, 'Cannot delegate task to principal');
    }
    if (taskToEdit.endDate.isBefore(taskToEdit.startDate)) {
      isValid = false;
      Dialogs.showWarningDialog(context, 'End date must be later than start date');
    }

    if (!isValid) {
      return;
    }

    this._formKey.currentState.save();

    try {
      if (this.taskToEdit.delegatedEmail != null && this.taskToEdit.localization != 'DELEGATED' && (originalTask.localization == 'ANYTIME' || originalTask.localization == 'SCHEDULED')) {
        this.taskToEdit.localization = 'DELEGATED';
      }

      if (this.startTime != null && taskToEdit.startDate != null) {
        taskToEdit.startDate = new DateTime(taskToEdit.startDate.year, taskToEdit.startDate.month, taskToEdit.startDate.day, this.startTime.hour, this.startTime.minute);
      } else if (taskToEdit.startDate != null) {
        taskToEdit.startDate = new DateTime(taskToEdit.startDate.year, taskToEdit.startDate.month, taskToEdit.startDate.day, 0, 0);
      }

      if (this.endTime != null && taskToEdit.endDate != null) {
        taskToEdit.endDate = new DateTime(taskToEdit.endDate.year, taskToEdit.endDate.month, taskToEdit.endDate.day, this.endTime.hour, this.endTime.minute);
      } else if (taskToEdit.endDate != null) {
        taskToEdit.endDate = new DateTime(taskToEdit.endDate.year, taskToEdit.endDate.month, taskToEdit.endDate.day, 0, 0);
      }

      final newLocalization = taskToEdit.localization;
      taskToEdit.localization = originalTask.localization;

      if (taskToEdit.done != originalTask.done) {
        if (taskToEdit.notificationLocalizationId != null) {
          if (taskToEdit.done) {
            Notifications.removeGeofence(taskToEdit.id);
          } else {
            double latitude = Provider.of<LocationProvider>(context, listen: false).getLatitude(taskToEdit.notificationLocalizationId);
            double longitude = Provider.of<LocationProvider>(context, listen: false).getLongitude(taskToEdit.notificationLocalizationId);

            Notifications.addGeofence(
              taskToEdit.id,
              latitude,
              longitude,
              taskToEdit.notificationLocalizationRadius,
              taskToEdit.notificationOnEnter,
              taskToEdit.notificationOnExit,
              taskToEdit.title,
              taskToEdit.description,
            );
          }
        }
        await Provider.of<TaskProvider>(context, listen: false).updateTask(taskToEdit, newLocalization);
      } else if (this.differentNotification(taskToEdit, originalTask)) {
        final latitude = Provider.of<LocationProvider>(context, listen: false).getLatitude(taskToEdit.notificationLocalizationId);
        final longitude = Provider.of<LocationProvider>(context, listen: false).getLongitude(taskToEdit.notificationLocalizationId);

        await Provider.of<TaskProvider>(context, listen: false).updateTaskWithGeolocation(taskToEdit, newLocalization, longitude, latitude);
      } else {
        await Provider.of<TaskProvider>(context, listen: false).updateTask(taskToEdit, newLocalization);
      }

      if (this.originalTask.localization != newLocalization) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Your task has been moved to $newLocalization.'),
            duration: Duration(seconds: 2),
          ),
        );
      }

      await Provider.of<AttachmentProvider>(context, listen: false).deleteFlaggedAttachments();
      Provider.of<TaskProvider>(context, listen: false).deleteFromLocalization(originalTask);
    } catch (error) {
      print(error);
      Dialogs.showWarningDialog(context, "An error has occured");
    }
    Navigator.of(context).pop();
  }

  Future<void> deleteTask() async {
    bool accepted = await Dialogs.showChoiceDialog(context, "Are you sure you want to archive this task?");
    if (accepted) {
      originalTask.done = taskToEdit.done;
      setTaskToEdit(originalTask);
      if (taskToEdit.done) {
        taskToEdit.localization = "COMPLETED";
      } else {
        taskToEdit.localization = "TRASH";
      }
      try {
        await Provider.of<AttachmentProvider>(context, listen: false).deleteFlaggedAttachments();
        await Provider.of<TaskProvider>(context, listen: false).updateTask(taskToEdit, taskToEdit.localization);
        Provider.of<TaskProvider>(context, listen: false).deleteFromLocalization(originalTask);
      } catch (error) {
        Dialogs.showWarningDialog(context, "An error has occured");
      }
      Navigator.pop(context);
    }
  }

  void setNotificationLocalization(TaskLocation taskLocation) {
    setState(() {
      if (taskLocation != null && taskLocation.location != null) {
        this.taskToEdit.notificationLocalizationId = taskLocation.location.id;
        this.taskToEdit.notificationLocalizationRadius = taskLocation.notificationRadius;
        this.taskToEdit.notificationOnEnter = taskLocation.notificationOnEnter;
        this.taskToEdit.notificationOnExit = taskLocation.notificationOnExit;

        this._locationChanged = true;
      }
    });
  }

  void deleteNotificationLocalization() {
    setState(() {
      this.taskToEdit.notificationLocalizationId = null;
      this.taskToEdit.notificationLocalizationRadius = 0.1;
      this.taskToEdit.notificationOnEnter = false;
      this.taskToEdit.notificationOnExit = false;
    });
  }

  Future<void> editTags(BuildContext context) async {
    final newTags = await showDialog(
        context: context,
        builder: (context) {
          return TagsDialog(UniqueKey(), taskToEdit.tags);
        });
    if (newTags != null) {
      setState(() {
        taskToEdit.tags = newTags;
      });
    }
  }

  void setLocation() async {
    final taskLocation = await showDialog(
      context: context,
      builder: (context) {
        return NotificationLocationDialog(
          key: UniqueKey(),
          notificationLocationId: this.taskToEdit.notificationLocalizationId,
          notificationOnEnter: this.taskToEdit.notificationOnEnter,
          notificationOnExit: this.taskToEdit.notificationOnExit,
          notificationRadius: this.taskToEdit.notificationLocalizationRadius,
          taskId: this.taskToEdit.id,
        );
      },
    );

    if (taskLocation == -1) {
      this.deleteNotificationLocalization();
    } else {
      this.setNotificationLocalization(taskLocation);
    }
  }

  void setPriority(newValue) {
    setState(() {
      this.taskToEdit.priority = newValue;
    });
  }

  void setTaskList(newValue) {
    setState(() {
      this.taskToEdit.localization = newValue;
    });
  }

  void setTaskListAutomatically() {
    String newLocation;

    if (this.taskToEdit.delegatedEmail == null) {
      if (this.taskToEdit.startDate != null) {
        newLocation = 'SCHEDULED';
      } else {
        newLocation = 'ANYTIME';
      }
    } else {
      newLocation = 'DELEGATED';
    }

    setState(() {
      this.taskToEdit.localization = newLocation;
    });
  }

  void setDelegatedEmail() async {
    String value = await showDialog(
      context: context,
      builder: (context) {
        return DelegateDialog(choosenMail: this.taskToEdit.delegatedEmail);
      },
    );

    this.taskToEdit.delegatedEmail = value;

    this.setTaskListAutomatically();
  }

  void setTaskToEdit(Task argTask) {
    if (argTask.startDate != null && argTask.startDate.hour != 0 && argTask.startDate.minute != 0) {
      setState(() {
        this.startTime = TimeOfDay(hour: argTask.startDate.hour, minute: argTask.startDate.minute);
      });
    }
    if (argTask.endDate != null && argTask.endDate.hour != 0 && argTask.endDate.minute != 0) {
      setState(() {
        this.endTime = TimeOfDay(hour: argTask.endDate.hour, minute: argTask.endDate.minute);
      });
    }

    taskToEdit = new Task(
      id: argTask.id,
      title: argTask.title,
      description: argTask.description,
      done: argTask.done,
      startDate: argTask.startDate,
      endDate: argTask.endDate,
      localization: argTask.localization,
      priority: argTask.priority,
      tags: argTask.tags,
      position: argTask.position,
      delegatedEmail: argTask.delegatedEmail,
      isCanceled: argTask.isCanceled,
      childId: argTask.childId,
      isDelegated: argTask.isDelegated,
      notificationLocalizationId: argTask.notificationLocalizationId,
      notificationLocalizationRadius: argTask.notificationLocalizationRadius,
      notificationOnEnter: argTask.notificationOnEnter,
      notificationOnExit: argTask.notificationOnExit,
      parentId: argTask.parentId,
      supervisorEmail: argTask.supervisorEmail,
      taskStatus: argTask.taskStatus,
    );
  }

  @override
  Widget build(BuildContext context) {
    final priorities = Provider.of<TaskProvider>(context, listen: false).priorities;
    final localizations = Provider.of<TaskProvider>(context, listen: false).localizations;

    if (taskToEdit == null) {
      originalTask = ModalRoute.of(context).settings.arguments as Task;
      setTaskToEdit(originalTask);
      this._description = taskToEdit.description;
      if (_description.isNotEmpty && _description.trim() != '') {
        onDescriptionChanged(taskToEdit.description);
      }
    }

    double latitude = -1;
    double longitude = -1;

    if (this.taskToEdit.notificationLocalizationId != null) {
      latitude = Provider.of<LocationProvider>(context, listen: false).getLatitude(this.taskToEdit.notificationLocalizationId);
      longitude = Provider.of<LocationProvider>(context, listen: false).getLongitude(this.taskToEdit.notificationLocalizationId);
    }

    List<Attachment> attachments = Provider.of<AttachmentProvider>(context).attachments.where((attachment) => attachment.taskId == taskToEdit.id && !attachment.toDelete).toList();
    attachments.addAll(Provider.of<AttachmentProvider>(context).delegatedAttachments.where((attachment) => attachment.taskId == taskToEdit.parentId && !attachment.toDelete).toList());

    return WillPopScope(
      onWillPop: () async {
        await Provider.of<AttachmentProvider>(context, listen: false).deleteNotSavedAttachments();
        Navigator.of(context).pop();
        return false;
      },
      child: Scaffold(
        appBar: DetailsAppBar(
          title: 'Details',
          task: originalTask,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Form(
              key: this._formKey,
              child: Column(
                children: [
                  TextFormField(
                    initialValue: taskToEdit.title,
                    style: TextStyle(fontSize: 25),
                    maxLines: null,
                    onSaved: (value) {
                      taskToEdit.title = value;
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Task title cannot be empty';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ListTile(
                    minLeadingWidth: 16,
                    contentPadding: EdgeInsets.symmetric(horizontal: 0),
                    leading: Icon(Icons.edit),
                    title: Align(
                      alignment: Alignment(-1.1, 0),
                      child: Text(
                        "Description",
                        style: TextStyle(fontSize: 21),
                      ),
                    ),
                  ),
                  TextFormField(
                    initialValue: taskToEdit.description,
                    maxLines: null,
                    focusNode: this._descriptionFocus,
                    onChanged: (text) {
                      onDescriptionChanged(text);
                    },
                    onSaved: (value) {
                      taskToEdit.description = value;
                    },
                    style: TextStyle(fontSize: 16),
                    textAlign: this._isDescriptionInitial ? TextAlign.center : TextAlign.left,
                    decoration: ColorThemes.taskDetailsFieldDecoration(this._isFocused, this._description, context),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TaskDetailsAttributes(
                    taskToEdit: taskToEdit,
                    priorities: priorities,
                    setDelegatedEmail: setDelegatedEmail,
                    localizations: localizations,
                    setPriority: setPriority,
                    setLocalization: setTaskList,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TaskDetailsMap(
                    setLocation: this.setLocation,
                    setNotificationLocalization: this.setNotificationLocalization,
                    taskToEdit: taskToEdit,
                    originalTask: originalTask,
                    latitude: latitude,
                    longitude: longitude,
                    locationChanged: this._locationChanged,
                  ),
                  TaskDetailsDates(
                    selectEndDate: this.selectEndDate,
                    selectStartDate: this.selectStartDate,
                    taskToEdit: taskToEdit,
                    endTime: endTime,
                    startTime: startTime,
                    selectEndTime: this.selectEndTime,
                    selectStartTime: this.selectStartTime,
                  ),
                  ListTile(
                    minLeadingWidth: 16,
                    contentPadding: EdgeInsets.symmetric(horizontal: 0),
                    leading: Icon(Icons.tag),
                    title: Align(
                      alignment: Alignment(-1.1, 0),
                      child: Text(
                        "Tags",
                        style: TextStyle(fontSize: 21),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => editTags(context),
                    child: TaskTagsEdit(
                      tags: taskToEdit.tags,
                    ),
                  ),
                  ListTile(
                    minLeadingWidth: 16,
                    contentPadding: EdgeInsets.symmetric(horizontal: 0),
                    leading: Icon(Icons.attach_file_outlined),
                    title: Align(
                      alignment: Alignment(-1.1, 0),
                      child: Text(
                        "Attachments",
                        style: TextStyle(fontSize: 21),
                      ),
                    ),
                  ),
                  TaskDetailsAttachments(
                    attachments: attachments,
                    taskId: taskToEdit.id,
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: TaskDetailsBottomBar(
          deleteTask: this.deleteTask,
          saveTask: this.saveTask,
          taskToEdit: taskToEdit,
        ),
      ),
    );
  }
}
