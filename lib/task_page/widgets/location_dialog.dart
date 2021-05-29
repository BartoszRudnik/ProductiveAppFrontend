import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:latlong/latlong.dart';
import 'package:productive_app/task_page/models/location.dart' as model;
import 'package:productive_app/task_page/providers/location_provider.dart';
import 'package:provider/provider.dart';

class LocationDialog extends StatefulWidget {
  static const String route = 'map_controller_animated';
  model.Location choosenLocation;
  String choosenMail;
  LocationDialog({
    this.choosenLocation,
    this.choosenMail,
  });

  @override
  LocationDialogState createState() {
    return LocationDialogState();
  }
}

class LocationDialogState extends State<LocationDialog> with TickerProviderStateMixin{
  final _locationKey = GlobalKey<FormState>();

  List<MapEntry<Placemark,LatLng>> placemarks = [];
  String searchString;
  String _serverUrl = GlobalConfiguration().getValue("serverUrl");

  final TextEditingController _textEditingController = TextEditingController();
  final MapController _mapController = MapController();


  Future<void> getPlacemarks(BuildContext context, String search) async {
    await Provider.of<LocationProvider>(context, listen: false)
        .findGlobalLocationsFromQuery(search);
    placemarks = Provider.of<LocationProvider>(context, listen: false).marks;
  }

  void _animatedMapMove(LatLng destLocation, double destZoom) {
    final _latTween = Tween<double>(
        begin: _mapController.center.latitude, end: destLocation.latitude);
    final _lngTween = Tween<double>(
        begin: _mapController.center.longitude, end: destLocation.longitude);
    final _zoomTween = Tween<double>(begin: _mapController.zoom, end: destZoom);

    var controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);

    Animation<double> animation =
        CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);

    controller.addListener(() {
      _mapController.move(
          LatLng(_latTween.evaluate(animation), _lngTween.evaluate(animation)),
          _zoomTween.evaluate(animation));
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

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
          content: Stack(
            children: [
              FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                    onTap: (point) {
                      setState(() {
                        widget.choosenLocation.latitude = point.latitude;
                        widget.choosenLocation.longitude = point.longitude;
                        print(widget.choosenLocation.latitude.toString() +
                            "," +
                            widget.choosenLocation.longitude.toString());
                      });
                    },
                    center: LatLng(widget.choosenLocation.latitude, widget.choosenLocation.longitude),
                    zoom: 10.0),
                layers: [
                  TileLayerOptions(
                      urlTemplate:
                          "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                      subdomains: ['a', 'b', 'c']),
                  MarkerLayerOptions(markers: [
                    Marker(
                        width: 150.0,
                        height: 150.0,
                        point: LatLng(widget.choosenLocation.latitude,
                            widget.choosenLocation.longitude),
                        builder: (context) => Icon(
                              Icons.location_on,
                              color: Colors.red,
                            ))
                  ])
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                child: Column(
                  children: [
                    Card(
                        child: Container(
                      child: Column(
                        children: [
                          TextField(
                            controller: _textEditingController,
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.location_on),
                                hintText: "Search for location",
                                contentPadding: EdgeInsets.all(16.0)),
                            onChanged: (search) async {
                              await getPlacemarks(context, search);
                              setState(() {
                                searchString = search;
                              });
                            },
                          ),
                          if (searchString != null &&
                              searchString.length >= 3 &&
                              placemarks != [])
                            Container(
                              height: 180,
                              child: SingleChildScrollView(
                                  child: Container(
                                child: Column(
                                  children: List.generate(
                                      placemarks.length,
                                      (index) => ListTile(
                                            title: Text(
                                                placemarks[index].key.locality +
                                                    ", " +
                                                    placemarks[index].key.street),
                                            subtitle:
                                                Text(placemarks[index].key.country),
                                              onTap: (){
                                                setState(() {
                                                  LatLng point = LatLng(placemarks[index].value.latitude, placemarks[index].value.longitude);
                                                  widget.choosenLocation.latitude = point.latitude;
                                                  widget.choosenLocation.longitude = point.longitude;
                                                  _animatedMapMove(point, 15.0);
                                                  print(widget.choosenLocation.latitude.toString() +
                                                      "," +
                                                      widget.choosenLocation.longitude.toString());
                                                  _textEditingController.clear();
                                                  searchString = '';
                                                });
                                              },
                                          )),
                                ),
                              )),
                            )
                        ],
                      ),
                    ))
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10.0),
                        child: Column(
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Theme.of(context).primaryColor,
                                side: BorderSide(
                                    color: Theme.of(context).primaryColor),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop(widget.choosenLocation);
                              },
                              child: Text(
                                'Add location',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context).accentColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ))
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
