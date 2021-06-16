import 'package:flutter/material.dart';
import 'package:productive_app/shared/dialogs.dart';
import 'package:productive_app/shared/notifications.dart';
import 'package:productive_app/task_page/widgets/location_dialog.dart';
import 'package:provider/provider.dart';

import '../models/location.dart';
import '../models/taskLocation.dart';
import '../providers/location_provider.dart';

class NotificationLocationDialog extends StatefulWidget {
  final Key key;
  final notificationLocationId;
  final notificationRadius;
  final notificationOnEnter;
  final notificationOnExit;
  final taskId;

  NotificationLocationDialog({
    @required this.key,
    @required this.notificationLocationId,
    @required this.notificationOnEnter,
    @required this.notificationOnExit,
    @required this.notificationRadius,
    this.taskId,
  });

  @override
  _NotificationLocationDialogState createState() => _NotificationLocationDialogState();
}

class _NotificationLocationDialogState extends State<NotificationLocationDialog> {
  double notificationRadius = 0.1;
  bool notificationOnEnter = false;
  bool notificationOnExit = false;
  Location location;

  bool deleted = false;

  Future<void> _addNewLocationForm(BuildContext buildContext, Location choosenLocation) async {
    if (choosenLocation != null) {
      String name = await Dialogs.showTextFieldDialog(context, 'Enter location name');
      if (name == null || name.isEmpty) {
        return;
      }
      choosenLocation.localizationName = name;
      this.location = choosenLocation;
      await Provider.of<LocationProvider>(context, listen: false).addLocation(choosenLocation);
    }
  }

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
    final locationsList = Provider.of<LocationProvider>(context).locations;

    if (this.widget.notificationLocationId != null && this.location == null && !this.deleted) {
      this.location = locationsList.firstWhere((element) => element.id == this.widget.notificationLocationId);
    }

    return AlertDialog(
      content: SingleChildScrollView(
        child: Container(
          height: this.location != null ? 462 : 410,
          width: 450,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 8,
                  child: Container(
                    height: this.location != null ? 125 : 70,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Location'),
                        if (this.location != null)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 5,
                                primary: Color.fromRGBO(201, 201, 206, 1),
                                side: BorderSide(
                                  color: Colors.grey.withOpacity(0.8),
                                ),
                              ),
                              onPressed: () {},
                              child: Text(
                                this.location.localizationName + ": " + this.location.locality + ", " + this.location.street,
                                style: TextStyle(fontSize: 14, color: Theme.of(context).primaryColor),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,
                              ),
                            ),
                          ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: Container(
                                height: 40,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Theme.of(context).primaryColor,
                                    side: BorderSide(color: Theme.of(context).primaryColor),
                                  ),
                                  onPressed: () async {
                                    Location choosenLocation = await showDialog(
                                      context: context,
                                      builder: (context) {
                                        return LocationDialog(
                                          choosenLocation: Location(
                                            id: -1,
                                            latitude: 0.0,
                                            longitude: 0.0,
                                            localizationName: 'test',
                                            country: "",
                                            locality: "",
                                            street: "",
                                          ),
                                        );
                                      },
                                    );

                                    this._addNewLocationForm(context, choosenLocation);
                                  },
                                  child: Text(
                                    'New',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Theme.of(context).accentColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: Container(
                                height: 40,
                                width: 102,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  border: Border.all(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5),
                                  ),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: ButtonTheme(
                                    child: DropdownButton(
                                      isExpanded: true,
                                      hint: Text(
                                        'Saved',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Theme.of(context).accentColor,
                                          fontSize: 14,
                                        ),
                                      ),
                                      items: locationsList.map(
                                        (currentLocation) {
                                          return DropdownMenuItem(
                                            value: currentLocation,
                                            child: Container(
                                              margin: EdgeInsets.all(0),
                                              padding: EdgeInsets.all(0),
                                              width: double.infinity,
                                              child: Container(
                                                child: Text(
                                                  currentLocation.localizationName,
                                                  style: TextStyle(fontSize: 16),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          this.deleted = false;
                                          this.location = value;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 8,
                  child: Column(
                    children: [
                      Text('Change notification range'),
                      Slider(
                        divisions: 49,
                        activeColor: Theme.of(context).primaryColor,
                        inactiveColor: Color.fromRGBO(0, 0, 0, 0.3),
                        min: 0.1,
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
              SizedBox(
                height: 10,
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
                      if (this.location != null) {
                        TaskLocation returnLocation = TaskLocation(
                          location: this.location,
                          notificationOnEnter: this.notificationOnEnter,
                          notificationOnExit: this.notificationOnExit,
                          notificationRadius: this.notificationRadius,
                        );

                        Navigator.of(context).pop(returnLocation);
                      } else {
                        Navigator.of(context).pop(null);
                      }
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
                      Notifications.removeGeofence(this.widget.taskId);
                      setState(() {
                        this.deleted = true;
                        this.location = null;
                        this.notificationOnEnter = false;
                        this.notificationOnExit = false;
                        this.notificationRadius = 0.25;
                      });
                    },
                    child: Text(
                      'Delete',
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
                      if (this.location != null) {
                        TaskLocation returnLocation = TaskLocation(
                          location: this.location,
                          notificationOnEnter: this.notificationOnEnter,
                          notificationOnExit: this.notificationOnExit,
                          notificationRadius: this.notificationRadius,
                        );

                        Navigator.of(context).pop(returnLocation);
                      } else {
                        Navigator.of(context).pop(null);
                      }
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
      ),
    );
  }
}
