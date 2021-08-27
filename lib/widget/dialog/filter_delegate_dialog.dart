import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:productive_app/model/collaborator.dart';
import 'package:productive_app/provider/delegate_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FilterDelegateDialog extends StatelessWidget {
  final _collaboratorKey = GlobalKey<FormState>();

  final List<String> alreadyChoosenCollaborators;
  String _serverUrl = GlobalConfiguration().getValue("serverUrl");

  FilterDelegateDialog({
    @required this.alreadyChoosenCollaborators,
  });

  @override
  Widget build(BuildContext context) {
    List<Collaborator> collaborators = Provider.of<DelegateProvider>(context).collaboratorsList;
    List<Collaborator> filteredCollaborators = List<Collaborator>.from(collaborators);
    List<String> newCollaborators = List<String>.from(this.alreadyChoosenCollaborators);

    filteredCollaborators.forEach(
      (element) {
        if (this.alreadyChoosenCollaborators != null && this.alreadyChoosenCollaborators.contains(element.email)) {
          element.isSelected = true;
        } else {
          element.isSelected = false;
        }
      },
    );

    return StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
          content: Container(
            height: 350,
            width: 350,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  horizontalTitleGap: 6,
                  title: Form(
                    key: this._collaboratorKey,
                    child: TextFormField(
                      onChanged: (value) {
                        setState(() {
                          filteredCollaborators = collaborators.where((element) => element.email.toLowerCase().contains(value.toLowerCase())).toList();
                        });
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return AppLocalizations.of(context).collaboratorEmailNotEmpty;
                        }
                        if (value == Provider.of<DelegateProvider>(context, listen: false).userEmail) {
                          return AppLocalizations.of(context).cannotInviteYourself;
                        }
                        return null;
                      },
                      onSaved: (value) async {
                        final alreadyExists = collaborators.where((element) => element.email == value);
                        if (alreadyExists.isEmpty) {
                          try {
                            await Provider.of<DelegateProvider>(context, listen: false).addCollaborator(value);
                          } catch (error) {
                            return showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Center(
                                  child: Text(
                                    AppLocalizations.of(context).userNotFound,
                                    style: Theme.of(context).textTheme.headline2,
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
                                          },
                                          child: Text(AppLocalizations.of(context).cancel),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.of(context).pop(true);
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
                        }
                      },
                      maxLines: null,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10),
                        hintText: AppLocalizations.of(context).findOrAddCollaborator,
                      ),
                    ),
                  ),
                  trailing: FloatingActionButton(
                    mini: true,
                    child: Icon(
                      Icons.add,
                      color: Theme.of(context).accentColor,
                      size: 30,
                    ),
                    onPressed: () {
                      final isValid = this._collaboratorKey.currentState.validate();
                      if (isValid) {
                        this._collaboratorKey.currentState.save();
                        this._collaboratorKey.currentState.reset();
                        filteredCollaborators = collaborators;
                      }
                    },
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.all(10),
                    itemCount: filteredCollaborators.length,
                    itemBuilder: (ctx, collaboratorIndex) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            filteredCollaborators[collaboratorIndex].isSelected = !filteredCollaborators[collaboratorIndex].isSelected;
                            if (!newCollaborators.contains(filteredCollaborators[collaboratorIndex].email) && filteredCollaborators[collaboratorIndex].isSelected) {
                              newCollaborators.add(filteredCollaborators[collaboratorIndex].email);
                            } else if (!filteredCollaborators[collaboratorIndex].isSelected) {
                              newCollaborators.remove(filteredCollaborators[collaboratorIndex].email);
                            }
                          });
                        },
                        child: Card(
                          color: filteredCollaborators[collaboratorIndex].isSelected ? Theme.of(context).primaryColor : Theme.of(context).accentColor,
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: ListTile(
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(25),
                                child: FadeInImage(
                                  image: NetworkImage(this._serverUrl + 'userImage/getImage/${filteredCollaborators[collaboratorIndex].email}'),
                                  placeholder: AssetImage('assets/images/profile_placeholder.jpg'),
                                ),
                              ),
                              title: Text(
                                filteredCollaborators[collaboratorIndex].collaboratorName.length > 1 ? filteredCollaborators[collaboratorIndex].collaboratorName : filteredCollaborators[collaboratorIndex].email,
                                style: TextStyle(
                                  color: filteredCollaborators[collaboratorIndex].isSelected ? Theme.of(context).accentColor : Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        filteredCollaborators.forEach((element) {
                          element.isSelected = false;
                        });
                        Navigator.of(context).pop('cancel');
                      },
                      child: Text(AppLocalizations.of(context).cancel),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        filteredCollaborators.forEach((element) {
                          element.isSelected = false;
                        });
                        Navigator.of(context).pop(newCollaborators);
                      },
                      child: Text(AppLocalizations.of(context).save),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
