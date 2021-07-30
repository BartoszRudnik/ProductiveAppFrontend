import 'dart:io';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:productive_app/config/images.dart';
import 'package:provider/provider.dart';

import '../provider/auth_provider.dart';
import '../utils/dialogs.dart';
import '../widget/appBar/task_appBar.dart';

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
                        style: ElevatedButton.styleFrom(
                          primary: Theme.of(context).primaryColor,
                          side: BorderSide(color: Theme.of(context).primaryColor),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'Cancel',
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
                          bool isValid = this._deleteDialogKey.currentState.validate();

                          if (isValid) {
                            this._deleteDialogKey.currentState.save();
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          }
                        },
                        child: Text(
                          'Delete Account',
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).accentColor,
                          ),
                        ),
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
                        style: ElevatedButton.styleFrom(
                          primary: Theme.of(context).primaryColor,
                          side: BorderSide(color: Theme.of(context).primaryColor),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'Cancel',
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
                                          style: ElevatedButton.styleFrom(
                                            primary: Theme.of(context).primaryColor,
                                            side: BorderSide(color: Theme.of(context).primaryColor),
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).pop();
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
                              ),
                            );
                          }
                        },
                        child: Text(
                          'Reset Password',
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).accentColor,
                          ),
                        ),
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
    Provider.of<AuthProvider>(context, listen: false).getUserData();
    Provider.of<AuthProvider>(context, listen: false).checkIfAvatarExists();
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
                Container(
                  padding: EdgeInsets.only(top: 10, left: 6, bottom: 6),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(237, 237, 240, 1),
                    border: Border.all(
                      color: Color.fromRGBO(221, 221, 226, 1),
                      width: 2.5,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        child: GestureDetector(
                          onTap: () => changeAvatar(),
                          child: Badge(
                            position: BadgePosition.topEnd(),
                            badgeColor: Theme.of(context).accentColor,
                            badgeContent: Icon(Icons.photo_camera),
                            child: !user.removed
                                ? Container(
                                    width: 100,
                                    height: 100,
                                    child: CircleAvatar(
                                      radius: 50,
                                      backgroundImage: user.userImage != null ? user.userImage : null,
                                    ),
                                  )
                                : Container(
                                    width: 100,
                                    height: 100,
                                    child: CircleAvatar(
                                      radius: 50,
                                      backgroundImage: AssetImage(Images.profilePicturePlacholder),
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      Flexible(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15.0),
                              child: Text(
                                user.email,
                                style: TextStyle(fontSize: 20),
                                maxLines: 2,
                                softWrap: true,
                                overflow: TextOverflow.clip,
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 5,
                                primary: Color.fromRGBO(201, 201, 206, 1),
                                side: BorderSide(
                                  color: Colors.grey.withOpacity(0.8),
                                ),
                              ),
                              onPressed: () {
                                this.removeAvatar();
                              },
                              child: Text(
                                'Remove avatar',
                                style: TextStyle(fontSize: 14, color: Theme.of(context).primaryColor),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(237, 237, 240, 1),
                    border: Border.all(
                      color: Color.fromRGBO(221, 221, 226, 1),
                      width: 2.5,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ListTile(
                        minLeadingWidth: 16,
                        contentPadding: EdgeInsets.symmetric(horizontal: 0),
                        title: Align(
                          alignment: Alignment(-1.1, 0),
                          child: Center(
                            child: Text(
                              "ACCOUNT INFORMATION",
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                      ),
                      Form(
                        key: this._formKey,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  flex: 4,
                                  child: Text(
                                    "E-mail:",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                                Expanded(
                                  flex: 8,
                                  child: TextFormField(
                                    enabled: false,
                                    initialValue: user.email,
                                    style: TextStyle(fontSize: 18),
                                    maxLines: 1,
                                    onSaved: (value) {
                                      user.email = value;
                                    },
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Email cannot be empty';
                                      }
                                      return null;
                                    },
                                  ),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 4,
                                  child: Text(
                                    "First name:",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                                Expanded(
                                  flex: 8,
                                  child: TextFormField(
                                    initialValue: user.firstName,
                                    style: TextStyle(fontSize: 18),
                                    maxLines: 1,
                                    decoration: InputDecoration(hintText: "First name"),
                                    onSaved: (value) {
                                      user.firstName = value;
                                    },
                                  ),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 4,
                                  child: Text(
                                    "Last name:",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                                Expanded(
                                  flex: 8,
                                  child: TextFormField(
                                    initialValue: user.lastName,
                                    style: TextStyle(fontSize: 18),
                                    maxLines: 1,
                                    decoration: InputDecoration(hintText: "Last name"),
                                    onSaved: (value) {
                                      user.lastName = value;
                                    },
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 5,
                                primary: Color.fromRGBO(201, 201, 206, 1),
                                side: BorderSide(
                                  color: Colors.grey.withOpacity(0.8),
                                ),
                              ),
                              onPressed: () {
                                if (this._formKey.currentState.validate()) {
                                  this._formKey.currentState.save();
                                  this.updateUserInfo(user.firstName, user.lastName);
                                }
                              },
                              child: Text(
                                'Save account information',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.only(bottom: 4),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(237, 237, 240, 1),
                    border: Border.all(
                      color: Color.fromRGBO(221, 221, 226, 1),
                      width: 2.5,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ListTile(
                        minLeadingWidth: 16,
                        contentPadding: EdgeInsets.symmetric(horizontal: 0),
                        title: Align(
                          alignment: Alignment(-1.1, 0),
                          child: Center(
                            child: Text(
                              "MANAGE ACCOUNT",
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 5,
                              primary: Color.fromRGBO(201, 201, 206, 1),
                              side: BorderSide(
                                color: Colors.grey.withOpacity(0.8),
                              ),
                            ),
                            onPressed: () {
                              this.resetPassword(user.email);
                            },
                            child: Text(
                              'Reset password',
                              style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 5,
                              primary: Color.fromRGBO(201, 201, 206, 1),
                              side: BorderSide(
                                color: Colors.grey.withOpacity(0.8),
                              ),
                            ),
                            onPressed: () {
                              this.deleteUser();
                            },
                            child: Text(
                              'Delete Account',
                              style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}