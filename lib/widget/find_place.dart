import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:productive_app/model/coordinates_and_name.dart';
import 'package:productive_app/provider/location_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg;

class FindPlace extends StatefulWidget {
  final Function mapMove;
  final Function setChoosenLocation;

  FindPlace({
    @required this.mapMove,
    @required this.setChoosenLocation,
  });

  @override
  _FindPlaceState createState() => _FindPlaceState();
}

class _FindPlaceState extends State<FindPlace> {
  List<MapEntry<Placemark, CoordinatesAndName>> placemarks = [];
  String searchString;
  final TextEditingController _textEditingController = TextEditingController();
  bg.Location location;

  Future<void> getPlacemarks(BuildContext context, String search, String alternative) async {
    await Provider.of<LocationProvider>(context, listen: false).findNearLocationsFromQuery(search, alternative);
  }

  Future<void> getCurrentLocation() async {
    this.location = await bg.BackgroundGeolocation.getCurrentPosition(
      timeout: 3,
      maximumAge: 10000,
      desiredAccuracy: 200,
      samples: 3,
    );
  }

  @override
  void initState() {
    super.initState();

    this.getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    this.placemarks = Provider.of<LocationProvider>(context).marks;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      child: Card(
        child: AnimatedContainer(
          duration: Duration(milliseconds: 400),
          curve: Curves.easeInOut,
          height: (this.searchString != null && this.searchString.length > 2) ? 180 : 52,
          child: Column(
            children: [
              TextField(
                controller: this._textEditingController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.location_on),
                  hintText: AppLocalizations.of(context).searchForLocation,
                  contentPadding: EdgeInsets.all(16.0),
                ),
                onChanged: (search) async {
                  setState(() {
                    searchString = search;
                  });

                  String searchQuery = '';

                  if (this.location != null) {
                    searchQuery = search + " " + location.coords.latitude.toString() + " " + location.coords.longitude.toString();
                  }

                  await getPlacemarks(context, searchQuery, search);
                },
              ),
              if (this.searchString != null && this.searchString.length >= 3 && this.placemarks != [])
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: this.placemarks.length,
                    itemBuilder: (context, index) => ListTile(
                      title: Text(this.placemarks[index].value.name + ", " + this.placemarks[index].key.street),
                      subtitle: Text(this.placemarks[index].key.locality + ", " + this.placemarks[index].key.country),
                      onTap: () {
                        setState(
                          () {
                            LatLng point = LatLng(this.placemarks[index].value.coordinates.latitude, this.placemarks[index].value.coordinates.longitude);
                            this.widget.mapMove(point, 15.0);

                            this.widget.setChoosenLocation(point.latitude, point.longitude, this.placemarks[index].key.country,
                                this.placemarks[index].key.street, placemarks[index].key.locality);

                            this._textEditingController.clear();
                            this.searchString = '';
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
    );
  }
}
