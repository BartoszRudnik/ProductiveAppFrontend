import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg;
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:productive_app/widget/button/save_location_button.dart';
import '../../model/location.dart' as model;
import '../find_place.dart';

class LocationDialog extends StatefulWidget {
  static const String route = 'map_controller_animated';
  model.Location choosenLocation;
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
  String _darkMapStyle = '';
  String _lightMapStyle = '';

  GoogleMapController _mapController;

  @override
  void initState() {
    super.initState();

    this._loadMapStyles();
    this.getUserLocation();
  }

  final _startPosition = CameraPosition(
    target: LatLng(0, 0),
    zoom: 15,
  );

  Future _loadMapStyles() async {
    this._darkMapStyle = await rootBundle.loadString('assets/map/darkMap.json');
    this._lightMapStyle = await rootBundle.loadString('assets/map/lightMap.json');
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

  void _mapMove(LatLng point, double zoom) {
    if (this._mapController != null) {
      this._mapController.moveCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(target: point, zoom: zoom),
            ),
          );
    }
  }

  void getUserLocation() async {
    try {
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
        this._mapMove(point, 15);
      }
    } catch (error) {
      this._mapMove(LatLng(52, 21), 4);
    }
  }

  void _onMapCreated(GoogleMapController _controller, double longitude, double latitude) async {
    this._mapController = _controller;

    if (longitude != null && latitude != null) {
      this._mapMove(LatLng(latitude, longitude), 15);
    }

    this._mapController.setMapStyle(
          Theme.of(context).brightness == Brightness.light ? this._lightMapStyle : this._darkMapStyle,
        );
  }

  void setChoosenLocation(double latitude, double longitude, String country, String street, String locality) {
    setState(() {
      this.widget.choosenLocation.latitude = latitude;
      this.widget.choosenLocation.longitude = longitude;
      this.widget.choosenLocation.country = country;
      this.widget.choosenLocation.street = street;
      this.widget.choosenLocation.locality = locality;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                    markers: Set<Marker>.of(
                      [
                        Marker(
                          markerId: MarkerId((this.widget.choosenLocation.latitude + this.widget.choosenLocation.longitude).toString()),
                          position: LatLng(
                            this.widget.choosenLocation.latitude,
                            this.widget.choosenLocation.longitude,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                FindPlace(
                  mapMove: this._animatedMapMove,
                  setChoosenLocation: this.setChoosenLocation,
                ),
                SaveLocationButton(
                  choosenLocation: this.widget.choosenLocation,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
