import 'package:flutter/material.dart';
import 'package:productive_app/task_page/models/location.dart';
import 'package:productive_app/task_page/providers/location_provider.dart';
import 'package:provider/provider.dart';

class FilterLocationDialog extends StatelessWidget {
  final _locationKey = GlobalKey<FormState>();

  List<int> choosenLocations = [];

  FilterLocationDialog({
    this.choosenLocations,
  });

  @override
  Widget build(BuildContext context) {
    List<Location> locations = Provider.of<LocationProvider>(context, listen: false).locations;
    List<Location> filteredLocations = List<Location>.from(locations);

    filteredLocations.forEach(
      (element) {
        if (this.choosenLocations != null && this.choosenLocations.contains(element.id)) {
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
                        hintText: 'Find location',
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
                            if (this.choosenLocations != null && !this.choosenLocations.contains(filteredLocations[tagIndex].id) && filteredLocations[tagIndex].isSelected) {
                              this.choosenLocations.add(filteredLocations[tagIndex].id);
                            } else if (this.choosenLocations != null && !filteredLocations[tagIndex].isSelected) {
                              this.choosenLocations.remove(filteredLocations[tagIndex].id);
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
                      style: ElevatedButton.styleFrom(
                        primary: Theme.of(context).primaryColor,
                        side: BorderSide(color: Theme.of(context).primaryColor),
                      ),
                      onPressed: () {
                        filteredLocations.forEach((element) {
                          element.isSelected = false;
                        });
                        Navigator.of(context).pop('cancel');
                      },
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).accentColor,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Theme.of(context).primaryColor,
                        side: BorderSide(color: Theme.of(context).primaryColor),
                      ),
                      onPressed: () {
                        filteredLocations.forEach((element) {
                          element.isSelected = false;
                        });
                        Navigator.of(context).pop(this.choosenLocations);
                      },
                      child: Text(
                        'Save',
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).accentColor,
                        ),
                      ),
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
