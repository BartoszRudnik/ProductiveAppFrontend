import 'package:flutter/material.dart';
import 'package:productive_app/widget/dialog/notification_location_dialog.dart';

class NewTaskNotificationLocalization extends StatefulWidget {
  final Function setNotificationLocalization;

  final int notificationLocalizationId;
  final double notificationRadius;
  final bool notificationOnEnter;
  final bool notificationOnExit;
  final int taskId;

  bool bigIcon = false;

  NewTaskNotificationLocalization({
    this.bigIcon,
    @required this.setNotificationLocalization,
    @required this.notificationLocalizationId,
    @required this.notificationOnEnter,
    @required this.notificationOnExit,
    @required this.notificationRadius,
    this.taskId,
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
        final taskLocation = await showDialog(
          context: context,
          builder: (context) {
            return NotificationLocationDialog(
              key: UniqueKey(),
              notificationLocationId: this.widget.notificationLocalizationId,
              notificationOnEnter: this.widget.notificationOnEnter,
              notificationOnExit: this.widget.notificationOnExit,
              notificationRadius: this.widget.notificationRadius,
              taskId: this.widget.taskId,
            );
          },
        );
        this.widget.setNotificationLocalization(taskLocation);
      },
    );
  }
}
