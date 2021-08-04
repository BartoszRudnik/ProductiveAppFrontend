import 'package:flutter/material.dart';
import 'package:productive_app/provider/auth_provider.dart';
import 'package:provider/provider.dart';

class SettingsManageAccount extends StatelessWidget {
  final Function deleteUser;
  final Function resetPassword;

  SettingsManageAccount({
    @required this.deleteUser,
    @required this.resetPassword,
  });

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).user;

    return Container(
      padding: EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColorLight,
        border: Border.all(
          color: Theme.of(context).primaryColorDark,
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
                onPressed: () {
                  this.resetPassword(user.email);
                },
                child: Text('Reset password'),
              ),
              ElevatedButton(
                onPressed: () {
                  this.deleteUser();
                },
                child: Text('Delete Account'),
              ),
            ],
          )
        ],
      ),
    );
  }
}
