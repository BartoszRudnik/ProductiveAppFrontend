import 'package:flutter/material.dart';
import 'package:productive_app/task_page/models/collaborator.dart';
import 'package:productive_app/task_page/providers/delegate_provider.dart';
import 'package:provider/provider.dart';

class DelegateDialog extends StatelessWidget {
  final _collaboratorKey = GlobalKey<FormState>();

  String _choosenCollaborator;

  @override
  Widget build(BuildContext context) {
    List<Collaborator> collaborators = Provider.of<DelegateProvider>(context, listen: false).collaboratorsList;
    List<Collaborator> filteredCollaborators = List<Collaborator>.from(collaborators);

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
                          return 'collaborator email cannot be empty';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        setState(() {
                          final alreadyExists = collaborators.where((element) => element.email == value);
                          if (alreadyExists.isEmpty) {
                            //Provider.of<DelegateProvider>(context, listen: false).addCollaborator(value);
                            collaborators.insert(
                              0,
                              Collaborator(
                                email: value,
                                isSelected: false,
                              ),
                            );
                          }
                        });
                      },
                      maxLines: null,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10),
                        hintText: 'Find or add new collaborator',
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
                            filteredCollaborators.forEach((element) {
                              if (element.isSelected) {
                                element.isSelected = false;
                              }
                            });
                            filteredCollaborators[collaboratorIndex].isSelected = true;
                            this._choosenCollaborator = filteredCollaborators[collaboratorIndex].email;
                          });
                        },
                        child: Card(
                          color: filteredCollaborators[collaboratorIndex].isSelected ? Theme.of(context).primaryColor : Theme.of(context).accentColor,
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              filteredCollaborators[collaboratorIndex].email,
                              style: TextStyle(
                                color: filteredCollaborators[collaboratorIndex].isSelected ? Theme.of(context).accentColor : Theme.of(context).primaryColor,
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
                      style: ElevatedButton.styleFrom(
                        primary: Theme.of(context).primaryColor,
                        side: BorderSide(color: Theme.of(context).primaryColor),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop('');
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
                        Navigator.of(context).pop(this._choosenCollaborator);
                      },
                      child: Text(
                        'Add collaborator',
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
      },
    );
  }
}
