import 'package:flutter/material.dart';
import 'package:productive_app/task_page/models/taskLocation.dart';

class NotificationLocationDialog extends StatefulWidget {
  final Key key;
  final notificationLocationId;
  final notificationRadius;
  final notificationOnEnter;
  final notificationOnExit;

  NotificationLocationDialog({
    @required this.key,
    @required this.notificationLocationId,
    @required this.notificationOnEnter,
    @required this.notificationOnExit,
    @required this.notificationRadius,
  });

  @override
  _NotificationLocationDialogState createState() => _NotificationLocationDialogState();
}

class _NotificationLocationDialogState extends State<NotificationLocationDialog> {
  double notificationRadius = 0.0;
  bool notificationOnEnter = false;
  bool notificationOnExit = false;

  @override
  void initState() {
    if (this.widget.notificationRadius != null) {
      this.notificationRadius = this.widget.notificationRadius;
    }
    if (this.widget.notificationOnEnter != null) {
      this.notificationOnEnter = this.widget.notificationOnEnter;
    }
    if (this.widget.notificationOnExit != null) {
      this.notificationOnExit = this.widget.notificationOnExit;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        height: 400,
        width: 350,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Column(
                  children: [
                    Text('Change notification range'),
                    Slider(
                      divisions: 20,
                      activeColor: Theme.of(context).primaryColor,
                      inactiveColor: Color.fromRGBO(0, 0, 0, 0.3),
                      min: 0.0,
                      max: 5.0,
                      value: this.notificationRadius,
                      onChanged: (newRadius) {
                        setState(
                          () {
                            this.notificationRadius = newRadius;
                          },
                        );
                      },
                    ),
                    Text('Actual range: ' + this.notificationRadius.toStringAsFixed(2) + ' km'),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Card(
                elevation: 8,
                child: SwitchListTile(
                  activeColor: Theme.of(context).primaryColor,
                  title: Text('Notification on enter'),
                  value: this.notificationOnEnter,
                  onChanged: (bool value) {
                    setState(
                      () {
                        this.notificationOnEnter = value;
                      },
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Card(
                elevation: 8,
                child: SwitchListTile(
                  activeColor: Theme.of(context).primaryColor,
                  title: Text('Notification on exit'),
                  value: this.notificationOnExit,
                  onChanged: (bool value) {
                    setState(
                      () {
                        this.notificationOnExit = value;
                      },
                    );
                  },
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).primaryColor,
                    side: BorderSide(color: Theme.of(context).primaryColor),
                  ),
                  onPressed: () {
                    TaskLocation returnLocation = TaskLocation(
                      location: null, //TO-DO
                      notificationOnEnter: this.widget.notificationOnEnter,
                      notificationOnExit: this.widget.notificationOnExit,
                      notificationRadius: this.widget.notificationRadius,
                    );

                    Navigator.of(context).pop(returnLocation);
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).primaryColor,
                    side: BorderSide(color: Theme.of(context).primaryColor),
                  ),
                  onPressed: () {
                    TaskLocation returnLocation = TaskLocation(
                      location: null, //TO-DO
                      notificationOnEnter: this.notificationOnEnter,
                      notificationOnExit: this.notificationOnExit,
                      notificationRadius: this.notificationRadius,
                    );

                    Navigator.of(context).pop(returnLocation);
                  },
                  child: Text(
                    'Save',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
