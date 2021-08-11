import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/collaborator.dart';
import '../provider/delegate_provider.dart';
import '../screen/collaborator_profile_tabs.dart';
import 'collaborator_list_element.dart';

class AcceptedCollaborator extends StatelessWidget {
  Collaborator collaborator;

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
              'Delete collaborator',
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
                  'Delete',
                  style: Theme.of(context).textTheme.headline3,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Are you sure you want to delete this collaborator?'),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          await Provider.of<DelegateProvider>(context, listen: false).deleteCollaborator(this.collaborator.id);
                          Navigator.of(context).pop(true);
                        },
                        child: Text('Yes'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                        child: Text('No'),
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
