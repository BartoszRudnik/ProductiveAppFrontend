import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CoordinatesAndName {
  LatLng coordinates;
  String name;

  CoordinatesAndName({
    @required this.coordinates,
    @required this.name,
  });
}
