import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:global_configuration/global_configuration.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:productive_app/db/location_database.dart';
import 'package:productive_app/model/coordinates_and_name.dart';
import 'package:productive_app/utils/internet_connection.dart';
import 'package:uuid/uuid.dart';

import '../model/location.dart' as models;

class LocationProvider with ChangeNotifier {
  List<models.Location> locationList;
  List<MapEntry<geocoding.Placemark, CoordinatesAndName>> placemarks;

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

  List<models.Location> get allLocations {
    return this.locationList.toList();
  }

  List<models.Location> get locations {
    if (this.searchingText == null || this.searchingText.length < 1) {
      return this.locationList.where((element) => element.saved).toList();
    } else {
      return this.locationList.where((element) => element.saved && element.localizationName.toLowerCase().contains(this.searchingText.toLowerCase())).toList();
    }
  }

  double getLongitude(String uuid) {
    final location = this.locationList.firstWhere((element) => element.uuid == uuid, orElse: () => null);

    if (location != null) {
      return location.longitude;
    } else {
      return null;
    }
  }

  double getLatitude(String uuid) {
    final location = this.locationList.firstWhere((element) => element.uuid == uuid, orElse: () => null);

    if (location != null) {
      return location.latitude;
    } else {
      return null;
    }
  }

  String getLocationName(String uuid) {
    return this.locationList.firstWhere((element) => element.uuid == uuid).localizationName;
  }

  List<MapEntry<geocoding.Placemark, CoordinatesAndName>> get marks {
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

  void notify() {
    notifyListeners();
  }

  Future<void> getLocationsOffline() async {
    try {
      this.locationList = await LocationDatabase.readAll(this.userMail);
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  Future<void> getLocations() async {
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
          saved: element['saved'],
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
              'saved': newLocation.saved,
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
            'saved': location.saved,
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

  Future<void> editLocationName(String locationUuid, String newName, bool saved) async {
    final location = this.locationList.firstWhere((element) => element.uuid == locationUuid);

    location.localizationName = newName;
    location.saved = saved;

    await LocationDatabase.update(location, this.userMail);

    notifyListeners();

    if (await InternetConnection.internetConnection()) {
      final url = this._serverUrl + "localization/editName/$locationUuid";

      try {
        await http.put(
          url,
          body: json.encode(
            {
              'uuid': location.uuid,
              'localizationName': location.localizationName,
              'saved': location.saved,
            },
          ),
          headers: {
            'content-type': 'application/json',
            'accept': 'application/json',
          },
        );
      } catch (error) {
        print(error);
        throw (error);
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

      List<MapEntry<geocoding.Placemark, CoordinatesAndName>> loadedMarks = [];

      if (query.length >= 3) {
        try {
          var response = await http.get(url);
          var responseBody = json.decode(utf8.decode(response.bodyBytes));

          int len = responseBody.length > 5 ? 5 : responseBody.length;

          for (int i = 0; i < len; i++) {
            List<geocoding.Placemark> newMarks =
                await geocoding.placemarkFromCoordinates(double.parse(responseBody[i]["lat"]), double.parse(responseBody[i]["lon"]));

            int secondLen = newMarks.length > 5 ? 5 : newMarks.length;

            for (int j = 0; j < secondLen; j++) {
              LatLng position = LatLng(double.parse(responseBody[i]["lat"]), double.parse(responseBody[i]["lon"]));

              CoordinatesAndName coordinatesAndName =
                  CoordinatesAndName(coordinates: position, name: (responseBody[i]['display_name'] as String).split(',')[0]);

              loadedMarks.add(MapEntry(newMarks[j], coordinatesAndName));
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

  Future<void> findNearLocationsFromQuery(String query, String alternativeQuery) async {
    if (await InternetConnection.internetConnection()) {
      final url = "https://nominatim.openstreetmap.org/search?q=$query&format=json";

      List<MapEntry<geocoding.Placemark, CoordinatesAndName>> loadedMarks = [];

      if (alternativeQuery.length >= 3) {
        try {
          var response = await http.get(url);
          var responseBody = json.decode(utf8.decode(response.bodyBytes));

          if (responseBody.length == 0) {
            this.findGlobalLocationsFromQuery(alternativeQuery);
          } else {
            int len = responseBody.length > 5 ? 5 : responseBody.length;

            for (int i = 0; i < len; i++) {
              List<geocoding.Placemark> newMarks =
                  await geocoding.placemarkFromCoordinates(double.parse(responseBody[i]["lat"]), double.parse(responseBody[i]["lon"]));

              int secondLen = newMarks.length > 5 ? 5 : newMarks.length;

              for (int j = 0; j < secondLen; j++) {
                LatLng position = LatLng(double.parse(responseBody[i]["lat"]), double.parse(responseBody[i]["lon"]));

                CoordinatesAndName coordinatesAndName =
                    CoordinatesAndName(coordinates: position, name: (responseBody[i]['display_name'] as String).split(',')[0]);

                loadedMarks.add(MapEntry(newMarks[j], coordinatesAndName));
              }
            }

            this.placemarks = loadedMarks;
            notifyListeners();
          }
        } catch (error) {
          print(error);
          throw error;
        }
      }
    }
  }
}
