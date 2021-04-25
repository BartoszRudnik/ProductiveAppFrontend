import 'package:flutter/material.dart';

import 'delegate_dialog.dart';

class TaskDelegate extends StatelessWidget {
  Function setDelegatedEmail;

  TaskDelegate({
    @required this.setDelegatedEmail,
  });

  String collaboratorEmail;

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
            return DelegateDialog();
          },
        );
        this.setDelegatedEmail(collaboratorEmail);
      },
    );
  }
}
