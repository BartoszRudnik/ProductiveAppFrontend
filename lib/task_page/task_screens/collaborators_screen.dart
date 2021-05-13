import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/collaborator.dart';
import '../providers/delegate_provider.dart';
import '../widgets/accepted_collaborator.dart';
import '../widgets/new_collaborator.dart';
import '../widgets/received_collaborator.dart';
import '../widgets/send_collaborator.dart';
import '../widgets/task_appBar.dart';

class CollaboratorsScreen extends StatefulWidget {
  static const routeName = "/collaborators";

  @override
  _CollaboratorsScreenState createState() => _CollaboratorsScreenState();
}

class _CollaboratorsScreenState extends State<CollaboratorsScreen> {
  void _addNewCollaboratorForm(BuildContext buildContext) {
    showModalBottomSheet(
      backgroundColor: Theme.of(context).accentColor,
      context: buildContext,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: NewCollaborator(),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DelegateProvider>(context);

    List<Collaborator> acceptedCollaborators = provider.accepted;
    List<Collaborator> receivedCollaborators = provider.received;
    List<Collaborator> sendCollaborators = provider.send;

    return Scaffold(
      appBar: TaskAppBar(
        title: 'Collaborators',
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Theme.of(context).accentColor,
          size: 50,
        ),
        onPressed: () {
          this._addNewCollaboratorForm(context);
        },
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: RefreshIndicator(
        backgroundColor: Theme.of(context).primaryColor,
        onRefresh: () => Provider.of<DelegateProvider>(context, listen: false).getCollaborators(),
        child: acceptedCollaborators.length == 0 && receivedCollaborators.length == 0 && sendCollaborators.length == 0
            ? SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  child: Center(
                    child: Text('Your collaborator list is empty'),
                  ),
                ),
              )
            : SingleChildScrollView(
                physics: ScrollPhysics(),
                padding: const EdgeInsets.only(left: 21, right: 17, top: 10),
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      if (acceptedCollaborators.length > 0)
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Accepted invitations',
                              style: TextStyle(
                                fontSize: 27,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Divider(
                              thickness: 1.5,
                              color: Theme.of(context).primaryColor,
                            ),
                            ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: acceptedCollaborators.length,
                              itemBuilder: (ctx, index) => AcceptedCollaborator(collaborator: acceptedCollaborators[index]),
                            ),
                          ],
                        ),
                      if (receivedCollaborators.length > 0)
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Received invitations',
                              style: TextStyle(
                                fontSize: 27,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Divider(
                              thickness: 1.5,
                              color: Theme.of(context).primaryColor,
                            ),
                            ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: receivedCollaborators.length,
                              itemBuilder: (ctx, index) => ReceivedCollaborator(collaborator: receivedCollaborators[index]),
                            ),
                          ],
                        ),
                      if (sendCollaborators.length > 0)
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Sent invitations',
                              style: TextStyle(
                                fontSize: 27,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Divider(
                              thickness: 1.5,
                              color: Theme.of(context).primaryColor,
                            ),
                            ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: sendCollaborators.length,
                              itemBuilder: (ctx, index) => SendCollaborator(collaborator: sendCollaborators[index]),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
