import 'package:flutter/material.dart';
import 'package:productive_app/model/collaborator.dart';
import 'package:productive_app/provider/delegate_provider.dart';
import 'package:productive_app/utils/dialogs.dart';
import 'package:provider/provider.dart';

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
          Text('You don\'t have permission to see collaborator acitivity!'),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Theme.of(context).primaryColor,
              side: BorderSide(color: Theme.of(context).primaryColor),
            ),
            onPressed: () {
              if (this.collaborator.alreadyAsked) {
                return Dialogs.showWarningDialog(context, 'You already asked for permission!');
              } else {
                Provider.of<DelegateProvider>(context, listen: false).askForPermission(this.collaborator.email);
                this.collaborator.alreadyAsked = true;
              }
            },
            child: Text(
              'Ask for permission',
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).accentColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
