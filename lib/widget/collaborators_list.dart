import 'package:flutter/material.dart';
import 'accepted_collaborator.dart';
import 'received_collaborator.dart';
import 'send_collaborator.dart';

class CollaboratorsList extends StatelessWidget {
  final String collaboratorType;
  final String listTitle;
  final collaborators;

  CollaboratorsList({
    @required this.collaboratorType,
    @required this.collaborators,
    @required this.listTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          this.listTitle,
          style: TextStyle(
            fontSize: 27,
            fontWeight: FontWeight.w400,
          ),
        ),
        Divider(
          thickness: 1.5,
          color: Theme.of(context).primaryColor,
        ),
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: this.collaborators.length,
          itemBuilder: (ctx, index) {
            if (this.collaboratorType == 'accepted') {
              return AcceptedCollaborator(collaborator: this.collaborators[index]);
            } else if (this.collaboratorType == 'received') {
              return ReceivedCollaborator(collaborator: this.collaborators[index]);
            } else {
              return SendCollaborator(collaborator: this.collaborators[index]);
            }
          },
        ),
      ],
    );
  }
}
