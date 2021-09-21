import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:productive_app/model/task.dart';
import 'package:productive_app/widget/new_task_notification_localization.dart';

class TaskDetailsMap extends StatefulWidget {
  final Function setLocation;
  final Function setNotificationLocalization;
  final Task taskToEdit;
  final Task originalTask;
  final latitude;
  final longitude;
  final locationChanged;

  TaskDetailsMap({
    @required this.setLocation,
    @required this.setNotificationLocalization,
    @required this.taskToEdit,
    @required this.originalTask,
    @required this.latitude,
    @required this.longitude,
    @required this.locationChanged,
  });

  @override
  _TaskDetailsMapState createState() => _TaskDetailsMapState();
}

class _TaskDetailsMapState extends State<TaskDetailsMap> {
  GoogleMapController _mapController;
  String _darkMapStyle = '';
  String _lightMapStyle = '';
  final _startPosition = CameraPosition(
    target: LatLng(0, 0),
    zoom: 15,
  );

  @override
  void initState() {
    super.initState();

    this._loadMapStyles();
  }

  Future _loadMapStyles() async {
    this._darkMapStyle = await rootBundle.loadString('assets/map/darkMap.json');
    this._lightMapStyle = await rootBundle.loadString('assets/map/lightMap.json');
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
    if (this.widget.locationChanged && this._mapController != null) {
      this._mapMove(
        LatLng(this.widget.latitude, this.widget.longitude),
        15,
      );
    }

    return Container(
      height: 175,
      child: Stack(
        children: [
          if (this.widget.taskToEdit.notificationLocalizationUuid != null && this.widget.latitude != null && this.widget.longitude != null)
            Container(
              height: 175,
              width: double.infinity,
              child: GoogleMap(
                compassEnabled: false,
                zoomControlsEnabled: false,
                mapType: MapType.normal,
                initialCameraPosition: this._startPosition,
                onMapCreated: (final controller) {
                  this._onMapCreated(controller, LatLng(this.widget.latitude, this.widget.longitude), 15);
                },
                markers: Set<Marker>.of(
                  [
                    Marker(
                      markerId: MarkerId(this.widget.taskToEdit.id.toString()),
                      position: LatLng(
                        this.widget.latitude,
                        (this.widget.longitude),
                      ),
                    ),
                  ],
                ),
                circles: Set<Circle>.of(
                  [
                    Circle(
                      circleId: CircleId(this.widget.taskToEdit.id.toString()),
                      center: LatLng(this.widget.latitude, this.widget.longitude),
                      radius: this.widget.taskToEdit.notificationLocalizationRadius * 1000,
                      fillColor: Theme.of(context).primaryColorDark.withOpacity(0.8),
                      strokeColor: Theme.of(context).primaryColor,
                      strokeWidth: 2,
                    )
                  ],
                ),
              ),
            ),
          if (this.widget.taskToEdit.notificationLocalizationUuid == null || this.widget.longitude == null || this.widget.latitude == null)
            Column(
              children: [
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
                          setNotificationLocalization: this.widget.setNotificationLocalization,
                          notificationLocalizationUuid: this.widget.taskToEdit.notificationLocalizationUuid,
                          notificationOnEnter: this.widget.taskToEdit.notificationOnEnter,
                          notificationOnExit: this.widget.taskToEdit.notificationOnExit,
                          notificationRadius: this.widget.taskToEdit.notificationLocalizationRadius,
                          taskUuid: this.widget.originalTask.uuid,
                        ),
                        Text(
                          AppLocalizations.of(context).tapToAddLocation,
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          GestureDetector(
            onTap: () {
              this.widget.setLocation();
            },
          ),
        ],
      ),
    );
  }
}
