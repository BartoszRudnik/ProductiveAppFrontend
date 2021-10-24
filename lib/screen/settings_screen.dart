import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:productive_app/provider/task_provider.dart';
import 'package:productive_app/widget/settings_data_usage.dart';
import 'package:productive_app/widget/settings_language.dart';
import 'package:productive_app/widget/settings_version.dart';
import 'package:provider/provider.dart';

import '../provider/auth_provider.dart';
import '../utils/dialogs.dart';
import '../widget/appBar/task_appBar.dart';
import '../widget/settings_account_information.dart';
import '../widget/settings_graphic_settings.dart';
import '../widget/settings_manage_account.dart';
import '../widget/settings_user_avatar.dart';

class SettingsScreen extends StatefulWidget {
  static const routeName = "/settings";

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _deleteDialogKey = GlobalKey<FormState>();
  final _resetPasswordKey = GlobalKey<FormState>();
  final _cofirmPasswordKey = GlobalKey<FormFieldState>();

  Future<void> updateUserInfo(String firstName, String lastName) async {
    bool hasAgreed = await Dialogs.showChoiceDialog(context, AppLocalizations.of(context).areYouSureUpdateAccount);
    if (hasAgreed) {
      await Provider.of<AuthProvider>(context, listen: false).updateUserData(firstName, lastName);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(AppLocalizations.of(context).savedData, textAlign: TextAlign.center),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> deleteUser() async {
    bool hasAgreed = await Dialogs.showChoiceDialog(context, AppLocalizations.of(context).areYouSureDeleteAccount);
    if (hasAgreed) {
      Provider.of<AuthProvider>(context, listen: false).getDeleteToken();

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Container(
              width: 350,
              height: 150,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Text(
                      AppLocalizations.of(context).checkEmail,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Form(
                        key: this._deleteDialogKey,
                        child: TextFormField(
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10),
                            hintText: AppLocalizations.of(context).deleteToken,
                          ),
                          validator: (value) {
                            if (value.isEmpty || value.length < 6) {
                              return AppLocalizations.of(context).validToken;
                            }
                            return null;
                          },
                          onSaved: (value) async {
                            final tasksWithLocation = Provider.of<TaskProvider>(context, listen: false).tasksWithLocationId;

                            await Provider.of<AuthProvider>(context, listen: false).deleteAccount(value, tasksWithLocation);
                          },
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(AppLocalizations.of(context).cancel),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          bool isValid = this._deleteDialogKey.currentState.validate();

                          if (isValid) {
                            this._deleteDialogKey.currentState.save();
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          }
                        },
                        child: Text(AppLocalizations.of(context).deleteAccount),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      );
    }
  }

  Future<void> resetPassword(String userMail) async {
    bool hasAgreed = await Dialogs.showChoiceDialog(context, AppLocalizations.of(context).areYouSureResetPassword);
    if (hasAgreed) {
      Provider.of<AuthProvider>(context, listen: false).resetPassword(userMail);

      String enteredToken;
      String newPassword;
      String newPasswordRepeated;

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Container(
              width: 350,
              height: 275,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Text(
                      AppLocalizations.of(context).checkEmail,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Form(
                        key: _resetPasswordKey,
                        child: Column(
                          children: [
                            TextFormField(
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(10),
                                hintText: AppLocalizations.of(context).enterResetToken,
                              ),
                              validator: (value) {
                                if (value.isEmpty || value.length < 6) {
                                  return AppLocalizations.of(context).wrongToken;
                                }
                                return null;
                              },
                              onSaved: (value) async {
                                enteredToken = value;
                              },
                            ),
                            TextFormField(
                              obscureText: true,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(10),
                                hintText: AppLocalizations.of(context).enterNewPassword,
                              ),
                              validator: (value) {
                                if (value != this._cofirmPasswordKey.currentState.value) {
                                  return AppLocalizations.of(context).samePasswords;
                                }
                                if (value.isEmpty || value.length < 7) {
                                  return AppLocalizations.of(context).passwordLength;
                                }
                                return null;
                              },
                              onSaved: (value) async {
                                newPassword = value;
                              },
                            ),
                            TextFormField(
                              obscureText: true,
                              key: this._cofirmPasswordKey,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(10),
                                hintText: AppLocalizations.of(context).repeatPassword,
                              ),
                              validator: (value) {
                                if (value.isEmpty || value.length < 7) {
                                  return AppLocalizations.of(context).passwordLength;
                                }
                                return null;
                              },
                              onSaved: (value) async {
                                newPasswordRepeated = value;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(AppLocalizations.of(context).cancel),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          bool isValid = this._resetPasswordKey.currentState.validate();

                          if (isValid) {
                            this._resetPasswordKey.currentState.save();
                            Provider.of<AuthProvider>(context, listen: false).newPassword(userMail, enteredToken, newPassword);
                            Navigator.of(context).pop();
                            return showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Center(
                                  child: Text(
                                    AppLocalizations.of(context).newPasswordSuccess,
                                    style: Theme.of(context).textTheme.headline2,
                                  ),
                                ),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
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
                        },
                        child: Text(AppLocalizations.of(context).reset),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      );
    }
  }

  Future<void> removeAvatar() async {
    bool hasAgreed = await Dialogs.showChoiceDialog(context, AppLocalizations.of(context).areYouSureRemoveAvatar);
    if (hasAgreed) {
      await Provider.of<AuthProvider>(context, listen: false).removeAvatar();
    }
  }

  Future<void> changeAvatar() async {
    String mode = await Dialogs.showImagePickerDialog(context, AppLocalizations.of(context).pickingMode);

    if (mode != null) {
      final imageSource = mode == 'Camera' ? ImageSource.camera : ImageSource.gallery;

      final picker = ImagePicker();
      final pickedImage = await picker.getImage(
        source: imageSource,
        imageQuality: 20,
      );
      final pickedImageFile = File(pickedImage.path);

      await Provider.of<AuthProvider>(context, listen: false).changeUserImage(pickedImageFile);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TaskAppBar(
        title: AppLocalizations.of(context).accountSettings,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SettingsUserAvatar(removeAvatar: this.removeAvatar, changeAvatar: this.changeAvatar),
                SizedBox(height: 10),
                SettingsAccountInformation(formKey: this._formKey, updateUserInfo: updateUserInfo),
                SizedBox(height: 10),
                SettingsManageAccount(deleteUser: this.deleteUser, resetPassword: this.resetPassword),
                SizedBox(height: 10),
                SettingsGraphicSettings(),
                SizedBox(height: 10),
                SettingsLanguage(),
                SizedBox(height: 10),
                SettingsVersion(),
                SizedBox(height: 10),
                SettingsDataUsage(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
