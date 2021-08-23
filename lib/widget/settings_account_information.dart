import 'package:flutter/material.dart';
import 'package:productive_app/provider/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsAccountInformation extends StatelessWidget {
  final formKey;
  final Function updateUserInfo;

  SettingsAccountInformation({
    @required this.formKey,
    @required this.updateUserInfo,
  });

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).user;

    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColorLight,
        border: Border.all(
          color: Theme.of(context).primaryColorDark,
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
                  AppLocalizations.of(context).accountInformation,
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
          ),
          Form(
            key: this.formKey,
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
                        AppLocalizations.of(context).firstName,
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    Expanded(
                      flex: 8,
                      child: TextFormField(
                        initialValue: user.firstName,
                        style: TextStyle(fontSize: 18),
                        maxLines: 1,
                        decoration: InputDecoration(hintText: AppLocalizations.of(context).firstName),
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
                        AppLocalizations.of(context).lastName,
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    Expanded(
                      flex: 8,
                      child: TextFormField(
                        initialValue: user.lastName,
                        style: TextStyle(fontSize: 18),
                        maxLines: 1,
                        decoration: InputDecoration(hintText: AppLocalizations.of(context).lastName),
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
                  onPressed: () {
                    if (this.formKey.currentState.validate()) {
                      this.formKey.currentState.save();
                      this.updateUserInfo(user.firstName, user.lastName);
                    }
                  },
                  child: Text(AppLocalizations.of(context).saveAccountInformation),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
