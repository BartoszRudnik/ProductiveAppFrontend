import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:productive_app/provider/location_provider.dart';
import 'package:provider/provider.dart';

class FindPlace extends StatefulWidget {
  final Function mapMove;
  var choosenLocation;

  FindPlace({
    @required this.mapMove,
    @required this.choosenLocation,
  });

  @override
  _FindPlaceState createState() => _FindPlaceState();
}

class _FindPlaceState extends State<FindPlace> {
  List<MapEntry<Placemark, LatLng>> placemarks = [];
  String searchString;
  final TextEditingController _textEditingController = TextEditingController();

  Future<void> getPlacemarks(BuildContext context, String search) async {
    await Provider.of<LocationProvider>(context, listen: false).findGlobalLocationsFromQuery(search);
    placemarks = Provider.of<LocationProvider>(context, listen: false).marks;
  }

  @override
  Widget build(BuildContext context) {
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
                            this.widget.mapMove(point, 15.0);

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
    );
  }
}
