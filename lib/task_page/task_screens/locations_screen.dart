import 'package:flutter/material.dart';
import 'package:productive_app/shared/dialogs.dart';
import 'package:productive_app/task_page/models/location.dart';
import 'package:productive_app/task_page/providers/location_provider.dart';
import 'package:productive_app/task_page/widgets/location_dialog.dart';
import 'package:productive_app/task_page/widgets/task_appBar.dart';
import 'package:provider/provider.dart';

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

  void _editLocationForm(BuildContext buildContext) {
    print("edit");
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
          color: Theme.of(context).accentColor,
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
        backgroundColor: Theme.of(context).primaryColor,
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
                Provider.of<LocationProvider>(context, listen: false).deleteLocation(locations[index].id);
              }
            }
            if (direction == DismissDirection.startToEnd) {
              this._editLocationForm(context);
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
