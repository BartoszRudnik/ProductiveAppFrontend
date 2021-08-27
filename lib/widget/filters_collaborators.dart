import 'package:flutter/material.dart';
import 'package:productive_app/provider/delegate_provider.dart';
import 'package:productive_app/provider/settings_provider.dart';
import 'package:productive_app/widget/dialog/filter_delegate_dialog.dart';
import 'package:productive_app/widget/single_selected_filter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FiltersCollaborators extends StatelessWidget {
  final collaborators;

  FiltersCollaborators({
    @required this.collaborators,
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
                      AppLocalizations.of(context).collaborators,
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
                            if (this.collaborators != null) {
                              return FilterDelegateDialog(
                                alreadyChoosenCollaborators: this.collaborators,
                              );
                            } else {
                              return FilterDelegateDialog(alreadyChoosenCollaborators: []);
                            }
                          },
                        );

                        if (selected != null && selected.length >= 1) {
                          await Provider.of<SettingsProvider>(context, listen: false).addFilterCollaboratorEmail(selected);
                        } else if (selected != 'cancel') {
                          await Provider.of<SettingsProvider>(context, listen: false).clearFilterCollaborators();
                        }
                      },
                      child: Text(
                        AppLocalizations.of(context).chooseCollaborators,
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                  ),
                ],
              ),
              if (this.collaborators != null && this.collaborators.length >= 1)
                Container(
                  height: 60,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: this.collaborators.length,
                    itemBuilder: (context, index) {
                      final collaboratorName = Provider.of<DelegateProvider>(context, listen: false).collaborators.firstWhere((element) => element.email == this.collaborators[index]).collaboratorName;

                      Future<void> onPressed() async {
                        await Provider.of<SettingsProvider>(context, listen: false).deleteFilterCollaboratorEmail(this.collaborators[index]);
                      }

                      return SingleSelectedFilter(
                        text: collaboratorName != null && collaboratorName.length > 1 ? collaboratorName : this.collaborators[index],
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
