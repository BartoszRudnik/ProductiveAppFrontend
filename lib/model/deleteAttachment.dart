import 'package:flutter/cupertino.dart';

class DeleteAttachment {
  int attachmentId;
  String fileName;

  DeleteAttachment({
    @required this.attachmentId,
    @required this.fileName,
  });

  Map<String, dynamic> toJson(){
    return{
      "attachmentId": this.attachmentId,
      "fileName": this.fileName,
    };
  }
}
