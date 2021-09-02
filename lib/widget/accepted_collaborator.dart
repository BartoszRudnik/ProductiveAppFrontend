import 'package:flutter/material.dart';
import 'package:productive_app/provider/location_provider.dart';
import 'package:productive_app/provider/synchronize_provider.dart';
import 'package:productive_app/provider/task_provider.dart';
import 'package:provider/provider.dart';
import '../model/collaborator.dart';
import '../provider/delegate_provider.dart';
import '../screen/collaborator_profile_tabs.dart';
import 'collaborator_list_element.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AcceptedCollaborator extends StatelessWidget {
  final Collaborator collaborator;

  AcceptedCollaborator({
    @required this.collaborator,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(collaborator),
      background: Container(),
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
      // ignore: missing_return
      confirmDismiss: (direction) {
        if (direction == DismissDirection.endToStart) {
          return showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Center(
                child: Text(
                  AppLocalizations.of(context).delete,
                  style: Theme.of(context).textTheme.headline3,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(AppLocalizations.of(context).areYouSureDeleteCollab),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          final locations = Provider.of<LocationProvider>(context, listen: false).locationList;
                          Provider.of<TaskProvider>(context, listen: false).deleteCollaboratorFromTasks(this.collaborator.email, locations);
                          Provider.of<TaskProvider>(context, listen: false).deleteReceivedFromCollaborator(this.collaborator.email, locations);
                          Navigator.of(context).pop(true);
                          Provider.of<SynchronizeProvider>(context, listen: false).addCollaboratorToDelete(collaborator.email);
                          await Provider.of<DelegateProvider>(context, listen: false).deleteCollaborator(this.collaborator.id);
                        },
                        child: Text(AppLocalizations.of(context).yes),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                        child: Text(AppLocalizations.of(context).no),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        }
      },
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed(CollaboratorProfileTabs.routeName, arguments: this.collaborator);
        },
        child: CollaboratorListElement(collaborator: this.collaborator),
      ),
    );
  }
}
