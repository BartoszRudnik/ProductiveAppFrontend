import 'package:flutter/material.dart';
import 'package:productive_app/widget/appBar/search_appBar.dart';
import 'package:provider/provider.dart';
import '../provider/delegate_provider.dart';
import '../widget/collaborators_list.dart';
import '../widget/empty_list.dart';
import '../widget/new_collaborator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CollaboratorsScreen extends StatefulWidget {
  static const routeName = "/collaborators";

  @override
  _CollaboratorsScreenState createState() => _CollaboratorsScreenState();
}

class _CollaboratorsScreenState extends State<CollaboratorsScreen> {
  void _addNewCollaboratorForm(BuildContext buildContext) {
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Theme.of(buildContext).primaryColorLight,
      context: buildContext,
      builder: (context) {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: GestureDetector(
              onTap: () {},
              child: NewCollaborator(),
              behavior: HitTestBehavior.opaque,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DelegateProvider>(context);

    return WillPopScope(
      // ignore: missing_return
      onWillPop: () {
        Navigator.of(context).pop();
        Provider.of<DelegateProvider>(context, listen: false).clearSearchingText();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: SearchAppBar(
          title: AppLocalizations.of(context).collaborators,
          searchingName: 'collaborator',
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
              ? EmptyList(message: AppLocalizations.of(context).emptyCollaborator)
              : SingleChildScrollView(
                  physics: ScrollPhysics(),
                  padding: const EdgeInsets.only(left: 21, right: 17, top: 10),
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (provider.accepted.length > 0)
                          CollaboratorsList(
                            collaboratorType: 'accepted',
                            collaborators: provider.accepted,
                            listTitle: AppLocalizations.of(context).acceptedInvitations,
                          ),
                        if (provider.received.length > 0)
                          CollaboratorsList(
                            collaboratorType: 'received',
                            collaborators: provider.received,
                            listTitle: AppLocalizations.of(context).receivedInvitations,
                          ),
                        if (provider.send.length > 0)
                          CollaboratorsList(
                            collaboratorType: 'send',
                            collaborators: provider.send,
                            listTitle: AppLocalizations.of(context).sentInvitations,
                          ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
