import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:open_file/open_file.dart';
import 'package:productive_app/provider/synchronize_provider.dart';
import 'package:productive_app/utils/file_type_helper.dart';
import 'package:productive_app/widget/image_viewer.dart';
import 'package:provider/provider.dart';

import '../model/attachment.dart';
import '../provider/attachment_provider.dart';
import 'dialog/attachment_dialog.dart';
import 'pdf_viewer.dart';

class TaskDetailsAttachments extends StatelessWidget {
  final String taskUuid;
  final String parentUuid;

  TaskDetailsAttachments({
    @required this.taskUuid,
    @required this.parentUuid,
  });

  @override
  Widget build(BuildContext context) {
    List<Attachment> attachments =
        Provider.of<AttachmentProvider>(context).attachments.where((attachment) => attachment.taskUuid == taskUuid && !attachment.toDelete).toList();

    attachments.addAll(
      Provider.of<AttachmentProvider>(context).attachments.where((attachment) => attachment.taskUuid == parentUuid && !attachment.toDelete).toList(),
    );

    return Column(
      children: [
        ListTile(
          minLeadingWidth: 16,
          contentPadding: EdgeInsets.symmetric(horizontal: 0),
          leading: Icon(Icons.attach_file_outlined),
          title: Align(
            alignment: Alignment(-1.1, 0),
            child: Text(
              AppLocalizations.of(context).attachments,
              style: TextStyle(fontSize: 21),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              attachments.length > 0
                  ? Card(
                      elevation: 2,
                      child: Container(
                        alignment: Alignment.centerLeft,
                        height: 50,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          itemCount: attachments.length,
                          itemBuilder: (ctx, index) => TextButton(
                            onPressed: () async {
                              final file = await Provider.of<AttachmentProvider>(context, listen: false).loadAttachment(attachments[index].uuid);

                              if (FileTypeHelper.isImage(file.path) || FileTypeHelper.isPDF(file.path)) {
                                String routeName = '';

                                if (FileTypeHelper.isImage(file.path)) {
                                  routeName = ImageViewer.routeName;
                                }
                                if (FileTypeHelper.isPDF(file.path)) {
                                  routeName = PDFViewer.routeName;
                                }

                                Navigator.of(context).pushNamed(
                                  routeName,
                                  arguments: {
                                    'file': file,
                                    'fileName': attachments[index].fileName,
                                  },
                                );
                              } else {
                                OpenFile.open(file.path);
                              }
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
                                        attachments[index].fileName,
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
                                      Provider.of<SynchronizeProvider>(context, listen: false).addAttachmentToDelete(attachments[index].uuid);
                                      Provider.of<AttachmentProvider>(context, listen: false).setToDelete(attachments[index].uuid);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  : Container(),
              Card(
                elevation: 2,
                child: Container(
                  height: 30,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(color: Color.fromRGBO(237, 237, 240, 1), borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: TextButton(
                    onPressed: () async {
                      final newAttachments = await showDialog(
                          context: context,
                          builder: (context) {
                            return AttachmentDialog(files: []);
                          });

                      Provider.of<AttachmentProvider>(context, listen: false).setAttachments(newAttachments, this.taskUuid, true);
                    },
                    child: Center(
                      child: Text(
                        AppLocalizations.of(context).addAttachment,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color.fromRGBO(119, 119, 120, 1),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
