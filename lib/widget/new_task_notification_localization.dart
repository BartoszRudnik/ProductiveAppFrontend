import 'package:flutter/material.dart';
import 'package:productive_app/widget/dialog/notification_location_dialog.dart';

class NewTaskNotificationLocalization extends StatefulWidget {
  final Function setNotificationLocalization;

  final String notificationLocalizationUuid;
  final double notificationRadius;
  final bool notificationOnEnter;
  final bool notificationOnExit;
  final String taskUuid;

  final bool bigIcon;

  NewTaskNotificationLocalization({
    this.bigIcon = false,
    @required this.setNotificationLocalization,
    @required this.notificationLocalizationUuid,
    @required this.notificationOnEnter,
    @required this.notificationOnExit,
    @required this.notificationRadius,
    this.taskUuid,
  });

  @override
  _NewTaskNotificationLocalizationState createState() => _NewTaskNotificationLocalizationState();
}

class _NewTaskNotificationLocalizationState extends State<NewTaskNotificationLocalization> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.map_outlined,
        size: this.widget.bigIcon != null && this.widget.bigIcon ? 32 : 24,
      ),
      onPressed: () async {
        var taskLocation = await showDialog(
          context: context,
          builder: (context) {
            return NotificationLocationDialog(
              key: UniqueKey(),
              notificationLocationUuid: this.widget.notificationLocalizationUuid,
              notificationOnEnter: this.widget.notificationOnEnter,
              notificationOnExit: this.widget.notificationOnExit,
              notificationRadius: this.widget.notificationRadius,
              taskUuid: this.widget.taskUuid,
            );
          },
        );
        if (taskLocation != null) {
          if (taskLocation == 'cancel') {
            taskLocation = null;
          }

          this.widget.setNotificationLocalization(taskLocation);
        }
      },
    );
  }
}
