import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:productive_app/widget/single_location.dart';
import 'package:provider/provider.dart';

import '../model/location.dart';
import '../provider/location_provider.dart';
import '../utils/dialogs.dart';
import '../widget/appBar/search_appBar.dart';
import '../widget/dialog/location_dialog.dart';

class LocationsScreen extends StatefulWidget {
  static const routeName = '/locations-screen';

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationsScreen> {
  Future<void> _addNewLocationForm(BuildContext buildContext, Location choosenLocation) async {
    if (choosenLocation != null) {
      String name = await Dialogs.showTextFieldDialog(context, AppLocalizations.of(context).enterLocationName);
      if (name == null || name.isEmpty) {
        return;
      }
      choosenLocation.localizationName = name;

      await Provider.of<LocationProvider>(context, listen: false).addLocation(choosenLocation);
    }
  }

  Future<void> _editLocationForm(BuildContext buildContext, Location locationToEdit) async {
    locationToEdit = await showDialog(
      context: context,
      builder: (context) {
        return LocationDialog(
          choosenLocation: locationToEdit,
        );
      },
    );

    print(locationToEdit == null);

    if (locationToEdit != null) {
      String name =
          await Dialogs.showTextFieldDialogWithInitialValue(context, AppLocalizations.of(context).enterLocationName, locationToEdit.localizationName);
      if (name == null || name.isEmpty) {
        return;
      }
      locationToEdit.localizationName = name;

      await Provider.of<LocationProvider>(context, listen: false).updateLocation(locationToEdit);
    }
  }

  @override
  Widget build(BuildContext context) {
    final locations = Provider.of<LocationProvider>(context).locations;

    return WillPopScope(
      // ignore: missing_return
      onWillPop: () {
        Provider.of<LocationProvider>(context, listen: false).clearSearchingText();
        Navigator.of(context).pop();
      },
      child: Scaffold(
        appBar: SearchAppBar(
          title: AppLocalizations.of(context).locations,
          searchingName: 'location',
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.add,
            color: Colors.white,
            size: 50,
          ),
          onPressed: () async {
            Location choosenLocation = await showDialog(
              context: context,
              builder: (context) {
                return LocationDialog(
                  choosenLocation: Location(
                    uuid: '',
                    id: -1,
                    latitude: 0.0,
                    longitude: 0.0,
                    localizationName: 'test',
                    country: "",
                    locality: "",
                    street: "",
                  ),
                );
              },
            );

            this._addNewLocationForm(context, choosenLocation);
          },
        ),
        body: ListView.builder(
          padding: EdgeInsets.only(left: 21, right: 17, top: 10),
          shrinkWrap: true,
          itemCount: locations.length,
          itemBuilder: (context, index) => SingleLocation(
            location: locations[index],
            editLocationForm: this._editLocationForm,
          ),
        ),
      ),
    );
  }
}
