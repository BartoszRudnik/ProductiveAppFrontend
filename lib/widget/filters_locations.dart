import 'package:flutter/material.dart';
import 'package:productive_app/provider/location_provider.dart';
import 'package:productive_app/provider/settings_provider.dart';
import 'package:productive_app/widget/dialog/filter_location_dialog.dart';
import 'package:productive_app/widget/single_selected_filter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FiltersLocations extends StatelessWidget {
  final List<String> locations;

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
                      AppLocalizations.of(context).locations,
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
                      onPressed: () async {
                        final selected = await showDialog(
                          context: context,
                          builder: (context) {
                            if (this.locations != null) {
                              return FilterLocationDialog(alreadyChoosenLocations: this.locations);
                            } else {
                              return FilterLocationDialog(alreadyChoosenLocations: []);
                            }
                          },
                        );

                        if (selected != null && selected.length >= 1 && selected != 'cancel') {
                          await Provider.of<SettingsProvider>(context, listen: false).addFilterLocations(selected);
                        } else if (selected != 'cancel') {
                          await Provider.of<SettingsProvider>(context, listen: false).clearFilterLocations();
                        }
                      },
                      child: Text(
                        AppLocalizations.of(context).chooseLocations,
                        style: TextStyle(fontSize: 24),
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
                    itemBuilder: (context, index) {
                      Future<void> onPressed() async {
                        await Provider.of<SettingsProvider>(context, listen: false).deleteFilterLocation(this.locations[index]);
                      }

                      return SingleSelectedFilter(
                        text: Provider.of<LocationProvider>(context, listen: false).getLocationName(this.locations[index]),
                        onPressed: onPressed,
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
