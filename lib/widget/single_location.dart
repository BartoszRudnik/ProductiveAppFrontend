import 'package:flutter/material.dart';
import 'package:productive_app/db/location_database.dart';
import '../provider/location_provider.dart';
import '../provider/task_provider.dart';
import '../utils/dialogs.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SingleLocation extends StatelessWidget {
  final location;
  final Function editLocationForm;

  SingleLocation({
    @required this.location,
    @required this.editLocationForm,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(location),
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
              AppLocalizations.of(context).edit,
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
              AppLocalizations.of(context).delete,
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
          bool hasAgreed = await Dialogs.showChoiceDialog(context, AppLocalizations.of(context).areSureDeleteLocation);
          if (hasAgreed) {
            LocationDatabase.delete(location.id);
            Provider.of<TaskProvider>(context, listen: false).clearLocationFromTasks(location.id);
            Provider.of<LocationProvider>(context, listen: false).deleteLocation(location.id);
          }
        }
        if (direction == DismissDirection.startToEnd) {
          this.editLocationForm(context, location);
        }
        return false;
      },
      child: Card(
        child: ListTile(
          title: Text(
            location.localizationName,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          ),
          subtitle: location.locality.length <= 1 && location.street.length <= 1
              ? Text(
                  location.latitude.toStringAsFixed(3) + ", " + location.longitude.toStringAsFixed(3),
                )
              : Text(
                  location.locality + ", " + location.street + ", " + location.country,
                ),
        ),
      ),
    );
  }
}
