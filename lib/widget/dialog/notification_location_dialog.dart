import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:productive_app/config/color_themes.dart';
import 'package:productive_app/utils/internet_connection.dart';
import 'package:provider/provider.dart';

import '../../model/location.dart';
import '../../model/taskLocation.dart';
import '../../provider/location_provider.dart';
import '../../utils/dialogs.dart';
import '../../utils/notifications.dart';
import 'location_dialog.dart';

class NotificationLocationDialog extends StatefulWidget {
  final Key key;
  final notificationLocationUuid;
  final notificationRadius;
  final notificationOnEnter;
  final notificationOnExit;
  final String taskUuid;

  NotificationLocationDialog({
    @required this.key,
    @required this.notificationLocationUuid,
    @required this.notificationOnEnter,
    @required this.notificationOnExit,
    @required this.notificationRadius,
    this.taskUuid,
  });

  @override
  _NotificationLocationDialogState createState() => _NotificationLocationDialogState();
}

class _NotificationLocationDialogState extends State<NotificationLocationDialog> {
  double notificationRadius = 0.1;
  bool notificationOnEnter = false;
  bool notificationOnExit = false;
  Location location;
  GoogleMapController _mapController;
  String _darkMapStyle = '';
  String _lightMapStyle = '';

  bool deleted = false;
  bool saveLocation = false;
  bool newLocation = false;

  Future<void> _addNewLocationForm(BuildContext buildContext, Location choosenLocation) async {
    if (choosenLocation != null) {
      this.newLocation = true;
      this.location = choosenLocation;
      await Provider.of<LocationProvider>(context, listen: false).addLocation(choosenLocation);
      await this._mapMove(LatLng(choosenLocation.latitude, choosenLocation.longitude), 14);
    }
  }

  Future _loadMapStyles() async {
    this._darkMapStyle = await rootBundle.loadString('assets/map/darkMap.json');
    this._lightMapStyle = await rootBundle.loadString('assets/map/lightMap.json');
  }

  @override
  void initState() {
    super.initState();

    if (this.widget.notificationRadius != null) {
      this.notificationRadius = this.widget.notificationRadius;
    }
    if (this.widget.notificationOnEnter != null) {
      this.notificationOnEnter = this.widget.notificationOnEnter;
    }
    if (this.widget.notificationOnExit != null) {
      this.notificationOnExit = this.widget.notificationOnExit;
    }

    this._loadMapStyles();
  }

