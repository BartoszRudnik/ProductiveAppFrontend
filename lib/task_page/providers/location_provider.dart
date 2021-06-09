import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:latlong/latlong.dart';

import '../models/location.dart' as models;

class LocationProvider with ChangeNotifier {
  List<models.Location> locationList;
  List<MapEntry<geocoding.Placemark, LatLng>> placemarks;

  final String userMail;
  final String authToken;

  String _serverUrl = GlobalConfiguration().getValue("serverUrl");

  LocationProvider({
    @required this.userMail,
    @required this.authToken,
    @required this.locationList,
    @required this.placemarks,
  });

  double getLongitude(int id) {
    return this.locationList.firstWhere((element) => element.id == id).longitude;
  }

  double getLatitude(int id) {
    return this.locationList.firstWhere((element) => element.id == id).latitude;
  }

  List<models.Location> get locations {
    return [...locationList];
  }

  List<MapEntry<geocoding.Placemark, LatLng>> get marks {
    return [...placemarks];
  }

  Future<void> getLocations() async {
    final url = this._serverUrl + "localization/getLocalizations/${this.userMail}";
    final List<models.Location> loadedLocations = [];
    try {
      final response = await http.get(url);
      final responseBody = json.decode(utf8.decode(response.bodyBytes));

      for (var element in responseBody) {
        models.Location loc = models.Location(
          id: element['localizationId'],
          localizationName: element["localizationName"],
          longitude: element["longitude"],
          latitude: element["latitude"],
          country: element["country"],
          locality: element["locality"],
          street: element["street"],
        );
        loadedLocations.add(loc);
      }

      this.locationList = loadedLocations;
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> addLocation(models.Location newLocation) async {
    final url = this._serverUrl + "localization/addLocalization/${this.userMail}";

    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'localizationName': newLocation.localizationName,
            'longitude': newLocation.longitude,
            'latitude': newLocation.latitude,
            'street': newLocation.street,
            'country': newLocation.country,
            'locality': newLocation.locality,
          },
        ),
        headers: {
          'content-type': 'application/json',
          'accept': 'application/json',
        },
      );

      newLocation.id = int.parse(response.body);

      this.locationList.insert(0, newLocation);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateLocation(int id, models.Location location) async {
    final url = this._serverUrl + "localization/updateLocalization/$id";
    try {
      await http.put(
        url,
        body: json.encode({
          'localizationName': location.localizationName,
          'longitude': location.longitude,
          'latitude': location.latitude,
          'street': location.street,
          'locality': location.locality,
          'country': location.country,
        }),
        headers: {
          'content-type': 'application/json',
          'accept': 'application/json',
        },
      );

      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> deleteLocation(int id) async {
    final url = this._serverUrl + "localization/deleteLocalization/$id";
    try {
      await http.delete(url);
      this.locationList.removeWhere((element) => element.id == id);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> findGlobalLocationsFromQuery(String query) async {
    final url = "https://nominatim.openstreetmap.org/search?q=${query}&format=json";
    List<MapEntry<geocoding.Placemark, LatLng>> loadedMarks = [];
    if (query.length >= 3) {
      try {
        final response = await http.get(url);
        final responseBody = json.decode(utf8.decode(response.bodyBytes));

        for (var element in responseBody) {
          models.Location loc = models.Location(
            id: -1,
            localizationName: element["name"],
            longitude: double.parse(element["lon"]),
            latitude: double.parse(element["lat"]),
            country: " ",
            locality: " ",
            street: " ",
          );
          List<geocoding.Placemark> newMarks = await geocoding.placemarkFromCoordinates(loc.latitude, loc.longitude);

          for (var mark in newMarks) {
            LatLng position = LatLng(double.parse(element["lat"]), double.parse(element["lon"]));
            loadedMarks.add(MapEntry(mark, position));
          }
        }
        this.placemarks = loadedMarks;
        notifyListeners();
      } catch (error) {
        print(error);
        throw error;
      }
    }
  }
}
