import 'package:flutter/material.dart';
import 'package:productive_app/provider/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Dialogs {
  static void logoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Center(
          child: Text(
            AppLocalizations.of(context).logout,
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
            Text(AppLocalizations.of(context).areYouSureLogout),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (Provider.of<AuthProvider>(context, listen: false).user.userType == 'mail') {
                      Provider.of<AuthProvider>(context, listen: false).logout();
                    } else {
                      Provider.of<AuthProvider>(context, listen: false).googleLogout();
                    }
                    Navigator.of(context).pop(true);
                  },
                  child: Text(AppLocalizations.of(context).yes),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text(AppLocalizations.of(context).no),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  static Future<void> showWarningDialog(BuildContext context, String warningText) async {
    await showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Center(
            child: Text(
              AppLocalizations.of(context).warning,
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
        );
      },
    );
  }

  static Future<bool> showActionDialog(BuildContext context, String text, Future<void> Function() yesAction, Function noAction) async {
    bool choice = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Center(
          child: Text(
            AppLocalizations.of(context).warning,
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
                  onPressed: () async {
                    await yesAction();
                    Navigator.of(context).pop(true);
                  },
                  child: Text(AppLocalizations.of(context).yes),
                ),
                ElevatedButton(
                  onPressed: () {
                    noAction();
                    Navigator.of(context).pop(false);
                  },
                  child: Text(AppLocalizations.of(context).no),
                ),
              ],
            ),
          ],
        ),
      ),
    );
    return choice;
  }

  static Future<bool> showChoiceDialog(BuildContext context, String text) async {
    bool choice = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Center(
          child: Text(
            AppLocalizations.of(context).warning,
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
                  child: Text(AppLocalizations.of(context).yes),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text(AppLocalizations.of(context).no),
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
                  AppLocalizations.of(context).warning,
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
                        child: Text(AppLocalizations.of(context).cancel),
                      ),
                    ],
                  ),
                ],
              ),
            ));
    return choice;
  }
}
