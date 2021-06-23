import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong/latlong.dart';
import 'package:provider/provider.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg;

import '../models/location.dart' as model;
import '../providers/location_provider.dart';

class LocationDialog extends StatefulWidget {
  static const String route = 'map_controller_animated';
  final model.Location choosenLocation;
  final String choosenMail;

  LocationDialog({
    this.choosenLocation,
    this.choosenMail,
  });

  @override
  LocationDialogState createState() {
    return LocationDialogState();
  }
}

class LocationDialogState extends State<LocationDialog> with TickerProviderStateMixin {
  List<MapEntry<Placemark, LatLng>> placemarks = [];
  String searchString;

  final TextEditingController _textEditingController = TextEditingController();
  final MapController _mapController = MapController();

  Future<void> getPlacemarks(BuildContext context, String search) async {
    await Provider.of<LocationProvider>(context, listen: false).findGlobalLocationsFromQuery(search);
    placemarks = Provider.of<LocationProvider>(context, listen: false).marks;
  }

  Future<void> getAddress(double latitude, double longitude) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);

    this.widget.choosenLocation.country = placemarks.first.country;
    this.widget.choosenLocation.locality = placemarks.first.locality;
    this.widget.choosenLocation.street = placemarks.first.street;
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

  void getUserLocation() async {
    if (this.widget.choosenLocation.latitude == 0.0 && this.widget.choosenLocation.longitude == 0.0) {
      bg.Location location = await bg.BackgroundGeolocation.getCurrentPosition(
        timeout: 3,
        maximumAge: 10000,
        desiredAccuracy: 100,
        samples: 3,
      );

      setState(() {
        this.widget.choosenLocation.latitude = location.coords.latitude;
        this.widget.choosenLocation.longitude = location.coords.longitude;
        this.getAddress(location.coords.latitude, location.coords.longitude);
      });

      LatLng point = LatLng(this.widget.choosenLocation.latitude, this.widget.choosenLocation.longitude);
      this._animatedMapMove(point, 18.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    this.getUserLocation();

    return StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
          content: Container(
            width: double.maxFinite,
            child: Stack(
              children: [
                Container(
                  height: 600,
                  width: 400,
                  child: FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      onTap: (point) {
                        setState(() {
                          this.widget.choosenLocation.latitude = point.latitude;
                          this.widget.choosenLocation.longitude = point.longitude;
                          this.getAddress(point.latitude, point.longitude);
                        });
                      },
                      center: LatLng(widget.choosenLocation.latitude, widget.choosenLocation.longitude),
                      zoom: 10.0,
                    ),
                    layers: [
                      TileLayerOptions(
                        urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                        subdomains: ['a', 'b', 'c'],
                      ),
                      MarkerLayerOptions(
                        markers: [
                          Marker(
                            width: 150.0,
                            height: 150.0,
                            point: LatLng(widget.choosenLocation.latitude, widget.choosenLocation.longitude),
                            builder: (context) => Icon(
                              Icons.location_on,
                              color: Colors.red,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                  child: Card(
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 400),
                      curve: Curves.easeInOut,
                      height: (this.searchString != null && this.searchString.length > 2) ? 180 : 52,
                      child: Column(
                        children: [
                          TextField(
                            controller: _textEditingController,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.location_on),
                              hintText: "Search for location",
                              contentPadding: EdgeInsets.all(16.0),
                            ),
                            onChanged: (search) async {
                              await getPlacemarks(context, search);
                              setState(() {
                                searchString = search;
                              });
                            },
                          ),
                          if (searchString != null && searchString.length >= 3 && placemarks != [])
                            Flexible(
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: this.placemarks.length,
                                itemBuilder: (context, index) => ListTile(
                                  title: Text(placemarks[index].key.locality + ", " + placemarks[index].key.street),
                                  subtitle: Text(placemarks[index].key.country),
                                  onTap: () {
                                    setState(
                                      () {
                                        LatLng point = LatLng(placemarks[index].value.latitude, placemarks[index].value.longitude);
                                        this._animatedMapMove(point, 18.0);

                                        this.widget.choosenLocation.latitude = point.latitude;
                                        this.widget.choosenLocation.longitude = point.longitude;
                                        this.widget.choosenLocation.country = placemarks[index].key.country;
                                        this.widget.choosenLocation.street = placemarks[index].key.street;
                                        this.widget.choosenLocation.locality = placemarks[index].key.locality;

                                        _textEditingController.clear();
                                        searchString = '';
                                      },
                                    );
                                  },
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                        child: Column(
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Theme.of(context).primaryColor,
                                side: BorderSide(color: Theme.of(context).primaryColor),
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
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
