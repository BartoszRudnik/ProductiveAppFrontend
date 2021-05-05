import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../login/models/user.dart';
import '../../login/providers/auth_provider.dart';
import '../../shared/dialogs.dart';
import '../widgets/task_appBar.dart';

class SettingsScreen extends StatefulWidget {
  static const routeName = "/collaborators";

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  User user;

  Future<void> updateUserInfo() async {
    bool hasAgreed = await Dialogs.showChoiceDialog(context, "Are you sure you want to update your account information?");
    if (hasAgreed) {
      //TO DO delete account
      print("Delet account");
    }
  }

  Future<void> deleteUser() async {
    bool hasAgreed = await Dialogs.showChoiceDialog(context, "Are you sure you want to delete your account? This action cannot be undone!");
    if (hasAgreed) {
      //TO DO delete account
      print("Delet account");
    }
  }

  Future<void> resetPassword() async {
    bool hasAgreed = await Dialogs.showChoiceDialog(context, "Are you sure you want to reset your password?");
    if (hasAgreed) {
      //TO DO reset password
      print("Password reset");
    }
  }

  Future<void> removeAvatar() async {
    bool hasAgreed = await Dialogs.showChoiceDialog(context, "Are you sure you want to remove your avatar?");
    if (hasAgreed) {
      //TO DO reset password
      print("Remove avatar");
    }
  }

  Future<void> changeAvatar() async {
    //TO DO reset password
    print("Change avatar");
  }

  @override
  Widget build(BuildContext context) {
    this.user = Provider.of<AuthProvider>(context, listen: false).user;
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
              Row(
                children: [
                  Expanded(
                    flex: 6,
                    child: Container(
                        width: 80,
                        height: 80,
                        child: GestureDetector(
                          onTap: () => changeAvatar(),
                          child: Badge(
                              position: BadgePosition.topEnd(),
                              badgeColor: Theme.of(context).accentColor,
                              badgeContent: Icon(Icons.photo_camera),
                              child: Container(
                                width: 80,
                                height: 80,
                                child: CircleAvatar(
                                  backgroundColor: Theme.of(context).primaryColor,
                                ),
                              )),
                        )),
                  ),
                  Expanded(
                      flex: 15,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.email,
                              style: TextStyle(fontSize: 20),
                            ),
                            GestureDetector(onTap: () => removeAvatar(), child: Text("Remove avatar"))
                          ],
                        ),
                      ))
                ],
              ),
              SizedBox(height: 10),
              ListTile(
                minLeadingWidth: 16,
                contentPadding: EdgeInsets.symmetric(horizontal: 0),
                title: Align(
                  alignment: Alignment(-1.1, 0),
                  child: Text(
                    "ACCOUNT INFORMATION",
                    style: TextStyle(fontSize: 20),
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
                            flex: 14,
                            child: TextFormField(
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
                      ConstrainedBox(
                          constraints: const BoxConstraints(minWidth: double.infinity),
                          child: TextButton(
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                _formKey.currentState.save();
                                updateUserInfo();
                              }
                            },
                            style: ButtonStyle(alignment: Alignment.centerLeft, padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.fromLTRB(0, 0, 0, 0)), overlayColor: MaterialStateProperty.all(Color.fromRGBO(150, 150, 150, 0.3))),
                            child: Text("Save account information", style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 18)),
                          )),
                      ConstrainedBox(
                          constraints: const BoxConstraints(minWidth: double.infinity),
                          child: TextButton(
                            onPressed: () => resetPassword(),
                            style: ButtonStyle(alignment: Alignment.centerLeft, padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.fromLTRB(0, 0, 0, 0)), overlayColor: MaterialStateProperty.all(Color.fromRGBO(150, 150, 150, 0.3))),
                            child: Text("Reset password", style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 18)),
                          )),
                    ],
                  )),
              ListTile(
                minLeadingWidth: 16,
                contentPadding: EdgeInsets.symmetric(horizontal: 0),
                title: Align(
                  alignment: Alignment(-1.1, 0),
                  child: Text(
                    "MANAGE ACCOUNT",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: double.infinity),
                  child: TextButton(
                    onPressed: () => deleteUser(),
                    style: ButtonStyle(alignment: Alignment.centerLeft, padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.fromLTRB(0, 0, 0, 0)), overlayColor: MaterialStateProperty.all(Color.fromRGBO(150, 150, 150, 0.3))),
                    child: Text("Delete account", style: TextStyle(color: Colors.red, fontSize: 18)),
                  ))
            ],
          )),
        )));
  }
}
