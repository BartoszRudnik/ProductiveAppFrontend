import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:productive_app/utils/collaborator_show_modal.dart';

class SingleCollaboratorTask extends StatelessWidget {
  final task;

  SingleCollaboratorTask({
    @required this.task,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        return CollaboratorModal.onTaskPressed(this.task, context);
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                this.task.title,
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
              ),
              Row(
                children: [
                  Icon(Icons.update_outlined),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    DateFormat('yMMMMd').format(this.task.lastUpdated) + ' ' + DateFormat('Hm').format(this.task.lastUpdated),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
