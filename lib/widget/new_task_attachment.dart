import 'dart:io';

import 'package:flutter/material.dart';
import 'package:productive_app/widget/dialog/attachment_dialog.dart';

class NewTaskAttachment extends StatelessWidget {
  final Function setAttachments;
  final List<File> files;

  NewTaskAttachment({
    @required this.setAttachments,
    @required this.files,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.attach_file_outlined),
      onPressed: () async {
        final attachments = await showDialog(
            context: context,
            builder: (context) {
              return AttachmentDialog(files: this.files);
            });

        this.setAttachments(attachments);
      },
    );
  }
}
