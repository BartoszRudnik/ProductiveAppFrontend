import 'package:flutter/material.dart';

class Dialogs {
  static void showWarningDialog(BuildContext context, String warningText) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Center(
                child: Text(
                  'Warning',
                  style: Theme.of(context).textTheme.headline2,
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
                        style: ElevatedButton.styleFrom(
                          primary: Theme.of(context).primaryColor,
                          side: BorderSide(color: Theme.of(context).primaryColor),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                        child: Text(
                          'OK',
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).accentColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ));
  }

  static Future<bool> showChoiceDialog(BuildContext context, String text) async {
    bool choice = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
              title: Center(
                child: Text(
                  'Warning',
                  style: Theme.of(context).textTheme.headline2,
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
                        style: ElevatedButton.styleFrom(
                          primary: Theme.of(context).primaryColor,
                          side: BorderSide(color: Theme.of(context).primaryColor),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                        child: Text(
                          'Yes',
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).accentColor,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Theme.of(context).primaryColor,
                          side: BorderSide(color: Theme.of(context).primaryColor),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                        child: Text(
                          'No',
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).accentColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ));
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
                style: Theme.of(context).textTheme.headline2,
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
                  style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).primaryColor,
                    side: BorderSide(color: Theme.of(context).primaryColor),
                  ),
                  onPressed: () {
                    final isValid = _tKey.currentState.validate();
                    if (isValid) {
                      _tKey.currentState.save();
                      _tKey.currentState.reset();
                      Navigator.of(context).pop(tempVal);
                    }
                  },
                  child: Text(
                    'OK',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
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
                style: Theme.of(context).textTheme.headline2,
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
                  style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).primaryColor,
                    side: BorderSide(color: Theme.of(context).primaryColor),
                  ),
                  onPressed: () {
                    final isValid = _tKey.currentState.validate();
                    if (isValid) {
                      _tKey.currentState.save();
                      _tKey.currentState.reset();
                      Navigator.of(context).pop(tempVal);
                    }
                  },
                  child: Text(
                    'OK',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
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
                  style: Theme.of(context).textTheme.headline2,
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
                        style: ElevatedButton.styleFrom(
                          primary: Theme.of(context).primaryColor,
                          side: BorderSide(color: Theme.of(context).primaryColor),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop('Camera');
                        },
                        child: Text(
                          'Camera',
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).accentColor,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Theme.of(context).primaryColor,
                          side: BorderSide(color: Theme.of(context).primaryColor),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop('Gallery');
                        },
                        child: Text(
                          'Gallery',
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).accentColor,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Theme.of(context).primaryColor,
                          side: BorderSide(color: Theme.of(context).primaryColor),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop(null);
                        },
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).accentColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ));
    return choice;
  }
}
