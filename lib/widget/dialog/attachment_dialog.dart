import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AttachmentDialog extends StatefulWidget {
  final List<File> files;

  AttachmentDialog({
    @required this.files,
  });

  @override
  _AttachmentDialogState createState() => _AttachmentDialogState();
}

class _AttachmentDialogState extends State<AttachmentDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        AppLocalizations.of(context).addNewFiles,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 24,
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () async {
            final result = await FilePicker.platform.pickFiles(
              allowMultiple: true,
              allowedExtensions: ['pdf', 'png', 'jpg', 'jpeg', 'doc', 'docx', 'ppt', 'pptx', 'xls', 'xlsx'],
              type: FileType.custom,
            );

            result.files.forEach((file) {
              this.widget.files.add(File(file.path));
            });

            setState(() {});
          },
          child: Text(
            AppLocalizations.of(context).addNewFile,
            textAlign: TextAlign.start,
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(this.widget.files);
          },
          child: Text(
            AppLocalizations.of(context).save,
            textAlign: TextAlign.end,
          ),
        ),
      ],
      content: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.5,
          child: ListView.builder(
            itemCount: this.widget.files.length,
            itemBuilder: (ctx, index) {
              return Container(
                height: 75,
                child: Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Flexible(
                          child: Center(
                            child: Text(
                              basename(this.widget.files[index].path),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.cancel_outlined),
                          onPressed: () {
                            setState(() {
                              this.widget.files.remove(this.widget.files[index]);
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
