import 'package:flutter/material.dart';
import 'package:productive_app/task_page/models/collaborator.dart';
import 'package:productive_app/task_page/providers/delegate_provider.dart';
import 'package:provider/provider.dart';

class FilterDelegateDialog extends StatelessWidget {
  final _collaboratorKey = GlobalKey<FormState>();

  List<String> choosenCollaborators = [];

  FilterDelegateDialog({
    this.choosenCollaborators,
  });

  @override
  Widget build(BuildContext context) {
    List<Collaborator> collaborators = Provider.of<DelegateProvider>(context).collaboratorsList;
    List<Collaborator> filteredCollaborators = List<Collaborator>.from(collaborators);

    filteredCollaborators.forEach(
      (element) {
        if (this.choosenCollaborators != null && this.choosenCollaborators.contains(element.email)) {
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
                          return 'collaborator email cannot be empty';
                        }
                        if (value == Provider.of<DelegateProvider>(context, listen: false).userEmail) {
                          return 'Cannot invite yourself';
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
                                    'User not found',
                                    style: Theme.of(context).textTheme.headline2,
                                  ),
                                ),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text('User with given email doesn\'t exists, do you want to send invitation?'),
                                    SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            primary: Theme.of(context).primaryColor,
                                            side: BorderSide(color: Theme.of(context).primaryColor),
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).pop(false);
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
                                            Navigator.of(context).pop(true);
                                          },
                                          child: Text(
                                            'Send invitation',
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
                        }
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
                            filteredCollaborators[collaboratorIndex].isSelected = !filteredCollaborators[collaboratorIndex].isSelected;
                            this.choosenCollaborators.add(filteredCollaborators[collaboratorIndex].email);
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
                        filteredCollaborators.forEach((element) {
                          element.isSelected = false;
                        });
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
                        filteredCollaborators.forEach((element) {
                          element.isSelected = false;
                        });
                        Navigator.of(context).pop(this.choosenCollaborators);
                      },
                      child: Text(
                        'Save',
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
