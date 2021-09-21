import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:productive_app/config/const_values.dart';
import 'package:productive_app/provider/synchronize_provider.dart';
import 'package:productive_app/utils/task_validate.dart';
import 'package:productive_app/widget/taskDetailsState.dart';
import 'package:productive_app/widget/task_details_description.dart';
import 'package:productive_app/widget/task_details_tags.dart';
import 'package:provider/provider.dart';
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

  bool changesSaved = false;
  bool _locationChanged = false;
  bool _isFocused = false;
  bool _isDescriptionInitial = true;

  DateFormat formatter = DateFormat("yyyy-MM-dd");

  @override
  void initState() {
    super.initState();

    _descriptionFocus.addListener(onDescriptionFocusChange);
    taskToEdit = null;

    Provider.of<AttachmentProvider>(context, listen: false).prepare();
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
      this.taskToEdit.description = text;
    });
    checkColor();
  }

  bool differentNotification(Task newTask, Task oldTask) {
    if (newTask.notificationLocalizationUuid != null && oldTask.notificationLocalizationUuid == null) {
      return true;
    } else if (newTask.notificationLocalizationUuid != null && oldTask.notificationLocalizationUuid != null) {
      if (newTask.notificationLocalizationUuid != oldTask.notificationLocalizationUuid ||
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
      this._isDescriptionInitial = true;
      if (this.taskToEdit == null || this.taskToEdit.description.isNotEmpty) {
        this._isDescriptionInitial = false;
      }
      if (this._isFocused) {
        this._isDescriptionInitial = false;
      }
    });
  }

  void _chooseTaskList() {
    if (this.taskToEdit.taskState == null) {
      this.taskToEdit.taskState = 'COLLECT';
      this.taskToEdit.localization = 'INBOX';
    } else {
      if (this.taskToEdit.taskState == 'COLLECT') {
        this.taskToEdit.localization = 'INBOX';
      } else if (this.taskToEdit.taskState == "COMPLETED") {
        if (this.taskToEdit.done) {
          this.taskToEdit.localization = 'COMPLETED';
        } else {
          this.taskToEdit.localization = 'TRASH';
        }
      } else if (this.taskToEdit.taskState == "PLAN&DO") {
        if (this.taskToEdit.delegatedEmail != null) {
          this.taskToEdit.localization = 'DELEGATED';
        } else if (this.taskToEdit.startDate != null) {
          this.taskToEdit.localization = 'SCHEDULED';
        } else {
          this.taskToEdit.localization = 'ANYTIME';
        }
      }
    }
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

  void showInfo(String newLocalization) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        margin: EdgeInsetsDirectional.only(bottom: 60),
        behavior: SnackBarBehavior.floating,
        content: Text(AppLocalizations.of(context).taskMoved + ConstValues.listName(newLocalization, context)),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> saveTask() async {
    bool isValid = this._formKey.currentState.validate();

    if (this.startTime != null && taskToEdit.startDate != null) {
      taskToEdit.startDate =
          new DateTime(taskToEdit.startDate.year, taskToEdit.startDate.month, taskToEdit.startDate.day, this.startTime.hour, this.startTime.minute);
    } else if (taskToEdit.startDate != null) {
      taskToEdit.startDate = new DateTime(taskToEdit.startDate.year, taskToEdit.startDate.month, taskToEdit.startDate.day, 0, 0);
    }

    if (this.endTime != null && taskToEdit.endDate != null) {
      taskToEdit.endDate = new DateTime(taskToEdit.endDate.year, taskToEdit.endDate.month, taskToEdit.endDate.day, this.endTime.hour, this.endTime.minute);
    } else if (taskToEdit.endDate != null) {
      taskToEdit.endDate = new DateTime(taskToEdit.endDate.year, taskToEdit.endDate.month, taskToEdit.endDate.day, 0, 0);
    }

    isValid = await TaskValidate.validateTaskEdit(taskToEdit, originalTask, context);

    if (!isValid) {
      return;
    }

    this._formKey.currentState.save();

    try {
      this._chooseTaskList();

      final newLocalization = taskToEdit.localization;

      taskToEdit.localization = originalTask.localization;

      if (taskToEdit.done != originalTask.done) {
        if (taskToEdit.notificationLocalizationUuid != null) {
          if (taskToEdit.done) {
            await Notifications.removeGeofence(taskToEdit.uuid);
          } else {
            double latitude = Provider.of<LocationProvider>(context, listen: false).getLatitude(taskToEdit.notificationLocalizationUuid);
            double longitude = Provider.of<LocationProvider>(context, listen: false).getLongitude(taskToEdit.notificationLocalizationUuid);

            await Notifications.addGeofence(
              taskToEdit.uuid,
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
        final latitude = Provider.of<LocationProvider>(context, listen: false).getLatitude(taskToEdit.notificationLocalizationUuid);
        final longitude = Provider.of<LocationProvider>(context, listen: false).getLongitude(taskToEdit.notificationLocalizationUuid);

        await Provider.of<TaskProvider>(context, listen: false).updateTaskWithGeolocation(taskToEdit, newLocalization, longitude, latitude);
      } else {
        await Provider.of<TaskProvider>(context, listen: false).updateTask(taskToEdit, newLocalization);
      }

      if (this.originalTask.localization != newLocalization) {
        this.showInfo(newLocalization);
      }

      await Provider.of<AttachmentProvider>(context, listen: false).deleteFlaggedAttachments();
      Provider.of<TaskProvider>(context, listen: false).deleteFromLocalization(originalTask);
      this.changesSaved = true;
    } on SocketException catch (error) {
      print(error);
    } catch (error) {
      print(error);
      await Dialogs.showWarningDialog(context, AppLocalizations.of(context).errorOccurred);
    }
    Navigator.of(context).pop();
  }

  Future<void> deleteTask() async {
    bool accepted = await Dialogs.showChoiceDialog(context, AppLocalizations.of(context).areYouSureArchive);
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
        await Dialogs.showWarningDialog(context, AppLocalizations.of(context).errorOccurred);
      }
      Navigator.pop(context);
    }
  }

  void setNotificationLocalization(TaskLocation taskLocation) {
    setState(() {
      if (taskLocation != null && taskLocation.location != null) {
        this.taskToEdit.notificationLocalizationUuid = taskLocation.location.uuid;
        this.taskToEdit.notificationLocalizationRadius = taskLocation.notificationRadius;
        this.taskToEdit.notificationOnEnter = taskLocation.notificationOnEnter;
        this.taskToEdit.notificationOnExit = taskLocation.notificationOnExit;

        this._locationChanged = true;
      }
    });
  }

  void deleteNotificationLocalization() {
    setState(() {
      this.taskToEdit.notificationLocalizationUuid = null;
      this.taskToEdit.notificationLocalizationRadius = 0.1;
      this.taskToEdit.notificationOnEnter = false;
      this.taskToEdit.notificationOnExit = false;
    });
  }

  Future<void> editTags(BuildContext context) async {
    final newTags = await showDialog(
        context: context,
        builder: (context) {
          return TagsDialog(taskTags: taskToEdit.tags);
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
          notificationLocationUuid: this.taskToEdit.notificationLocalizationUuid,
          notificationOnEnter: this.taskToEdit.notificationOnEnter,
          notificationOnExit: this.taskToEdit.notificationOnExit,
          notificationRadius: this.taskToEdit.notificationLocalizationRadius,
          taskUuid: this.taskToEdit.uuid,
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

  void setTaskState(newValue) {
    setState(() {
      this.taskToEdit.taskState = newValue;
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

  bool checkEquals(Task a, Task b) {
    return a.id == b.id &&
        a.title == b.title &&
        a.description == b.description &&
        a.priority == b.priority &&
        a.localization == b.localization &&
        a.delegatedEmail == b.delegatedEmail &&
        a.taskStatus == b.taskStatus &&
        a.supervisorEmail == b.supervisorEmail &&
        a.startDate == b.startDate &&
        a.endDate == b.endDate &&
        a.tags == b.tags &&
        a.done == b.done &&
        a.notificationLocalizationUuid == b.notificationLocalizationUuid &&
        a.notificationLocalizationRadius == b.notificationLocalizationRadius &&
        a.notificationOnEnter == b.notificationOnEnter &&
        a.notificationOnExit == b.notificationOnExit;
  }

  void setTaskToEdit(Task argTask) {
    if (argTask.startDate != null && (argTask.startDate.hour != 0 || argTask.startDate.minute != 0)) {
      setState(() {
        this.startTime = TimeOfDay(hour: argTask.startDate.hour, minute: argTask.startDate.minute);
      });
    }
    if (argTask.endDate != null && (argTask.endDate.hour != 0 || argTask.endDate.minute != 0)) {
      setState(() {
        this.endTime = TimeOfDay(hour: argTask.endDate.hour, minute: argTask.endDate.minute);
      });
    }

    taskToEdit = new Task(
      uuid: argTask.uuid,
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
      childUuid: argTask.childUuid,
      isDelegated: argTask.isDelegated,
      notificationLocalizationUuid: argTask.notificationLocalizationUuid,
      notificationLocalizationRadius: argTask.notificationLocalizationRadius,
      notificationOnEnter: argTask.notificationOnEnter,
      notificationOnExit: argTask.notificationOnExit,
      parentUuid: argTask.parentUuid,
      supervisorEmail: argTask.supervisorEmail,
      taskStatus: argTask.taskStatus,
      taskState: argTask.taskState,
    );
  }

  @override
  Widget build(BuildContext context) {
    final priorities = Provider.of<TaskProvider>(context, listen: false).priorities;
    final states = Provider.of<TaskProvider>(context, listen: false).localizations;

    if (taskToEdit == null) {
      originalTask = ModalRoute.of(context).settings.arguments as Task;

      setTaskToEdit(originalTask);

      if (this.taskToEdit.description != null && this.taskToEdit.description.isNotEmpty && this.taskToEdit.description.trim() != '') {
        onDescriptionChanged(taskToEdit.description);
      }
    }

    double latitude = -1;
    double longitude = -1;

    if (this.taskToEdit.notificationLocalizationUuid != null) {
      latitude = Provider.of<LocationProvider>(context, listen: false).getLatitude(this.taskToEdit.notificationLocalizationUuid);
      longitude = Provider.of<LocationProvider>(context, listen: false).getLongitude(this.taskToEdit.notificationLocalizationUuid);
    }

    List<Attachment> attachments =
        Provider.of<AttachmentProvider>(context).attachments.where((attachment) => attachment.taskUuid == taskToEdit.uuid && !attachment.toDelete).toList();

    attachments.addAll(Provider.of<AttachmentProvider>(context)
        .delegatedAttachments
        .where((attachment) => attachment.taskUuid == taskToEdit.parentUuid && !attachment.toDelete)
        .toList());

    return WillPopScope(
      // ignore: missing_return
      onWillPop: () async {
        this._formKey.currentState.save();
        bool result = false;

        if ((!this.checkEquals(this.originalTask, this.taskToEdit) || Provider.of<AttachmentProvider>(context, listen: false).notSavedAttachments.length > 0) &&
            !this.changesSaved) {
          result = await Dialogs.showActionDialog(
            context,
            AppLocalizations.of(context).changes,
            this.saveTask,
            () {},
          );
        }

        final notSaved = Provider.of<AttachmentProvider>(context, listen: false).notSavedAttachments;

        if (notSaved != null) {
          notSaved.forEach((element) {
            Provider.of<SynchronizeProvider>(context, listen: false).addAttachmentToDelete(element.uuid);
          });
        }

        await Provider.of<AttachmentProvider>(context, listen: false).deleteNotSavedAttachments();
        if (!result) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: DetailsAppBar(
          title: AppLocalizations.of(context).details,
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
                        return AppLocalizations.of(context).taskTitleEmpty;
                      }
                      return null;
                    },
                  ),
                  TaskDetailsDescription(
                    description: this.taskToEdit.description,
                    descriptionFocus: this._descriptionFocus,
                    isDescriptionInitial: this._isDescriptionInitial,
                    isFocused: this._isFocused,
                    onDescriptionChanged: this.onDescriptionChanged,
                  ),
                  TaskDetailsState(
                    taskState: this.taskToEdit.taskState,
                    setTaskState: this.setTaskState,
                    states: states,
                  ),
                  TaskDetailsAttributes(
                    taskToEdit: taskToEdit,
                    priorities: priorities,
                    setDelegatedEmail: setDelegatedEmail,
                    setPriority: setPriority,
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
                  TaskDetailsTags(
                    tags: this.taskToEdit.tags,
                    editTags: this.editTags,
                  ),
                  TaskDetailsAttachments(
                    attachments: attachments,
                    taskUuid: taskToEdit.uuid,
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
