import 'package:flutter/material.dart';
import 'package:productive_app/provider/task_provider.dart';
import 'package:provider/provider.dart';
import '../model/location.dart';
import '../provider/location_provider.dart';
import '../utils/dialogs.dart';
import '../widget/appBar/task_appBar.dart';
import '../widget/dialog/location_dialog.dart';

class LocationsScreen extends StatefulWidget {
  static const routeName = '/locations-screen';

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationsScreen> {
  Future<void> _addNewLocationForm(BuildContext buildContext, Location choosenLocation) async {
    if (choosenLocation != null) {
      String name = await Dialogs.showTextFieldDialog(context, 'Enter location name');
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

    if (locationToEdit != null) {
      String name = await Dialogs.showTextFieldDialogWithInitialValue(context, 'Enter location name', locationToEdit.localizationName);
      if (name == null || name.isEmpty) {
        return;
      }
      locationToEdit.localizationName = name;
      await Provider.of<LocationProvider>(context, listen: false).updateLocation(locationToEdit.id, locationToEdit);
    }
  }

  @override
  Widget build(BuildContext context) {
    final locations = Provider.of<LocationProvider>(context).locationList;

    return Scaffold(
      appBar: TaskAppBar(
        title: "Saved locations",
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
        itemBuilder: (context, index) => Dismissible(
          key: ValueKey(locations[index]),
          background: Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            alignment: Alignment.centerLeft,
            color: Theme.of(context).primaryColor,
            child: Row(
              children: [
                Icon(
                  Icons.edit,
                  color: Theme.of(context).accentColor,
                  size: 50,
                ),
                Text(
                  'Edit location',
                  style: TextStyle(color: Theme.of(context).accentColor, fontSize: 20, fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
          secondaryBackground: Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            alignment: Alignment.centerRight,
            color: Theme.of(context).primaryColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Delete location',
                  style: TextStyle(color: Theme.of(context).accentColor, fontSize: 20, fontWeight: FontWeight.w400),
                ),
                Icon(
                  Icons.delete_outline,
                  color: Theme.of(context).accentColor,
                  size: 40,
                ),
              ],
            ),
          ),
          confirmDismiss: (direction) async {
            if (direction == DismissDirection.endToStart) {
              bool hasAgreed = await Dialogs.showChoiceDialog(context, "Are you sure you want to delete this location?");
              if (hasAgreed) {
                Provider.of<TaskProvider>(context, listen: false).clearLocationFromTasks(locations[index].id);
                Provider.of<LocationProvider>(context, listen: false).deleteLocation(locations[index].id);
              }
            }
            if (direction == DismissDirection.startToEnd) {
              this._editLocationForm(context, locations[index]);
            }
            return false;
          },
          child: Card(
            child: ListTile(
              title: Text(
                locations[index].localizationName,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
              ),
              subtitle: locations[index].locality.length <= 1 && locations[index].street.length <= 1
                  ? Text(
                      locations[index].latitude.toStringAsFixed(3) + ", " + locations[index].longitude.toStringAsFixed(3),
                    )
                  : Text(
                      locations[index].locality + ", " + locations[index].street + ", " + locations[index].country,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
