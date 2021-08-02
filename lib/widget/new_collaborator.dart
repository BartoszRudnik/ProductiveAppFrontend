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
                        style: TextStyle(
                          fontSize: 26,
                          fontFamily: 'RobotoCondensed',
                        ),
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
                              onPressed: () {
                                Navigator.of(context).pop(false);
                                Navigator.of(context).pop();
                              },
                              child: Text('Cancel'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop(true);
                                Navigator.of(context).pop();
                              },
                              child: Text('Send invitation'),
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
