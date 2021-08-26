import 'package:flutter/material.dart';

import 'dialog/delegate_dialog.dart';

class TaskDelegate extends StatelessWidget {
  final Function setDelegatedEmail;
  String collaboratorEmail;

  TaskDelegate({
    @required this.setDelegatedEmail,
    this.collaboratorEmail,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.person_add_alt_1_outlined,
      ),
      onPressed: () async {
        collaboratorEmail = await showDialog(
          context: context,
          builder: (context) {
            if (this.collaboratorEmail == null) {
              return DelegateDialog();
            } else {
              return DelegateDialog(
                choosenMail: this.collaboratorEmail,
              );
            }
          },
        );
        this.setDelegatedEmail(collaboratorEmail);
      },
    );
  }
}
