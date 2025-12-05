import '../../models/attachment_model.dart';
import '../../models/bank_list_response.dart';

class HelpDeskDetailResponse {
  Pagination? pagination;
  String? status;
  List<HelpDeskActivityData>? data;

  HelpDeskDetailResponse({this.pagination, this.data, this.status});

  factory HelpDeskDetailResponse.fromJson(Map<String, dynamic> json) {
    return HelpDeskDetailResponse(
      data: json['activity'] != null ? (json['activity'] as List).map((i) => HelpDeskActivityData.fromJson(i)).toList() : null,
      pagination: json['pagination'] != null ? Pagination.fromJson(json['pagination']) : null,
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.data != null) {
      data['activity'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (pagination != null) {
      data['pagination'] = pagination!.toJson();
    }
    data['status'] = status;
    return data;
  }
}

class HelpDeskActivityData {
  int? id;
  int? helpdeskId;
  int? senderId;
  String? senderName;
  String? senderImage;
  int? receiverId;
  String? recevierName;
  String? recevierImage;
  String? messages;
  String? activityType;
  String? createdAt;
  String? updatedAt;
  List<String>? attachments;
  List<Attachments>? attachmentsArray;
  List<String>? helDeskAttachments;
  List<Attachments>? helpDeskAttachmentsArray;

  HelpDeskActivityData({
    this.id,
    this.helpdeskId,
    this.senderId,
    this.senderName,
    this.senderImage,
    this.receiverId,
    this.recevierName,
    this.recevierImage,
    this.messages,
    this.activityType,
    this.createdAt,
    this.updatedAt,
    this.attachments,
    this.attachmentsArray,
    this.helDeskAttachments,
    this.helpDeskAttachmentsArray,
  });

  factory HelpDeskActivityData.fromJson(Map<String, dynamic> json) {
    return HelpDeskActivityData(
      id: json['id'],
      helpdeskId: json['helpdesk_id'],
      senderId: json['sender_id'],
      senderName: json['sender_name'],
      senderImage: json['sender_image'],
      receiverId: json['receiver_id'],
      recevierName: json['recevier_name'],
      recevierImage: json['recevier_image'],
      messages: json['messages'],
      activityType: json['activity_type'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      attachments: json['attachments'] != null ? List<String>.from(json['attachments']) : null,
      attachmentsArray: json['attachments_array'] != null ? (json['attachments_array'] as List).map((i) => Attachments.fromJson(i)).toList() : null,
      helDeskAttachments: json['helpdesk_attachments'] != null ? List<String>.from(json['helpdesk_attachments']) : null,
      helpDeskAttachmentsArray: json['helpdesk_attachments_array'] != null ? (json['helpdesk_attachments_array'] as List).map((i) => Attachments.fromJson(i)).toList() : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['helpdesk_id'] = helpdeskId;
    data['sender_id'] = senderId;
    data['sender_name'] = senderName;
    data['sender_image'] = senderImage;
    data['receiver_id'] = receiverId;
    data['recevier_name'] = recevierName;
    data['recevier_image'] = recevierImage;
    data['messages'] = messages;
    data['activity_type'] = activityType;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (attachments != null) {
      data['attachments'] = attachments;
    }
    if (attachmentsArray != null) {
      data['attachments_array'] = attachmentsArray!.map((v) => v.toJson()).toList();
    }
    if (helDeskAttachments != null) {
      data['helpdesk_attachments'] = helDeskAttachments;
    }
    if (helpDeskAttachmentsArray != null) {
      data['helpdesk_attachments_array'] = helpDeskAttachmentsArray!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
