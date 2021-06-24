import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:intl/intl.dart';
import 'package:latlong/latlong.dart';
import 'package:productive_app/task_page/models/task.dart';
import 'package:productive_app/task_page/task_screens/task_details_screen.dart';
import 'package:productive_app/task_page/widgets/task_tags.dart';
import 'package:provider/provider.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg;

import '../providers/location_provider.dart';
import '../providers/task_provider.dart';

class TaskMap extends StatefulWidget {
  static const routeName = "/task-map";

  @override
  TaskMapState createState() {
    return TaskMapState();
  }
}

class TaskMapState extends State<TaskMap> with TickerProviderStateMixin {
  final MapController _mapController = MapController();

  double startLatitude = 0.0;
  double startLongitude = 0.0;

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

  void _onMarkerPressed(Task task) {
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
          height: 260,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(237, 237, 240, 1),
                    border: Border.all(
                      color: Color.fromRGBO(221, 221, 226, 1),
                      width: 2.5,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 30,
                      ),
                      Text('Task title: '),
                      SizedBox(
                        width: 10,
                      ),
                      Text(task.title),
                    ],
                  ),
                ),
              ),
              if (task.description.length > 0)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(237, 237, 240, 1),
                      border: Border.all(
                        color: Color.fromRGBO(221, 221, 226, 1),
                        width: 2.5,
                      ),
                    ),
                    child: Center(
                      child: Text(task.description),
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(237, 237, 240, 1),
                    border: Border.all(
                      color: Color.fromRGBO(221, 221, 226, 1),
                      width: 2.5,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      if (task.priority == 'LOW') Icon(Icons.arrow_downward_outlined),
                      if (task.priority == 'HIGH') Icon(Icons.arrow_upward_outlined),
                      if (task.priority == 'HIGHER') Icon(Icons.arrow_upward_outlined),
                      if (task.priority == 'HIGHER') Icon(Icons.arrow_upward_outlined),
                      if (task.priority == 'CRITICAL') Icon(Icons.warning_amber_sharp),
                      SizedBox(width: 6),
                      if (task.startDate != null || task.endDate != null) Icon(Icons.calendar_today),
                      SizedBox(width: 6),
                      task.startDate != null
                          ? Text(
                              DateFormat('MMM d').format(task.startDate) + ' - ',
                            )
                          : Text(''),
                      task.endDate != null
                          ? Text(
                              DateFormat('MMM d').format(task.endDate),
                            )
                          : Text(''),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(237, 237, 240, 1),
                    border: Border.all(
                      color: Color.fromRGBO(221, 221, 226, 1),
                      width: 2.5,
                    ),
                  ),
                  child: TaskTags(tags: task.tags),
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
                        Navigator.of(context).pushNamed(TaskDetailScreen.routeName, arguments: task);
                      },
                      child: Text(
                        'Task details',
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).accentColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    this.getUserLocation();

    final tasks = Provider.of<TaskProvider>(context, listen: false).tasksWithLocation;
    List<Marker> markers = [];

    tasks.forEach((task) {
      final latitude = Provider.of<LocationProvider>(context, listen: false).getLatitude(task.notificationLocalizationId);
      final longitude = Provider.of<LocationProvider>(context, listen: false).getLongitude(task.notificationLocalizationId);

      final newMarker = Marker(
        width: 150.0,
        height: 150.0,
        point: LatLng(latitude, longitude),
        builder: (context) => GestureDetector(
          onTap: () {
            return this._onMarkerPressed(task);
          },
          child: Icon(
            Icons.location_on,
            color: Colors.red,
          ),
        ),
      );

      markers.add(newMarker);
    });

    return Scaffold(
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
                  urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
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
