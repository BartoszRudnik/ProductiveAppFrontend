import 'package:flutter/material.dart';
import 'package:productive_app/model/location.dart';
import 'package:productive_app/provider/location_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FilterLocationDialog extends StatelessWidget {
  final _locationKey = GlobalKey<FormState>();

  final List<int> alreadyChoosenLocations;

  FilterLocationDialog({
    @required this.alreadyChoosenLocations,
  });

  @override
  Widget build(BuildContext context) {
    List<Location> locations = Provider.of<LocationProvider>(context, listen: false).locations;
    List<Location> filteredLocations = List<Location>.from(locations);
    List<int> newLocations = List<int>.from(this.alreadyChoosenLocations);

    filteredLocations.forEach(
      (element) {
        if (this.alreadyChoosenLocations != null && this.alreadyChoosenLocations.contains(element.id)) {
          element.isSelected = true;
        } else {
          element.isSelected = false;
        }
      },
    );

    return StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
          content: Container(
            height: 350,
            width: 350,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  horizontalTitleGap: 6,
                  title: Form(
                    key: this._locationKey,
                    child: TextFormField(
                      onChanged: (value) {
                        setState(() {
                          filteredLocations = locations.where((element) => element.localizationName.toLowerCase().contains(value.toLowerCase())).toList();
                        });
                      },
                      maxLines: null,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10),
                        hintText: AppLocalizations.of(context).findLocation,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.all(10),
                    itemCount: filteredLocations.length,
                    itemBuilder: (ctx, tagIndex) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            filteredLocations[tagIndex].isSelected = !filteredLocations[tagIndex].isSelected;
                            if (newLocations != null && !newLocations.contains(filteredLocations[tagIndex].id) && filteredLocations[tagIndex].isSelected) {
                              newLocations.add(filteredLocations[tagIndex].id);
                            } else if (newLocations != null && !filteredLocations[tagIndex].isSelected) {
                              newLocations.remove(filteredLocations[tagIndex].id);
                            }
                          });
                        },
                        child: Card(
                          color: filteredLocations[tagIndex].isSelected ? Theme.of(context).primaryColor : Theme.of(context).accentColor,
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              filteredLocations[tagIndex].localizationName,
                              style: TextStyle(
                                color: filteredLocations[tagIndex].isSelected ? Theme.of(context).accentColor : Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        filteredLocations.forEach((element) {
                          element.isSelected = false;
                        });
                        Navigator.of(context).pop('cancel');
                      },
                      child: Text(AppLocalizations.of(context).cancel),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        filteredLocations.forEach((element) {
                          element.isSelected = false;
                        });
                        Navigator.of(context).pop(newLocations);
                      },
                      child: Text(AppLocalizations.of(context).save),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