  Future<void> _mapMove(LatLng point, double zoom) async {
    await this._mapController.moveCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: point, zoom: zoom),
          ),
        );
  }

  void _onMapCreated(GoogleMapController _controller, LatLng point, double zoom) async {
    this._mapController = _controller;

    await this._mapController.setMapStyle(
          Theme.of(context).brightness == Brightness.light ? this._lightMapStyle : this._darkMapStyle,
        );

    await this._mapMove(point, zoom);
  }

  @override
  Widget build(BuildContext context) {
    final allLocations = Provider.of<LocationProvider>(context).allLocations;
    final savedLocations = Provider.of<LocationProvider>(context).locations;

    if (this.widget.notificationLocationUuid != null && this.location == null && !this.deleted) {
      this.location = allLocations.firstWhere((element) => element.uuid == this.widget.notificationLocationUuid);
    }

    double overallHeightNotNull = MediaQuery.of(context).size.height * 0.85;
    double overallHeightNull = MediaQuery.of(context).size.height * 0.8;
    double heightNotNull = 130;
    double heightNull = 80;

    if (this.location != null) {
      overallHeightNotNull = MediaQuery.of(context).size.height * 0.85;
      overallHeightNull = MediaQuery.of(context).size.height * 0.8;
      heightNotNull += 200;
      heightNull += 50;
    } else {
      overallHeightNull -= 140;
    }

    return AlertDialog(
      content: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        height: this.location != null ? overallHeightNotNull : overallHeightNull,
        width: MediaQuery.of(context).size.width * 0.75,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4),
                child: Card(
                  elevation: 8,
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    height: this.location != null ? heightNotNull : heightNull,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(AppLocalizations.of(context).locations),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: Container(
                                height: 40,
                                child: ElevatedButton(
                                  style: ColorThemes.newTaskDateButtonStyle(context),
                                  onPressed: () async {
                                    if (await InternetConnection.internetConnection()) {
                                      Location choosenLocation = await showDialog(
                                        context: context,
                                        builder: (context) {
                                          return LocationDialog(
                                            choosenLocation: Location(
                                              uuid: '',
                                              id: -1,
                                              latitude: 0.0,
                                              longitude: 0.0,
                                              localizationName: '',
                                              country: "",
                                              locality: "",
                                              street: "",
                                              saved: false,
                                            ),
                                          );
                                        },
                                      );

                                      this._addNewLocationForm(context, choosenLocation);
                                    } else {
                                      Dialogs.showWarningDialog(context, AppLocalizations.of(context).connectionFailed);
                                    }
                                  },
                                  child: Text(AppLocalizations.of(context).newWord),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: Container(
                                height: 40,
                                width: 102,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColorDark,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5),
                                  ),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: ButtonTheme(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: DropdownButton(
                                        isExpanded: true,
                                        hint: Text(
                                          AppLocalizations.of(context).saved,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(color: Theme.of(context).primaryColor),
                                        ),
                                        items: savedLocations.map(
                                          (currentLocation) {
                                            return DropdownMenuItem(
                                              value: currentLocation,
                                              child: Container(
                                                margin: EdgeInsets.all(0),
                                                padding: EdgeInsets.all(0),
                                                width: double.infinity,
                                                child: Container(
                                                  child: Text(
                                                    currentLocation.localizationName == null ? '' : currentLocation.localizationName,
                                                    style: TextStyle(fontSize: 16),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ).toList(),
                                        onChanged: (value) async {
                                          if (this.location != null && this.newLocation) {
                                            await Provider.of<LocationProvider>(context, listen: false).deleteLocation(this.location.uuid);
                                          }

                                          setState(() {
                                            this.saveLocation = false;
                                            this.newLocation = false;
                                            this.deleted = false;
                                            this.location = value;
                                          });

                                          await this._mapMove(LatLng(this.location.latitude, this.location.longitude), 14);
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (this.location != null)
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  side: BorderSide(color: Theme.of(context).primaryColor),
                                  primary: Theme.of(context).primaryColorLight,
                                  onPrimary: Theme.of(context).primaryColor,
                                ),
                                onPressed: () async {
                                  this.location.localizationName = await Dialogs.showTextFieldDialog(context, AppLocalizations.of(context).enterLocationName);

                                  await Provider.of<LocationProvider>(context, listen: false)
                                      .editLocationName(this.location.uuid, this.location.localizationName, true);

                                  setState(() {});
                                },
                                child: Text(
                                  this.location.localizationName +
                                      (this.location.localizationName.length > 0 ? ": " : "") +
                                      this.location.locality +
                                      ", " +
                                      this.location.street,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 3,
                                ),
                              ),
                            ),
                          ),
                        if (this.location != null)
                          SizedBox(
                            height: 150,
                            child: GoogleMap(
                              compassEnabled: false,
                              zoomControlsEnabled: false,
                              mapType: MapType.normal,
                              initialCameraPosition: CameraPosition(target: LatLng(this.location.latitude, this.location.longitude)),
                              onMapCreated: (final controller) {
                                this._onMapCreated(controller, LatLng(this.location.latitude, this.location.longitude), 14);
                              },
                              markers: Set<Marker>.of(
                                [
                                  Marker(
                                    markerId: MarkerId("1"),
                                    position: LatLng(
                                      this.location.latitude,
                                      this.location.longitude,
                                    ),
                                  ),
                                ],
                              ),
                              circles: Set<Circle>.of(
                                [
                                  Circle(
                                    circleId: CircleId("2"),
                                    center: LatLng(this.location.latitude, this.location.longitude),
                                    radius: this.notificationRadius * 1000,
                                    fillColor: Theme.of(context).primaryColorDark.withOpacity(0.8),
                                    strokeColor: Theme.of(context).primaryColor,
                                    strokeWidth: 2,
                                  )
                                ],
                              ),
                            ),
                          ),
                        if (this.newLocation)
                          SwitchListTile(
                            value: this.saveLocation,
                            activeColor: Theme.of(context).primaryColor,
                            onChanged: (value) async {
                              setState(() {
                                this.saveLocation = !this.saveLocation;
                              });

                              if (this.saveLocation) {
                                String name = await Dialogs.showTextFieldDialog(context, AppLocalizations.of(context).enterLocationName);
                                if (name != null) {
                                  this.location.localizationName = name;
                                  this.location.saved = true;
                                } else {
                                  this.location.localizationName = '';
                                  this.location.saved = false;
                                  setState(() {
                                    this.saveLocation = false;
                                  });
                                }
                              } else {
                                this.location.localizationName = '';
                                this.location.saved = false;
                              }

                              await Provider.of<LocationProvider>(context, listen: false).editLocationName(
                                this.location.uuid,
                                this.location.localizationName,
                                this.location.saved,
                              );
                            },
                            title: Text(AppLocalizations.of(context).saveLocation),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4),
                child: Card(
                  elevation: 8,
                  child: Column(
                    children: [
                      Text(AppLocalizations.of(context).changeNotificationRange),
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
                      Text(AppLocalizations.of(context).actualRange + this.notificationRadius.toStringAsFixed(2) + ' km'),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4),
                child: Card(
                  elevation: 8,
                  child: SwitchListTile(
                    activeColor: Theme.of(context).primaryColor,
                    title: Text(AppLocalizations.of(context).notificationOnEnter),
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
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4),
                child: Card(
                  elevation: 8,
                  child: SwitchListTile(
                    activeColor: Theme.of(context).primaryColor,
                    title: Text(AppLocalizations.of(context).notificationOnExit),
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
                    onPressed: () {
                      Navigator.of(context).pop(null);
                    },
                    child: Text(AppLocalizations.of(context).cancel),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await Notifications.removeGeofence(this.widget.taskUuid);
                      setState(() {
                        this.deleted = true;
                        this.location = null;
                        this.notificationOnEnter = false;
                        this.notificationOnExit = false;
                        this.notificationRadius = 0.1;
                      });
                    },
                    child: Text(AppLocalizations.of(context).delete),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (this.location != null) {
                        TaskLocation returnLocation = TaskLocation(
                          location: this.location,
                          notificationOnEnter: this.notificationOnEnter,
                          notificationOnExit: this.notificationOnExit,
                          notificationRadius: this.notificationRadius,
                        );

                        Navigator.of(context).pop(returnLocation);
                      } else if (this.deleted && this.widget.taskUuid != null) {
                        Navigator.of(context).pop(-1);
                      } else {
                        Navigator.of(context).pop('cancel');
                      }
                    },
                    child: Text(AppLocalizations.of(context).save),
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
