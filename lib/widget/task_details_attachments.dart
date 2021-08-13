import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/attachment.dart';
import '../provider/attachment_provider.dart';
import 'dialog/attachment_dialog.dart';
import 'pdf_viewer.dart';

class TaskDetailsAttachments extends StatelessWidget {
  final List<Attachment> attachments;
  final int taskId;

  TaskDetailsAttachments({
    @required this.attachments,
    @required this.taskId,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          this.attachments.length > 0
              ? Container(
                  alignment: Alignment.centerLeft,
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemCount: this.attachments.length,
                    itemBuilder: (ctx, index) => TextButton(
                      onPressed: () async {
                        final file = await Provider.of<AttachmentProvider>(context, listen: false).loadAttachments(this.attachments[index].id);

                        Navigator.of(context).pushNamed(
                          PDFViewer.routeName,
                          arguments: {
                            'file': file,
                            'fileName': this.attachments[index].fileName,
                          },
                        );
                      },
                      child: Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width * 0.45,
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColorLight,
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Center(
                                child: Text(
                                  this.attachments[index].fileName,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.cancel_outlined, color: Theme.of(context).primaryColor),
                              onPressed: () {
                                Provider.of<AttachmentProvider>(context, listen: false).setToDelete(this.attachments[index].id);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              : Container(),
          Container(
            height: 30,
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 20),
            margin: EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(color: Color.fromRGBO(237, 237, 240, 1), borderRadius: BorderRadius.all(Radius.circular(5))),
            child: TextButton(
              onPressed: () async {
                final newAttachments = await showDialog(
                    context: context,
                    builder: (context) {
                      return AttachmentDialog(files: []);
                    });

                Provider.of<AttachmentProvider>(context, listen: false).setAttachments(newAttachments, taskId, true);
              },
              child: Center(
                child: Text(
                  "Add new attachments",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color.fromRGBO(119, 119, 120, 1),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
