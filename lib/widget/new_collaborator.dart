import 'package:flutter/material.dart';
import 'package:productive_app/provider/delegate_provider.dart';
import 'package:provider/provider.dart';

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
                return 'Collaborator name cannot be empty';
              }
              if (value == Provider.of<DelegateProvider>(context, listen: false).userEmail) {
                return 'Cannot invite yourself';
              }
              return null;
            },
            onSaved: (value) async {
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
                                Navigator.of(context).pop(true);
                                Navigator.of(context).pop();
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
            },
            maxLines: null,
            decoration: InputDecoration(
              hintText: 'Enter collaborator email',
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
              color: Theme.of(context).accentColor,
              size: 30,
            ),
            onPressed: () {
              bool isValid = this._formKey.currentState.validate();

              if (isValid) {
                this._formKey.currentState.save();
                this._formKey.currentState.reset();
              }
            },
            backgroundColor: Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }
}
