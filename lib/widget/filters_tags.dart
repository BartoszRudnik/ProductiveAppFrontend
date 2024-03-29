import 'package:flutter/material.dart';
import 'package:productive_app/provider/settings_provider.dart';
import 'package:productive_app/widget/single_selected_filter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dialog/filter_tags_dialog.dart';

class FiltersTags extends StatelessWidget {
  final tags;

  FiltersTags({
    @required this.tags,
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    Text(
                      AppLocalizations.of(context).tags,
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
                            if (this.tags != null) {
                              return FilterTagsDialog(alreadyChoosenTags: this.tags);
                            } else {
                              return FilterTagsDialog(alreadyChoosenTags: []);
                            }
                          },
                        );

                        if (selected != null && selected.length >= 1) {
                          await Provider.of<SettingsProvider>(context, listen: false).addFilterTags(selected);
                        } else if (selected != 'cancel') {
                          await Provider.of<SettingsProvider>(context, listen: false).clearFilterTags();
                        }
                      },
                      child: Text(
                        AppLocalizations.of(context).chooseTags,
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                  ),
                ],
              ),
              if (this.tags != null && this.tags.length >= 1)
                Container(
                  height: 60,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: this.tags.length,
                    itemBuilder: (context, index) {
                      Future<void> onPressed() async {
                        await Provider.of<SettingsProvider>(context, listen: false).deleteFilterTag(this.tags[index]);
                      }

                      return SingleSelectedFilter(text: this.tags[index], onPressed: onPressed);
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
