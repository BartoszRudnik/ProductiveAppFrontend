import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:productive_app/provider/attachment_provider.dart';
import 'package:productive_app/provider/location_provider.dart';
import 'package:productive_app/provider/synchronize_provider.dart';
import 'package:productive_app/provider/task_provider.dart';
import 'package:provider/provider.dart';

import '../model/collaborator.dart';
import '../provider/delegate_provider.dart';
import 'collaborator_list_element.dart';

class ReceivedCollaborator extends StatelessWidget {
  final Collaborator collaborator;

  ReceivedCollaborator({
    @required this.collaborator,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(collaborator),
      background: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        alignment: Alignment.centerRight,
        color: Theme.of(context).primaryColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              Icons.done_outline,
              color: Theme.of(context).accentColor,
              size: 40,
            ),
            Text(
              AppLocalizations.of(context).acceptInvitation,
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
              AppLocalizations.of(context).declineInvitation,
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
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          return showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Center(
                child: Text(
                  AppLocalizations.of(context).declineInvitation,
                  style: Theme.of(context).textTheme.headline3,
                  textAlign: TextAlign.center,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(AppLocalizations.of(context).areYouSureDeclineInvitation, textAlign: TextAlign.center),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          final locations = Provider.of<LocationProvider>(context, listen: false).locationList;
                          Provider.of<TaskProvider>(context, listen: false).deleteCollaboratorFromTasks(this.collaborator.email, locations);
                          Provider.of<TaskProvider>(context, listen: false).deleteReceivedFromCollaborator(this.collaborator.email, locations);

                          Provider.of<SynchronizeProvider>(context, listen: false).addCollaboratorToDelete(collaborator.uuid);
                          Provider.of<DelegateProvider>(context, listen: false).declineInvitation(this.collaborator.uuid);
                          Navigator.of(context).pop(true);
                        },
                        child: Text(
                          AppLocalizations.of(context).yes,
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).accentColor,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                        child: Text(
                          AppLocalizations.of(context).no,
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).accentColor,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        } else {
          await Provider.of<TaskProvider>(context, listen: false).getTasksFromCollaborator(this.collaborator.email);
          await Provider.of<DelegateProvider>(context, listen: false).acceptInvitation(this.collaborator.uuid);
        }
      },
      child: CollaboratorListElement(
        collaborator: this.collaborator,
      ),
    );
  }
}
