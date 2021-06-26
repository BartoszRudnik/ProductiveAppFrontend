import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg;
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:provider/provider.dart';

import '../models/task.dart';
import '../providers/location_provider.dart';
import '../providers/task_provider.dart';
import 'task_details_screen.dart';

class TaskMap extends StatefulWidget {
  static const routeName = "/task-map";

  @override
  TaskMapState createState() {
    return TaskMapState();
  }
}

class TaskMapState extends State<TaskMap> with TickerProviderStateMixin {
  final MapController _mapController = MapController();

  int actualMarkerId;
  List<Marker> markers = [];
  List<Task> tasks = [];

  double startLatitude = 0.0;
  double startLongitude = 0.0;

  @override
  void initState() {
    super.initState();

    this.getTasks();
  }

  void getTasks() {
    tasks = Provider.of<TaskProvider>(context, listen: false).tasksWithLocation;
    this.markers = [];

    for (int i = 0; i < tasks.length; i++) {
      final latitude = Provider.of<LocationProvider>(context, listen: false).getLatitude(tasks[i].notificationLocalizationId);
      final longitude = Provider.of<LocationProvider>(context, listen: false).getLongitude(tasks[i].notificationLocalizationId);

      final newMarker = Marker(
        width: 150.0,
        height: 150.0,
        point: LatLng(latitude, longitude),
        builder: (context) => GestureDetector(
          onTap: () {
            LatLng point = LatLng(latitude, longitude);
            this._animatedMapMove(point, 16.0);
            setState(() {
              startLatitude = latitude;
              startLongitude = longitude;
            });

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
          child: Icon(
            Icons.location_on,
            color: tasks[i].id == actualMarkerId ? Colors.red : Colors.black,
          ),
        ),
      );

      markers.add(newMarker);
    }
  }

  void getUserLocation() async {
    if (startLatitude == 0.0 && startLongitude == 0.0) {
      bg.Location location = await bg.BackgroundGeolocation.getCurrentPosition(
        timeout: 3,
        maximumAge: 10000,
        desiredAccuracy: 100,
        samples: 3,
      );

      setState(() {
        startLatitude = location.coords.latitude;
        startLongitude = location.coords.longitude;
      });

      LatLng point = LatLng(startLatitude, startLongitude);
      this._animatedMapMove(point, 16.0);
    }
  }

  void _animatedMapMove(LatLng destLocation, double destZoom) {
    final _latTween = Tween<double>(begin: _mapController.center.latitude, end: destLocation.latitude);
    final _lngTween = Tween<double>(begin: _mapController.center.longitude, end: destLocation.longitude);
    final _zoomTween = Tween<double>(begin: _mapController.zoom, end: destZoom);

    var controller = AnimationController(duration: const Duration(milliseconds: 500), vsync: this);

    Animation<double> animation = CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);

    controller.addListener(() {
      _mapController.move(LatLng(_latTween.evaluate(animation), _lngTween.evaluate(animation)), _zoomTween.evaluate(animation));
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.dispose();
      } else if (status == AnimationStatus.dismissed) {
        controller.dispose();
      }
    });

    controller.forward();
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
      backgroundColor: Colors.white,
      context: context,
      builder: (context) {
        return Container(
          height: task.description != null && task.description.length > 0 ? 160 : 135,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Center(
                child: Text(
                  "Task info",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
              ListTile(
                title: Text(
                  'Task title: ' + task.title,
                ),
                subtitle: Text(
                  task.description.length > 0 ? 'Task description: ' + task.description : '',
                ),
              ),
              Container(
                height: 40,
                padding: EdgeInsets.only(top: 3),
                decoration: BoxDecoration(
                  color: Theme.of(context).accentColor,
                  border: Border(
                    top: BorderSide(color: Theme.of(context).primaryColor, width: 1.2),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: Icon(Icons.navigate_before_outlined),
                      onPressed: () {
                        final latitude = Provider.of<LocationProvider>(context, listen: false).getLatitude(tasks[previousTaskIndex].notificationLocalizationId);
                        final longitude = Provider.of<LocationProvider>(context, listen: false).getLongitude(tasks[previousTaskIndex].notificationLocalizationId);

                        LatLng point = LatLng(latitude, longitude);
                        this._animatedMapMove(point, 16.0);
                        setState(() {
                          startLatitude = latitude;
                          startLongitude = longitude;
                        });

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
                      style: ElevatedButton.styleFrom(
                        primary: Theme.of(context).primaryColor,
                        side: BorderSide(color: Theme.of(context).primaryColor),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
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
                        Navigator.of(context).pushNamed(TaskDetailScreen.routeName, arguments: task).then((value) {
                          setState(() {
                            this.getTasks();
                          });
                          Navigator.of(context).pop('nextTask');
                          return this._onMarkerPressed(tasks.firstWhere((element) => element.id == task.id), previousTaskIndex, nextTaskIndex);
                        });
                      },
                      child: Text(
                        'Task details',
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).accentColor,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.navigate_next_outlined),
                      onPressed: () {
                        final latitude = Provider.of<LocationProvider>(context, listen: false).getLatitude(tasks[nextTaskIndex].notificationLocalizationId);
                        final longitude = Provider.of<LocationProvider>(context, listen: false).getLongitude(tasks[nextTaskIndex].notificationLocalizationId);

                        LatLng point = LatLng(latitude, longitude);
                        this._animatedMapMove(point, 16.0);
                        setState(() {
                          startLatitude = latitude;
                          startLongitude = longitude;
                        });

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
    this.getUserLocation();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tasks map',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w400,
            color: Theme.of(context).primaryColor,
          ),
        ),
        systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: Colors.black),
        backgroundColor: Theme.of(context).accentColor,
        iconTheme: Theme.of(context).iconTheme,
        brightness: Brightness.dark,
      ),
      body: StatefulBuilder(
        builder: (context, setState) {
          return Container(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                onTap: (point) {},
                center: LatLng(startLatitude, startLongitude),
                zoom: 15.0,
              ),
              layers: [
                TileLayerOptions(
                  urlTemplate: "https://cartodb-basemaps-{s}.global.ssl.fastly.net/light_all/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c'],
                ),
                MarkerLayerOptions(
                  markers: (markers != null && markers.length >= 1) ? markers.toList() : [],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
