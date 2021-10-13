import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:productive_app/config/images.dart';
import 'package:productive_app/screen/task_details_loading_screen.dart';
import 'package:productive_app/utils/dialogs.dart';
import 'package:productive_app/utils/internet_connection.dart';
import 'package:provider/provider.dart';
import '../model/task.dart';
import '../provider/location_provider.dart';
import '../provider/task_provider.dart';
import '../widget/appBar/filters_appBar.dart';
import 'task_details_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TaskMap extends StatefulWidget {
  static const routeName = "/task-map";

  @override
  TaskMapState createState() {
    return TaskMapState();
  }
}

class TaskMapState extends State<TaskMap> with TickerProviderStateMixin {
  GoogleMapController _mapController;
  String _darkMapStyle = '';
  String _lightMapStyle = '';

  int actualMarkerId;
  List<Marker> markers = [];
  List<Task> tasks = [];

  bool isInternetConnection = false;

  BitmapDescriptor defaultIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
  BitmapDescriptor selectedIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan);

  final _startPosition = CameraPosition(
    target: LatLng(0, 0),
    zoom: 16,
  );

  @override
  void initState() {
    super.initState();

    InternetConnection.internetConnection().then((value) {
      setState(() {
        this.isInternetConnection = value;
      });
    });

    this._loadMapStyles();
  }

  Future _loadMapStyles() async {
    this._darkMapStyle = await rootBundle.loadString('assets/map/darkMap.json');
    this._lightMapStyle = await rootBundle.loadString('assets/map/lightMap.json');
  }

  void _getTasks() async {
    tasks = Provider.of<TaskProvider>(context, listen: false).tasksWithLocation;
    this.markers = [];

    if (tasks.length == 0 && this.isInternetConnection) {
      await Future.delayed(Duration(seconds: 1));
      await Dialogs.showWarningDialog(context, AppLocalizations.of(context).noLocationTasks);
    }

    for (int i = 0; i < tasks.length; i++) {
      final latitude = Provider.of<LocationProvider>(context, listen: false).getLatitude(tasks[i].notificationLocalizationUuid);
      final longitude = Provider.of<LocationProvider>(context, listen: false).getLongitude(tasks[i].notificationLocalizationUuid);

      final newMarker = Marker(
        icon: tasks[i].id == actualMarkerId ? this.selectedIcon : this.defaultIcon,
        markerId: MarkerId(tasks[i].id.toString()),
        position: LatLng(latitude, longitude),
        onTap: () {
          LatLng point = LatLng(latitude, longitude);
          this._animatedMapMove(point, 16.0);

          int nextIndex = i;
          int previousIndex = i;

          if (i > 0) {
            previousIndex -= 1;
          } else {
            previousIndex = tasks.length - 1;
          }

          if (i < tasks.length - 1) {
            nextIndex += 1;
          } else {
            nextIndex = 0;
          }

          return this._onMarkerPressed(tasks[i], previousIndex, nextIndex);
        },
      );

      markers.add(newMarker);
    }
  }

  void _onMapCreated(GoogleMapController _controller) async {
    this._mapController = _controller;

    this._mapController.setMapStyle(
          Theme.of(context).brightness == Brightness.light ? this._lightMapStyle : this._darkMapStyle,
        );

    if (this.tasks.length == 0) {
      bg.Location location = await bg.BackgroundGeolocation.getCurrentPosition(
        timeout: 3,
        maximumAge: 10000,
        desiredAccuracy: 100,
        samples: 3,
      );

      this._mapMove(LatLng(location.coords.latitude, location.coords.longitude), 15);
    } else {
      final latitude = Provider.of<LocationProvider>(context, listen: false).getLatitude(this.tasks[0].notificationLocalizationUuid);
      final longitude = Provider.of<LocationProvider>(context, listen: false).getLongitude(this.tasks[0].notificationLocalizationUuid);

      this._mapMove(LatLng(latitude, longitude), 15);
    }
  }

  void _animatedMapMove(LatLng point, double zoom) {
    this._mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: point, zoom: zoom),
          ),
        );
  }

  void _mapMove(LatLng point, double zoom) {
    this._mapController.moveCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: point, zoom: zoom),
          ),
        );
  }

  void _onMarkerPressed(Task task, int previousTaskIndex, int nextTaskIndex) {
    setState(() {
      this.actualMarkerId = task.id;
    });

    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(30.0),
          topRight: const Radius.circular(30.0),
        ),
      ),
      backgroundColor: Theme.of(context).primaryColorLight,
      context: context,
      builder: (context) {
        return Container(
          height: task.description != null && task.description.length > 0 ? 190 : 165,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Center(
                child: Text(
                  AppLocalizations.of(context).task +
                      " (" +
                      (this.tasks.indexWhere((element) => element.id == task.id) + 1).toString() +
                      '/' +
                      this.tasks.length.toString() +
                      ')',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
              ListTile(
                title: Text(
                  AppLocalizations.of(context).taskTitle + ": " + task.title,
                ),
                subtitle: Text(
                  task.description.length > 0 ? AppLocalizations.of(context).taskDescription + ": " + task.description : '',
                ),
              ),
              Container(
                height: 70,
                padding: EdgeInsets.only(top: 3, bottom: 12),
                decoration: BoxDecoration(
                  color: Theme.of(context).accentColor,
                  border: Border(
                    top: BorderSide(color: Theme.of(context).primaryColor, width: 1),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.navigate_before_outlined),
                      onPressed: () {
                        final latitude =
                            Provider.of<LocationProvider>(context, listen: false).getLatitude(tasks[previousTaskIndex].notificationLocalizationUuid);
                        final longitude =
                            Provider.of<LocationProvider>(context, listen: false).getLongitude(tasks[previousTaskIndex].notificationLocalizationUuid);

                        LatLng point = LatLng(latitude, longitude);
                        this._animatedMapMove(point, 16.0);

                        int nextIndex = previousTaskIndex;
                        int previousIndex = previousTaskIndex;

                        if (previousTaskIndex > 0) {
                          previousIndex -= 1;
                        } else {
                          previousIndex = tasks.length - 1;
                        }

                        if (previousTaskIndex < tasks.length - 1) {
                          nextIndex += 1;
                        } else {
                          nextIndex = 0;
                        }

                        Navigator.of(context).pop('nextTask');
                        return this._onMarkerPressed(tasks[previousTaskIndex], previousIndex, nextIndex);
                      },
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(AppLocalizations.of(context).cancel),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(TaskDetailsLoadingScreen.routeName, arguments: task).then((value) {
                          setState(
                            () {
                              this._getTasks();
                            },
                          );
                          Navigator.of(context).pop('nextTask');
                          return this._onMarkerPressed(tasks.firstWhere((element) => element.id == task.id), previousTaskIndex, nextTaskIndex);
                        });
                      },
                      child: Text(AppLocalizations.of(context).details),
                    ),
                    IconButton(
                      icon: Icon(Icons.navigate_next_outlined),
                      onPressed: () {
                        final latitude = Provider.of<LocationProvider>(context, listen: false).getLatitude(tasks[nextTaskIndex].notificationLocalizationUuid);
                        final longitude = Provider.of<LocationProvider>(context, listen: false).getLongitude(tasks[nextTaskIndex].notificationLocalizationUuid);

                        LatLng point = LatLng(latitude, longitude);
                        this._animatedMapMove(point, 16.0);

                        int nextIndex = nextTaskIndex;
                        int previousIndex = nextTaskIndex;

                        if (nextTaskIndex > 0) {
                          previousIndex -= 1;
                        } else {
                          previousIndex = tasks.length - 1;
                        }

                        if (nextTaskIndex < tasks.length - 1) {
                          nextIndex += 1;
                        } else {
                          nextIndex = 0;
                        }

                        Navigator.of(context).pop('nextTask');
                        return this._onMarkerPressed(tasks[nextTaskIndex], previousIndex, nextIndex);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    ).then((value) {
      if (value == null || value != 'nextTask') {
        setState(() {
          this.actualMarkerId = -1;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    this._getTasks();

    return Scaffold(
      appBar: FiltersAppBar(title: AppLocalizations.of(context).taskMap),
      body: this.isInternetConnection
          ? Container(
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              child: GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: this._startPosition,
                onMapCreated: (final controller) {
                  this._onMapCreated(controller);
                },
                markers: Set<Marker>.of(this.markers),
              ),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  child: Image.asset(
                    Images.noInternet,
                  ),
                ),
                Text('No internet connection, try again later'),
                ElevatedButton(
                  onPressed: () async {
                    final internetConnection = await InternetConnection.internetConnection();

                    if (internetConnection != this.isInternetConnection) {
                      setState(() {
                        this.isInternetConnection = internetConnection;
                      });
                    }
                  },
                  child: Text('Try again'),
                ),
              ],
            ),
    );
  }
}
