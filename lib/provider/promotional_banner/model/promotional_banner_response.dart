import '../../../models/attachment_model.dart';
import '../../../models/bank_list_response.dart';

class PromotionalBannerResponse {
  bool? status;
  String? message;
  Pagination? pagination;
  List<PromotionalBannerListData>? data;

  PromotionalBannerResponse({this.status, this.message, this.pagination, this.data});

  factory PromotionalBannerResponse.fromJson(Map<String, dynamic> json) {
    return PromotionalBannerResponse(
      status: json['status'],
      message: json['message'],
      data: json["data"] != null ? (json['data'] as List).map((i) => PromotionalBannerListData.fromJson(i)).toList() : null,
      pagination: json['pagination'] != null ? Pagination.fromJson(json['pagination']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (pagination != null) {
      data['pagination'] = pagination!.toJson();
    }
    return data;
  }
}

class PromotionalBannerListData {
  int? id;
  int? providerId;
  String? title;
  String? image;
  String? description;
  String? bannerType;
  String? bannerRedirectUrl;
  int? serviceId;
  String? serviceName;
  String? startDate;
  String? endDate;
  int? duration;
  String? charges;
  String? totalAmount;
  String? paymentStatus;
  String? paymentMethod;
  String? status;
  String? reason;
  List<Attachments>? attachments;

  PromotionalBannerListData({
    this.id,
    this.providerId,
    this.title,
    this.image,
    this.description,
    this.bannerType,
    this.bannerRedirectUrl,
    this.serviceId,
    this.serviceName,
    this.startDate,
    this.endDate,
    this.duration,
    this.charges,
    this.totalAmount,
    this.paymentStatus,
    this.status,
    this.reason,
  });

  PromotionalBannerListData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    providerId = json['provider_id'];
    title = json['title'];
    image = json['image'];
    description = json['description'];
    bannerType = json['banner_type'];
    bannerRedirectUrl = json['banner_redirect_url'];
    serviceId = json['service_id'];
    serviceName = json['service_name'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    duration = json['duration'];
    charges = json['charges'];
    totalAmount = json['total_amount'];
    paymentStatus = json['payment_status'];
    status = json['status'];
    reason = json['reason'];
    attachments = json['attachments'] != null ? (json['attachments'] as List).map((i) => Attachments.fromJson(i)).toList() : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['provider_id'] = providerId;
    data['title'] = title;
    data['image'] = image;
    data['description'] = description;
    data['banner_type'] = bannerType;
    data['banner_redirect_url'] = bannerRedirectUrl;
    data['service_id'] = serviceId;
    data['service_name'] = serviceName;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['duration'] = duration;
    data['charges'] = charges;
    data['total_amount'] = totalAmount;
    data['payment_status'] = paymentStatus;
    data['status'] = status;
    data['reason'] = reason;
    if (attachments != null) {
      data['attachments'] = attachments!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
