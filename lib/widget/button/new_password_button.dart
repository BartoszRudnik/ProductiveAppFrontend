import 'package:flutter/material.dart';

class NewPasswordButton extends StatelessWidget {
  final Function setNewPassword;

  NewPasswordButton({
    @required this.setNewPassword,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 304,
      height: 47,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Theme.of(context).primaryColor,
          side: BorderSide(color: Theme.of(context).primaryColor),
        ),
        onPressed: this.setNewPassword,
        child: Text(
          'Submit',
          style: TextStyle(
            fontSize: 25,
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
    );
  }
}
