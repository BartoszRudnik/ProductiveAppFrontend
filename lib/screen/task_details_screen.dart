import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:intl/intl.dart';
import 'package:latlong/latlong.dart';
import 'package:provider/provider.dart';

import '../utils/dialogs.dart';
import '../utils/notifications.dart';
import '../model/task.dart';
import '../model/taskLocation.dart';
import '../provider/location_provider.dart';
import '../provider/task_provider.dart';
import '../utils/date_time_pickers.dart';
import '../widget/dialog/delegate_dialog.dart';
import '../widget/appBar/details_appBar.dart';
import '../widget/new_task_notification_localization.dart';
import '../widget/dialog/notification_location_dialog.dart';
import '../widget/dialog/tags_dialog.dart';
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

  final MapController _mapController = MapController();
  bool mapControllerReady = false;

  TimeOfDay startTime;
  TimeOfDay endTime;

  bool _locationChanged = false;
  bool _isValid = true;
  bool _isFocused = false;
  bool _isDescriptionInitial = true;
  String _description = "";
  DateFormat formatter = DateFormat("yyyy-MM-dd");

  @override
  void initState() {
    _descriptionFocus.addListener(onDescriptionFocusChange);
    taskToEdit = null;
    this._mapController.onReady.then((_) {
      setState(() {
        this.mapControllerReady = true;
      });
    });
    super.initState();
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

  Future<void> selectStartDate() async {
    DateTime initDate = taskToEdit.startDate;
    if (taskToEdit.startDate == null) {
      initDate = DateTime.now();
    }
    final DateTime pick = await DateTimePickers.pickDate(initDate, context);
    setState(() {
      taskToEdit.startDate = pick;
    });
  }

  Future<void> selectEndDate() async {
    DateTime initDate = taskToEdit.endDate;
    if (taskToEdit.endDate == null) {
      initDate = DateTime.now();
    }
    final DateTime pick = await DateTimePickers.pickDate(initDate, context);
    setState(() {
      taskToEdit.endDate = pick;
    });
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

    setState(() {
      this._isValid = isValid;
    });

    if (!this._isValid) {
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

      Provider.of<TaskProvider>(context, listen: false).deleteFromLocalization(originalTask);
    } catch (error) {
      print(error);
      Dialogs.showWarningDialog(context, "An error has occured");
    }
    Navigator.pop(context);
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

  void _animatedMapMove(LatLng destLocation, double destZoom) {
    if (this._locationChanged) {
      Tween<double> _latTween = Tween<double>(begin: 0, end: destLocation.latitude);
      Tween<double> _lngTween = Tween<double>(begin: 0, end: destLocation.longitude);
      Tween<double> _zoomTween = Tween<double>(begin: destZoom, end: destZoom);

      if (this.mapControllerReady && this._mapController != null && this._mapController.center != null) {
        _latTween = Tween<double>(begin: this._mapController.center.latitude, end: destLocation.latitude);
        _lngTween = Tween<double>(begin: this._mapController.center.longitude, end: destLocation.longitude);
      }

      var controller = AnimationController(duration: const Duration(milliseconds: 500), vsync: this);

      Animation<double> animation = CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);

      if (this._mapController != null) {
        controller.addListener(() {
          this._mapController.move(LatLng(_latTween.evaluate(animation), _lngTween.evaluate(animation)), _zoomTween.evaluate(animation));
        });
      }

      animation.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.dispose();
        } else if (status == AnimationStatus.dismissed) {
          controller.dispose();
        }
      });

      controller.forward();
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

  void setDelegatedEmail() async {
    String value = await showDialog(
      context: context,
      builder: (context) {
        return DelegateDialog(choosenMail: this.taskToEdit.delegatedEmail);
      },
    );

    if (value != null) {
      this.taskToEdit.delegatedEmail = value;
      setState(() {
        this.taskToEdit.localization = 'DELEGATED';
      });
    } else {
      this.taskToEdit.delegatedEmail = null;
      setState(() {
        if (this.taskToEdit.startDate != null) {
          this.taskToEdit.localization = 'SCHEDULED';
        } else {
          this.taskToEdit.localization = 'ANYTIME';
        }
      });
    }
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
      _description = taskToEdit.description;
      if (_description.isNotEmpty && _description.trim() != '') {
        onDescriptionChanged(taskToEdit.description);
      }
    }

    double latitude = -1;
    double longitude = -1;

    if (this.taskToEdit.notificationLocalizationId != null) {
      latitude = Provider.of<LocationProvider>(context, listen: false).getLatitude(this.taskToEdit.notificationLocalizationId);
      longitude = Provider.of<LocationProvider>(context, listen: false).getLongitude(this.taskToEdit.notificationLocalizationId);

      if (latitude != null && longitude != null && this.mapControllerReady) {
        LatLng point = LatLng(latitude, longitude);
        this._animatedMapMove(point, 15);
      }
    }

    return Scaffold(
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
                  focusNode: _descriptionFocus,
                  onChanged: (text) {
                    onDescriptionChanged(text);
                  },
                  onSaved: (value) {
                    taskToEdit.description = value;
                  },
                  style: TextStyle(fontSize: 16),
                  textAlign: _isDescriptionInitial ? TextAlign.center : TextAlign.left,
                  decoration: InputDecoration(
                    hintText: _isFocused ? "" : "Tap to add description",
                    filled: true,
                    fillColor: _isDescriptionInitial ? Theme.of(context).primaryColorLight : Colors.white,
                    enabledBorder: _description.isEmpty
                        ? OutlineInputBorder(
                            borderSide: BorderSide(
                            color: Theme.of(context).primaryColorDark,
                          ))
                        : InputBorder.none,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 5,
                      child: SizedBox(
                        height: 100,
                        child: PopupMenuButton(
                          initialValue: taskToEdit.priority,
                          onSelected: (value) {
                            setState(() {
                              taskToEdit.priority = value;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColorLight,
                              borderRadius: BorderRadius.circular(3),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.8),
                                  offset: Offset(0.0, 1.0),
                                  blurRadius: 1.0,
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [Icon(Icons.flag), Text("Priority")],
                            ),
                          ),
                          itemBuilder: (context) {
                            return priorities.reversed.map((e) {
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
                        ),
                      ),
                    ),
                    Expanded(flex: 1, child: SizedBox()),
                    Expanded(
                      flex: 5,
                      child: SizedBox(
                        height: 100,
                        child: ElevatedButton(
                          onPressed: () {
                            this.setDelegatedEmail();
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Theme.of(context).primaryColorLight,
                            onPrimary: Theme.of(context).primaryColor,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [Icon(Icons.person_add), Text("Assigned")],
                          ),
                        ),
                      ),
                    ),
                    Expanded(flex: 1, child: SizedBox()),
                    Expanded(
                      flex: 5,
                      child: SizedBox(
                        height: 100,
                        child: PopupMenuButton(
                          initialValue: taskToEdit.localization,
                          onSelected: (value) {
                            setState(() {
                              taskToEdit.localization = value;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColorLight,
                              borderRadius: BorderRadius.circular(3),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.8),
                                  offset: Offset(0.0, 1.0),
                                  blurRadius: 1.0,
                                )
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.inbox),
                                Text(taskToEdit.localization),
                              ],
                            ),
                          ),
                          itemBuilder: (context) {
                            return localizations.map((e) {
                              return PopupMenuItem(
                                child: Text(e),
                                value: e,
                              );
                            }).toList();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  height: 175,
                  child: Stack(
                    children: [
                      if (this.taskToEdit.notificationLocalizationId != null && latitude != null && longitude != null && this._mapController != null)
                        Container(
                          height: 175,
                          width: double.infinity,
                          child: FlutterMap(
                            mapController: this._mapController,
                            options: MapOptions(
                              interactive: true,
                              center: this.taskToEdit.notificationLocalizationId != null ? LatLng(latitude, longitude) : LatLng(0, 0),
                              zoom: 16,
                            ),
                            layers: [
                              TileLayerOptions(
                                urlTemplate: "https://cartodb-basemaps-{s}.global.ssl.fastly.net/light_all/{z}/{x}/{y}.png",
                                subdomains: ['a', 'b', 'c'],
                              ),
                              MarkerLayerOptions(
                                markers: [
                                  Marker(
                                    width: 150.0,
                                    height: 150.0,
                                    point: LatLng(latitude, longitude),
                                    builder: (context) => Icon(
                                      Icons.location_on,
                                      color: Colors.black,
                                    ),
                                  )
                                ],
                              ),
                              if (this.taskToEdit.notificationLocalizationRadius != null)
                                CircleLayerOptions(
                                  circles: [
                                    CircleMarker(
                                      point: LatLng(latitude, longitude),
                                      color: Colors.blueGrey.withOpacity(0.4),
                                      borderStrokeWidth: 3.0,
                                      borderColor: Colors.grey,
                                      useRadiusInMeter: true,
                                      radius: this.taskToEdit.notificationLocalizationRadius * 1000,
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      if (this.taskToEdit.notificationLocalizationId == null || longitude == null || latitude == null)
                        Expanded(
                          flex: 5,
                          child: Container(
                            height: 175,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColorLight,
                              borderRadius: BorderRadius.circular(3),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.8),
                                  offset: Offset(0.0, 1.0),
                                  blurRadius: 1.0,
                                )
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                NewTaskNotificationLocalization(
                                  bigIcon: true,
                                  setNotificationLocalization: this.setNotificationLocalization,
                                  notificationLocalizationId: this.taskToEdit.notificationLocalizationId,
                                  notificationOnEnter: this.taskToEdit.notificationOnEnter,
                                  notificationOnExit: this.taskToEdit.notificationOnExit,
                                  notificationRadius: this.taskToEdit.notificationLocalizationRadius,
                                  taskId: this.originalTask.id,
                                ),
                                Text(
                                  'Tap to add location',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                        ),
                      GestureDetector(
                        onTap: () {
                          this.setLocation();
                        },
                      ),
                    ],
                  ),
                ),
                ListTile(
                  minLeadingWidth: 16,
                  contentPadding: EdgeInsets.symmetric(horizontal: 0),
                  leading: Icon(Icons.calendar_today),
                  title: Align(
                    alignment: Alignment(-1.1, 0),
                    child: Text(
                      "Start and due date",
                      style: TextStyle(fontSize: 21),
                    ),
                  ),
                ),
                ConstrainedBox(
                  constraints: BoxConstraints.tightFor(width: double.infinity, height: 50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Start date: ',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Container(
                        child: Row(
                          children: [
                            ElevatedButton(
                              onPressed: () => selectStartDate(),
                              style: ElevatedButton.styleFrom(
                                primary: Theme.of(context).primaryColorLight,
                                onPrimary: Theme.of(context).primaryColor,
                              ),
                              child: Center(
                                child: taskToEdit.startDate.toString() == "null"
                                    ? Icon(Icons.calendar_today_outlined)
                                    : Text(
                                        formatter.format(taskToEdit.startDate),
                                      ),
                              ),
                            ),
                            SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: () async {
                                final TimeOfDay pickTime = await DateTimePickers.pickTime(context);

                                setState(() {
                                  this.startTime = pickTime;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Theme.of(context).primaryColorLight,
                                onPrimary: Theme.of(context).primaryColor,
                              ),
                              child: Center(
                                child: this.startTime.toString() == "null"
                                    ? Icon(Icons.access_time_outlined)
                                    : Text(
                                        this.startTime.format(context),
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                ConstrainedBox(
                  constraints: BoxConstraints.tightFor(width: double.infinity, height: 50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Due date:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Container(
                        child: Row(
                          children: [
                            ElevatedButton(
                              onPressed: () => selectEndDate(),
                              style: ElevatedButton.styleFrom(
                                primary: Theme.of(context).primaryColorLight,
                                onPrimary: Theme.of(context).primaryColor,
                              ),
                              child: Center(
                                child: taskToEdit.endDate.toString() == "null"
                                    ? Icon(Icons.calendar_today_outlined)
                                    : Text(
                                        formatter.format(taskToEdit.endDate),
                                      ),
                              ),
                            ),
                            SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: () async {
                                final TimeOfDay pickTime = await DateTimePickers.pickTime(context);

                                setState(() {
                                  this.endTime = pickTime;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Theme.of(context).primaryColorLight,
                                onPrimary: Theme.of(context).primaryColor,
                              ),
                              child: Center(
                                child: this.endTime.toString() == "null"
                                    ? Icon(Icons.access_time_outlined)
                                    : Text(
                                        this.endTime.format(context),
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
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
                )
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        child: Row(
          children: [
            Expanded(
              flex: 4,
              child: TextButton.icon(
                onPressed: () => deleteTask(),
                style: ElevatedButton.styleFrom(
                  onPrimary: Theme.of(context).primaryColor,
                ),
                icon: Icon(Icons.delete),
                label: Text("Archive"),
              ),
            ),
            Expanded(
              flex: 6,
              child: TextButton.icon(
                onPressed: () {
                  setState(() {
                    taskToEdit.done = !taskToEdit.done;
                  });
                },
                style: ElevatedButton.styleFrom(
                  onPrimary: Theme.of(context).primaryColor,
                ),
                icon: Icon(taskToEdit.done ? Icons.cancel : Icons.done),
                label: Text(taskToEdit.done ? "Unmark as done" : "Mark as done"),
              ),
            ),
            Expanded(
                flex: 4,
                child: TextButton.icon(
                  onPressed: () => saveTask(),
                  style: ElevatedButton.styleFrom(
                    onPrimary: Theme.of(context).primaryColor,
                  ),
                  icon: Icon(Icons.save),
                  label: Text("Save"),
                )),
          ],
        ),
      ),
    );
  }
}
