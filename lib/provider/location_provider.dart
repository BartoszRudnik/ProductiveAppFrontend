import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:global_configuration/global_configuration.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:productive_app/db/location_database.dart';
import 'package:productive_app/utils/internet_connection.dart';
import 'package:uuid/uuid.dart';

import '../model/location.dart' as models;

class LocationProvider with ChangeNotifier {
  List<models.Location> locationList;
  List<MapEntry<geocoding.Placemark, LatLng>> placemarks;

  final String userMail;
  final String authToken;

  String _serverUrl = GlobalConfiguration().getValue("serverUrl");

  String searchingText;

  LocationProvider({
    @required this.userMail,
    @required this.authToken,
    @required this.locationList,
    @required this.placemarks,
  });

  void setLocations(List<models.Location> listToSet) {
    this.locationList = listToSet;

    notifyListeners();
  }

  List<models.Location> get locations {
    if (this.searchingText == null || this.searchingText.length < 1) {
      return [...this.locationList];
    } else {
      return this.locationList.where((element) => element.localizationName.toLowerCase().contains(this.searchingText.toLowerCase())).toList();
    }
  }

  double getLongitude(int id) {
    final location = this.locationList.firstWhere((element) => element.id == id, orElse: () => null);

    if (location != null) {
      return location.longitude;
    } else {
      return null;
    }
  }

  double getLatitude(int id) {
    final location = this.locationList.firstWhere((element) => element.id == id, orElse: () => null);

    if (location != null) {
      return location.latitude;
    } else {
      return null;
    }
  }

  String getLocationName(int id) {
    return this.locationList.firstWhere((element) => element.id == id).localizationName;
  }

  List<MapEntry<geocoding.Placemark, LatLng>> get marks {
    return [...placemarks];
  }

  void setSearchingText(String text) {
    this.searchingText = text;

    notifyListeners();
  }

  void clearSearchingText() {
    this.searchingText = '';

    notifyListeners();
  }

  Future<void> getLocations() async {
    if (await InternetConnection.internetConnection()) {
      final url = this._serverUrl + "localization/getLocalizations/${this.userMail}";
      final List<models.Location> loadedLocations = [];

      await LocationDatabase.deleteAll(this.userMail);

      try {
        final response = await http.get(url);
        final responseBody = json.decode(utf8.decode(response.bodyBytes));

        for (var element in responseBody) {
          models.Location loc = models.Location(
            uuid: element['uuid'],
            id: element['id'],
            localizationName: element["localizationName"],
            longitude: element["longitude"],
            latitude: element["latitude"],
            country: element["country"],
            locality: element["locality"],
            street: element["street"],
          );

          loadedLocations.add(loc);
          await LocationDatabase.create(loc, this.userMail);
        }

        this.locationList = loadedLocations;
        notifyListeners();
      } catch (error) {
        print(error);
        throw error;
      }
    } else {
      try {
        this.locationList = await LocationDatabase.readAll(this.userMail);
        notifyListeners();
      } catch (error) {
        print(error);
        throw (error);
      }
    }
  }

  Future<void> addLocation(models.Location newLocation) async {
    final url = this._serverUrl + "localization/addLocalization/${this.userMail}";

    final uuid = Uuid();

    newLocation.uuid = uuid.v1();
    newLocation.id = null;
    newLocation = await LocationDatabase.create(newLocation, this.userMail);

    this.locationList.insert(0, newLocation);

    notifyListeners();

    if (await InternetConnection.internetConnection()) {
      try {
        await http.post(
          url,
          body: json.encode(
            {
              'uuid': newLocation.uuid,
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
      } catch (error) {
        print(error);
        throw error;
      }
    }
  }

  Future<void> updateLocation(models.Location location) async {
    final url = this._serverUrl + "localization/updateLocalization/${location.uuid}";

    await LocationDatabase.update(location, this.userMail);
    notifyListeners();

    if (await InternetConnection.internetConnection()) {
      try {
        await http.put(
          url,
          body: json.encode({
            'uuid': location.uuid,
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
      } catch (error) {
        print(error);
        throw error;
      }
    }
  }

  Future<void> deleteLocation(String uuid) async {
    final url = this._serverUrl + "localization/deleteLocalization/$uuid";

    this.locationList.removeWhere((element) => element.uuid == uuid);
    await LocationDatabase.deleteByUuid(uuid);

    notifyListeners();

    if (await InternetConnection.internetConnection()) {
      try {
        await http.delete(url);
      } catch (error) {
        print(error);
        throw error;
      }
    }
  }

  Future<void> findGlobalLocationsFromQuery(String query) async {
    if (await InternetConnection.internetConnection()) {
      final url = "https://nominatim.openstreetmap.org/search?q=$query&format=json";
      List<MapEntry<geocoding.Placemark, LatLng>> loadedMarks = [];

      if (query.length >= 3) {
        try {
          final response = await http.get(url);
          final responseBody = json.decode(utf8.decode(response.bodyBytes));

          for (var element in responseBody) {
            models.Location loc = models.Location(
              uuid: '',
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
}
