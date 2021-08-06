import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../provider/auth_provider.dart';
import '../utils/dialogs.dart';
import '../widget/appBar/task_appBar.dart';
import '../widget/settings_account_information.dart';
import '../widget/settings_graphic_settings.dart';
import '../widget/settings_manage_account.dart';
import '../widget/settings_user_avatar.dart';

class SettingsScreen extends StatefulWidget {
  static const routeName = "/collaborators";

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _deleteDialogKey = GlobalKey<FormState>();
  final _resetPasswordKey = GlobalKey<FormState>();
  final _cofirmPasswordKey = GlobalKey<FormFieldState>();

  Future<void> updateUserInfo(String firstName, String lastName) async {
    bool hasAgreed = await Dialogs.showChoiceDialog(context, "Are you sure you want to update your account information?");
    if (hasAgreed) {
      Provider.of<AuthProvider>(context, listen: false).updateUserData(firstName, lastName);
    }
  }

  Future<void> deleteUser() async {
    bool hasAgreed = await Dialogs.showChoiceDialog(context, "Are you sure you want to delete your account? This action cannot be undone!");
    if (hasAgreed) {
      Provider.of<AuthProvider>(context, listen: false).getDeleteToken();
      String enteredToken;

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
                      'Checkout your email for delete token',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Form(
                    key: this._deleteDialogKey,
                    child: TextFormField(
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10),
                        hintText: 'Enter token',
                      ),
                      validator: (value) {
                        if (value.isEmpty || value.length < 6) {
                          return 'Please provide valid token';
                        }
                        return null;
                      },
                      onSaved: (value) async {
                        enteredToken = value;

                        Provider.of<AuthProvider>(context, listen: false).deleteAccount(enteredToken);
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Cancel'),
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
                        child: Text('Delete Account'),
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
    bool hasAgreed = await Dialogs.showChoiceDialog(context, "Are you sure you want to reset your password?");
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
                      'Checkout your email for reset password token',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Form(
                    key: _resetPasswordKey,
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10),
                            hintText: 'Enter reset token',
                          ),
                          validator: (value) {
                            if (value.isEmpty || value.length < 6) {
                              return 'Please provide valid token';
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
                            hintText: 'Enter new password',
                          ),
                          validator: (value) {
                            if (value != this._cofirmPasswordKey.currentState.value) {
                              return 'Passwords must be the same';
                            }
                            if (value.isEmpty || value.length < 7) {
                              return 'Password must be at least 7 characters long';
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
                            hintText: 'Confirm new password',
                          ),
                          validator: (value) {
                            if (value.isEmpty || value.length < 7) {
                              return 'Password must be at least 7 characters long';
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Cancel'),
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
                                    'New password successfuly set',
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
                        child: Text('Reset Password'),
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
    bool hasAgreed = await Dialogs.showChoiceDialog(context, "Are you sure you want to remove your avatar?");
    if (hasAgreed) {
      Provider.of<AuthProvider>(context, listen: false).removeAvatar();
    }
  }

  Future<void> changeAvatar() async {
    String mode = await Dialogs.showImagePickerDialog(context, 'Choose picking mode');

    if (mode != null) {
      final imageSource = mode == 'Camera' ? ImageSource.camera : ImageSource.gallery;

      final picker = ImagePicker();
      final pickedImage = await picker.getImage(
        source: imageSource,
        imageQuality: 20,
      );
      final pickedImageFile = File(pickedImage.path);
      setState(() {
        Provider.of<AuthProvider>(context, listen: false).changeUserImage(pickedImageFile);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).user;

    if (!user.removed) {
      Provider.of<AuthProvider>(context, listen: false).getUserImage();
    }

    return Scaffold(
      appBar: TaskAppBar(
        title: 'Account settings',
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
