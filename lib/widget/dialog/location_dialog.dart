import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg;
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../model/location.dart' as model;
import '../../provider/location_provider.dart';

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
  String _darkMapStyle = '';
  String _lightMapStyle = '';

  final TextEditingController _textEditingController = TextEditingController();
  GoogleMapController _mapController;

  @override
  void initState() {
    super.initState();

    this._loadMapStyles();
  }

  final _startPosition = CameraPosition(
    target: LatLng(0, 0),
    zoom: 15,
  );

  Future _loadMapStyles() async {
    this._darkMapStyle = await rootBundle.loadString('assets/map/darkMap.json');
    this._lightMapStyle = await rootBundle.loadString('assets/map/lightMap.json');
  }

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

  void _animatedMapMove(LatLng point, double zoom) {
    this._mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: point, zoom: zoom),
          ),
        );
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
      this._animatedMapMove(point, 15);
    }
  }

  void _onMapCreated(GoogleMapController _controller, double longitude, double latitude) async {
    this._mapController = _controller;

    if (longitude != null && latitude != null) {
      this._animatedMapMove(LatLng(latitude, longitude), 15);
    }

    this._mapController.setMapStyle(
          Theme.of(context).brightness == Brightness.light ? this._lightMapStyle : this._darkMapStyle,
        );
  }

  @override
  Widget build(BuildContext context) {
    this.getUserLocation();

    if (this.widget.choosenLocation.latitude != null && this.widget.choosenLocation.longitude != null && this._mapController != null) {
      this._animatedMapMove(LatLng(this.widget.choosenLocation.latitude, this.widget.choosenLocation.longitude), 15);
    }

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
                  child: GoogleMap(
                    initialCameraPosition: this._startPosition,
                    onMapCreated: (final controller) {
                      this._onMapCreated(controller, this.widget.choosenLocation.longitude, this.widget.choosenLocation.latitude);
                    },
                    onTap: (point) {
                      setState(() {
                        this.widget.choosenLocation.latitude = point.latitude;
                        this.widget.choosenLocation.longitude = point.longitude;
                        this.getAddress(point.latitude, point.longitude);
                      });
                    },
                    markers: Set<Marker>.of([
                      Marker(
                        markerId: MarkerId((this.widget.choosenLocation.latitude + this.widget.choosenLocation.longitude).toString()),
                        position: LatLng(
                          this.widget.choosenLocation.latitude,
                          this.widget.choosenLocation.longitude,
                        ),
                      ),
                    ]),
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
                              onPressed: () {
                                Navigator.of(context).pop(widget.choosenLocation);
                              },
                              child: Text('Save location'),
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
