import 'package:flutter/material.dart';
import 'package:productive_app/provider/auth_provider.dart';
import 'package:provider/provider.dart';

class Dialogs {
  static void logoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Center(
          child: Text(
            'Log out',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Are you sure you want to log out?'),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Provider.of<AuthProvider>(context, listen: false).logout();
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

  static void showWarningDialog(BuildContext context, String warningText) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Center(
          child: Text(
            'Warning',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(warningText),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Text('OK'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static Future<bool> showChoiceDialog(BuildContext context, String text) async {
    bool choice = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Center(
          child: Text(
            'Warning',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(child: Text(text)),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
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
            ),
          ],
        ),
      ),
    );
    return choice;
  }

  static Future<String> showTextFieldDialog(BuildContext context, String title) async {
    final _tKey = GlobalKey<FormState>();

    String fieldValue = await showDialog(
        context: context,
        builder: (context) {
          final TextEditingController _textEditingController = TextEditingController();
          String tempVal;
          return AlertDialog(
            title: Center(
              child: Text(
                title,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Form(
                  key: _tKey,
                  child: TextFormField(
                    controller: _textEditingController,
                    decoration: InputDecoration(hintText: "Enter name", contentPadding: EdgeInsets.all(16.0)),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter name of the location';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      tempVal = value;
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    final isValid = _tKey.currentState.validate();
                    if (isValid) {
                      _tKey.currentState.save();
                      _tKey.currentState.reset();
                      Navigator.of(context).pop(tempVal);
                    }
                  },
                  child: Text('OK'),
                ),
              ],
            ),
          );
        });
    return fieldValue;
  }

  static Future<String> showTextFieldDialogWithInitialValue(BuildContext context, String title, String initialValue) async {
    final _tKey = GlobalKey<FormState>();

    String fieldValue = await showDialog(
        context: context,
        builder: (context) {
          String tempVal;
          return AlertDialog(
            title: Center(
              child: Text(
                title,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Form(
                  key: _tKey,
                  child: TextFormField(
                    initialValue: initialValue,
                    decoration: InputDecoration(hintText: "Enter name", contentPadding: EdgeInsets.all(16.0)),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter name of the location';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      tempVal = value;
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    final isValid = _tKey.currentState.validate();
                    if (isValid) {
                      _tKey.currentState.save();
                      _tKey.currentState.reset();
                      Navigator.of(context).pop(tempVal);
                    }
                  },
                  child: Text('OK'),
                ),
              ],
            ),
          );
        });
    return fieldValue;
  }

  static Future<String> showImagePickerDialog(BuildContext context, String text) async {
    String choice = await showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
              title: Center(
                child: Text(
                  'Warning',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(child: Text(text)),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop('Camera');
                        },
                        child: Text('Camera'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop('Gallery');
                        },
                        child: Text('Gallery'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop(null);
                        },
                        child: Text('Cancel'),
                      ),
                    ],
                  ),
                ],
              ),
            ));
    return choice;
  }
}
