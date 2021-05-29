import 'package:flutter/material.dart';
import 'package:productive_app/task_page/widgets/NotificationLocationDialog.dart';

class NewTaskNotificationLocalization extends StatefulWidget {
  final Function setNotificationLocalization;

  final int notificationLocalizationId;
  final double notificationRadius;
  final bool notificationOnEnter;
  final bool notificationOnExit;

  NewTaskNotificationLocalization({
    @required this.setNotificationLocalization,
    @required this.notificationLocalizationId,
    @required this.notificationOnEnter,
    @required this.notificationOnExit,
    @required this.notificationRadius,
  });

  @override
  _NewTaskNotificationLocalizationState createState() => _NewTaskNotificationLocalizationState();
}

class _NewTaskNotificationLocalizationState extends State<NewTaskNotificationLocalization> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.map_outlined),
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
            );
          },
        );

        this.widget.setNotificationLocalization(taskLocation);
      },
    );
  }
}
