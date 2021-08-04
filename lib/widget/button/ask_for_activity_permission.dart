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
            onPressed: () {
              if (this.collaborator.alreadyAsked) {
                return Dialogs.showWarningDialog(context, 'You already asked for permission!');
              } else {
                Provider.of<DelegateProvider>(context, listen: false).askForPermission(this.collaborator.email);
                this.collaborator.alreadyAsked = true;

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Request has been sent',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    backgroundColor: Theme.of(context).primaryColorDark,
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
            child: Text('Ask for permission'),
          ),
        ],
      ),
    );
  }
}
