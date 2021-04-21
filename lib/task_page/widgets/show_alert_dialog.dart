import 'package:flutter/material.dart';

class ShowAlertDialog {
  showAlertDialog(BuildContext context, final errorMessage) {
    Widget acceptButton = ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Theme.of(context).primaryColor,
        side: BorderSide(color: Theme.of(context).primaryColor),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
      child: Text(
        'OK',
        style: TextStyle(fontSize: 14, color: Theme.of(context).accentColor),
      ),
    );

    AlertDialog alert = AlertDialog(
      title: Text(
        'Incorrect task attributes',
        style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Text(errorMessage),
      actions: [
        acceptButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
