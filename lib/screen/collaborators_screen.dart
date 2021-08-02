import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/delegate_provider.dart';
import '../widget/accepted_collaborator.dart';
import '../widget/appBar/task_appBar.dart';
import '../widget/empty_list.dart';
import '../widget/new_collaborator.dart';
import '../widget/received_collaborator.dart';
import '../widget/send_collaborator.dart';

class CollaboratorsScreen extends StatefulWidget {
  static const routeName = "/collaborators";

  @override
  _CollaboratorsScreenState createState() => _CollaboratorsScreenState();
}

class _CollaboratorsScreenState extends State<CollaboratorsScreen> {
  void _addNewCollaboratorForm(BuildContext buildContext) {
    showModalBottomSheet(
      backgroundColor: Theme.of(context).primaryColorLight,
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

    return Scaffold(
      appBar: TaskAppBar(
        title: 'Collaborators',
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: 50,
        ),
        onPressed: () {
          this._addNewCollaboratorForm(context);
        },
      ),
      body: RefreshIndicator(
        backgroundColor: Theme.of(context).primaryColor,
        onRefresh: () => Provider.of<DelegateProvider>(context, listen: false).getCollaborators(),
        child: provider.accepted.length == 0 && provider.received.length == 0 && provider.send.length == 0
            ? EmptyList(message: 'Your collaborator list is empty')
            : SingleChildScrollView(
                physics: ScrollPhysics(),
                padding: const EdgeInsets.only(left: 21, right: 17, top: 10),
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      if (provider.accepted.length > 0)
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
                              itemCount: provider.accepted.length,
                              itemBuilder: (ctx, index) => AcceptedCollaborator(collaborator: provider.accepted[index]),
                            ),
                          ],
                        ),
                      if (provider.received.length > 0)
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
                              itemCount: provider.received.length,
                              itemBuilder: (ctx, index) => ReceivedCollaborator(collaborator: provider.received[index]),
                            ),
                          ],
                        ),
                      if (provider.send.length > 0)
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
                              itemCount: provider.send.length,
                              itemBuilder: (ctx, index) => SendCollaborator(collaborator: provider.send[index]),
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
