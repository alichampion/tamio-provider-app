import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessageModel {
  String? uid;
  String? senderId;
  String? receiverId;
  String? photoUrl;
  List<String>? attachmentfiles;
  String? messageType;
  bool? isMe;
  bool? isMessageRead;
  String? message;
  int? createdAt;
  Timestamp? createdAtTime;
  Timestamp? updatedAtTime;
  DocumentReference? chatDocumentReference;

  ChatMessageModel(
      {this.uid,
      this.chatDocumentReference,
      this.senderId,
      this.createdAtTime,
      this.updatedAtTime,
      this.receiverId,
      this.createdAt,
      this.message,
      this.isMessageRead,
      this.photoUrl,
      this.attachmentfiles,
      this.messageType});

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      uid: json['uid'],
      senderId: json['senderId'],
      receiverId: json['receiverId'],
      message: json['message'],
      isMessageRead: json['isMessageRead'],
      photoUrl: json['photoUrl'],
      attachmentfiles: json['attachmentfiles'] is List ? List<String>.from(json['attachmentfiles'].map((x) => x)) : [],
      messageType: json['messageType'],
      createdAt: json['createdAt'],
      createdAtTime: json['createdAtTime'],
      updatedAtTime: json['updatedAtTime'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = uid;
    data['createdAt'] = createdAt;
    data['message'] = message;
    data['senderId'] = senderId;
    data['isMessageRead'] = isMessageRead;
    data['receiverId'] = receiverId;
    data['photoUrl'] = photoUrl;
    if (attachmentfiles != null) data['attachmentfiles'] = attachmentfiles?.map((e) => e).toList();
    data['createdAtTime'] = createdAtTime;
    data['updatedAtTime'] = updatedAtTime;
    data['messageType'] = messageType;
    return data;
  }
}
