import 'package:flutter/material.dart';
import 'package:productive_app/provider/location_provider.dart';
import 'package:productive_app/provider/settings_provider.dart';
import 'package:productive_app/widget/dialog/filter_location_dialog.dart';
import 'package:provider/provider.dart';

class FiltersLocations extends StatelessWidget {
  final locations;

  FiltersLocations({
    @required this.locations,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Card(
        elevation: 8,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    Text(
                      'Locations',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w400,
                      ),
                    )
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(4),
                        primary: Theme.of(context).primaryColorLight,
                        side: BorderSide(color: Theme.of(context).primaryColorDark),
                      ),
                      onPressed: () async {
                        final selected = await showDialog(
                          context: context,
                          builder: (context) {
                            if (this.locations != null) {
                              return FilterLocationDialog(
                                choosenLocations: this.locations,
                              );
                            } else {
                              return FilterLocationDialog();
                            }
                          },
                        );

                        if (selected != null && selected.length >= 1) {
                          await Provider.of<SettingsProvider>(context, listen: false).addFilterLocations(selected);
                        } else if (selected != 'cancel') {
                          await Provider.of<SettingsProvider>(context, listen: false).clearFilterLocations();
                        }
                      },
                      child: Text(
                        'Choose locations',
                        style: TextStyle(
                          fontSize: 24,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              if (this.locations != null && this.locations.length >= 1)
                Container(
                  height: 60,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: this.locations.length,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(horizontal: 4),
                        margin: EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 16.0),
                              child: Text(
                                Provider.of<LocationProvider>(context, listen: false).getLocationName(this.locations[index]),
                                style: TextStyle(
                                  color: Theme.of(context).accentColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.cancel_outlined, color: Theme.of(context).accentColor),
                              onPressed: () {
                                Provider.of<SettingsProvider>(context, listen: false).deleteFilterLocation(this.locations[index]);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
