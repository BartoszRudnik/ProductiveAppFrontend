import 'package:flutter/material.dart';
import 'package:productive_app/task_page/providers/delegate_provider.dart';
import 'package:provider/provider.dart';

class NewCollaborator extends StatelessWidget {
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
            onSaved: (value) {
              Provider.of<DelegateProvider>(context, listen: false).addCollaborator(value);
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
              this._formKey.currentState.save();
              this._formKey.currentState.reset();
            },
            backgroundColor: Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }
}
