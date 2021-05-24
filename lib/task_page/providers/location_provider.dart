import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;

import '../models/location.dart';

class LocationProvider with ChangeNotifier{
  List<Location> locationList;

  final String userMail;
  final String authToken;

  String _serverUrl = GlobalConfiguration().getValue("serverUrl");

  LocationProvider({
    @required this.userMail,
    @required this.authToken,
    @required this.locationList,
  });

  List<Location> get locations{
    return [...locationList];
  }

  Future<void> getLocations() async{
    final url = this._serverUrl + "localization/getLocalizations/${this.userMail}";
    final List<Location> loadedLocations = [];
    try{
      final response = await http.get(url);
      final responseBody = json.decode(utf8.decode(response.bodyBytes));

      for(var element in responseBody){
        Location loc = Location(
          localizationName: element["localizationName"], 
          longitude: element["longitude"], 
          latitude: element["latitude"]
        );
        loadedLocations.add(loc);
      }

      Location loc1 = Location(localizationName: "Home", longitude: 67.45678, latitude: 65.87987);
      loc1.id = 0;
      Location loc2 = Location(localizationName: "Work", longitude: 36.55724662299002, latitude: 139.91113082943244);
      loc2.id = 1;
      loadedLocations.add(loc1);
      loadedLocations.add(loc2);
      this.locationList = loadedLocations;
      notifyListeners();
    }catch(error){
      print(error);
      throw error;
    }
  }

  Future<void> addLocation(Location newLocation) async{
    final url = this._serverUrl + "localization//addLocalization/${this.userMail}";

    try{
      await http.post(
        url,
        body: json.encode(
          {
            'addLocalization': newLocation.toJson()
          },
        ),
        headers: {
          'content-type': 'application/json',
          'accept': 'application/json',
        },
      );

      this.locationList.insert(0, newLocation);
      notifyListeners();
    }catch(error){
      print(error);
      throw error;
    }
  }

  Future<void> updateLocation(int id, Location location) async{
    final url = this._serverUrl + "localization/updateLocalization/$id";
    try{
      await http.put(url,
        body: json.encode({
          'addLocalization': location.toJson(),
        }),
        headers: {
          'content-type': 'application/json',
          'accept': 'application/json',
        },
      );

      notifyListeners();
    }catch(error){
      print(error);
      throw error;
    }
  }

  Future<void> deleteLocation(int id) async{
    final url = this._serverUrl + "localization/deleteLocalization/$id";
    try{
      await http.delete(url);
      this.locationList.removeWhere((element) => element.id == id);
      notifyListeners();
    }catch(error){
      print(error);
      throw error;
    }
  }
}