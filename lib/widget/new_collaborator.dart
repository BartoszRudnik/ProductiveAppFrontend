import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:productive_app/provider/delegate_provider.dart';
import 'package:productive_app/utils/dialogs.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NewCollaborator extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _NewCollaboratorState();
}

class _NewCollaboratorState extends State<NewCollaborator> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Form(
        key: this._formKey,
        child: ListTile(
          title: TextFormField(
            autofocus: true,
            key: ValueKey('CollaboratorName'),
            validator: (value) {
              if (value.isEmpty) {
                return AppLocalizations.of(context).collaboratorEmailNotEmpty;
              }
              if (value == Provider.of<DelegateProvider>(context, listen: false).userEmail) {
                return AppLocalizations.of(context).cannotInviteYourself;
              }
              if (Provider.of<DelegateProvider>(context, listen: false).checkIfCollaboratorAlreadyExist(value)) {
                return AppLocalizations.of(context).collaboratorAlreadyExist;
              }
              return null;
            },
            onSaved: (value) async {
              try {
                final connection = await Connectivity().checkConnectivity();

                if (connection != ConnectivityResult.none) {
                  await Provider.of<DelegateProvider>(context, listen: false).addCollaborator(value);
                } else {
                  Dialogs.showWarningDialog(context, AppLocalizations.of(context).connectionFailed);
                }
              } catch (error) {
                return showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Center(
                      child: Text(
                        AppLocalizations.of(context).userNotFound,
                        style: TextStyle(
                          fontSize: 26,
                          fontFamily: 'RobotoCondensed',
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(AppLocalizations.of(context).doYouWantSendInvitation),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop(false);
                                Navigator.of(context).pop();
                              },
                              child: Text(AppLocalizations.of(context).cancel),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop(true);
                                Navigator.of(context).pop();
                              },
                              child: Text(AppLocalizations.of(context).sendInvitation),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }
            },
            maxLines: null,
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context).enterCollaboratorEmail,
              hintStyle: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 20,
              ),
            ),
          ),
          trailing: FloatingActionButton(
            mini: true,
            child: Icon(
              Icons.add,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () {
              bool isValid = this._formKey.currentState.validate();

              if (isValid) {
                this._formKey.currentState.save();
                this._formKey.currentState.reset();
              }
            },
          ),
        ),
      ),
    );
  }
}
