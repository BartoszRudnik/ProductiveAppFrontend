import 'package:flutter/material.dart';
import 'package:productive_app/model/collaborator.dart';
import 'package:productive_app/provider/delegate_provider.dart';
import 'package:productive_app/utils/dialogs.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AskForActivityPermission extends StatelessWidget {
  final Collaborator collaborator;

  AskForActivityPermission({
    @required this.collaborator,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(AppLocalizations.of(context).noPermissionCollaborator),
          ElevatedButton(
            onPressed: () {
              if (this.collaborator.alreadyAsked) {
                return Dialogs.showWarningDialog(context, AppLocalizations.of(context).alreadyAsked);
              } else {
                Provider.of<DelegateProvider>(context, listen: false).askForPermission(this.collaborator.email);
                this.collaborator.alreadyAsked = true;

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      AppLocalizations.of(context).requestHasBeenSend,
                      textAlign: TextAlign.center,
                    ),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
            child: Text(AppLocalizations.of(context).askForPermission),
          ),
        ],
      ),
    );
  }
}
