import 'dart:convert';

import 'package:handyman_provider_flutter/main.dart';
import 'package:handyman_provider_flutter/models/attachment_model.dart';
import 'package:handyman_provider_flutter/models/booking_list_response.dart';
import 'package:handyman_provider_flutter/models/service_model.dart';
import 'package:handyman_provider_flutter/models/tax_list_response.dart';
import 'package:handyman_provider_flutter/models/user_data.dart';
import 'package:nb_utils/nb_utils.dart';

import '../provider/jobRequest/models/post_job_data.dart';
import 'multi_language_request_model.dart';
import 'shop_model.dart';

class BookingDetailResponse {
  BookingData? bookingDetail;
  ServiceData? service;
  UserData? customer;
  List<BookingActivity>? bookingActivity;
  List<RatingData>? ratingData;
  UserData? providerData;
  List<UserData>? handymanData;
  CouponData? couponData;
  List<TaxData>? taxes;
  List<ServiceProof>? serviceProof;
  PostJobData? postRequestDetail;
  ShopModel? shop;

  bool get isBookedAtShop => shop != null;

  bool get isMe => handymanData.validate().isNotEmpty ? handymanData.validate().first.id.validate() == appStore.userId.validate() : false;

  BookingDetailResponse({
    this.bookingDetail,
    this.service,
    this.customer,
    this.bookingActivity,
    this.ratingData,
    this.providerData,
    this.handymanData,
    this.couponData,
    this.taxes,
    this.serviceProof,
    this.postRequestDetail,
    this.shop,
  });

  BookingDetailResponse.fromJson(Map<String, dynamic> json) {
    bookingDetail = json['booking_detail'] != null ? BookingData.fromJson(json['booking_detail']) : null;
    service = json['service'] != null ? ServiceData.fromJson(json['service']) : null;
    customer = json['customer'] != null ? UserData.fromJson(json['customer']) : null;
    if (json['booking_activity'] != null) {
      bookingActivity = [];
      json['booking_activity'].forEach((v) {
        bookingActivity!.add(BookingActivity.fromJson(v));
      });
    }
    providerData = json['provider_data'] != null ? UserData.fromJson(json['provider_data']) : null;
    if (json['rating_data'] != null) {
      ratingData = [];
      json['rating_data'].forEach((v) {
        ratingData!.add(RatingData.fromJson(v));
      });
    }
    couponData = json['coupon_data'] != null ? CouponData.fromJson(json['coupon_data']) : null;

    if (json['handyman_data'] != null) {
      handymanData = [];
      json['handyman_data'].forEach((v) {
        handymanData!.add(UserData.fromJson(v));
      });
    }
    if (json['service_proof'] != null) {
      serviceProof = [];
      json['service_proof'].forEach((v) {
        serviceProof!.add(ServiceProof.fromJson(v));
      });
    }
    postRequestDetail = json['post_request_detail'] != null ? PostJobData.fromJson(json['post_request_detail']) : null;
    shop = json['shop_data'] != null ? ShopModel.fromJson(json['shop_data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (bookingDetail != null) {
      data['booking_detail'] = bookingDetail!.toJson();
    }
    if (service != null) {
      data['service'] = service!.toJson();
    }
    if (customer != null) {
      data['customer'] = customer!.toJson();
    }
    if (bookingActivity != null) {
      data['booking_activity'] = bookingActivity!.map((v) => v.toJson()).toList();
    }
    if (ratingData != null) {
      data['rating_data'] = ratingData!.map((v) => v.toJson()).toList();
    }
    if (couponData != null) {
      data['coupon_data'] = couponData!.toJson();
    }
    if (providerData != null) {
      data['provider_data'] = providerData!.toJson();
    }
    if (handymanData != null) {
      data['handyman_data'] = handymanData!.map((v) => v.toJson()).toList();
    }
    if (serviceProof != null) {
      data['service_proof'] = serviceProof!.map((v) => v.toJson()).toList();
    }
    if (postRequestDetail != null) {
      data['post_request_detail'] = postRequestDetail?.toJson();
    }
    if (shop != null) {
      data['shop_data'] = shop?.toJson();
    }
    return data;
  }
}

class CouponData {
  int? bookingId;
  String? code;
  String? createdAt;
  String? deletedAt;
  num? discount;
  String? discountType;
  int? id;
  String? updatedAt;
  num? totalCalculatedValue;

  CouponData({this.bookingId, this.code, this.createdAt, this.deletedAt, this.discount, this.discountType, this.id, this.updatedAt, this.totalCalculatedValue});

  factory CouponData.fromJson(Map<String, dynamic> json) {
    return CouponData(
      bookingId: json['booking_id'],
      code: json['code'],
      createdAt: json['created_at'],
      deletedAt: json['deleted_at'],
      discount: json['discount'],
      discountType: json['discount_type'],
      id: json['id'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['booking_id'] = bookingId;
    data['code'] = code;
    data['created_at'] = createdAt;
    data['discount'] = discount;
    data['deleted_at'] = deletedAt;
    data['discount_type'] = discountType;
    data['id'] = id;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class BookingActivity {
  int? id;
  int? bookingId;
  String? datetime;
  String? activityType;
  String? activityMessage;
  String? activityData;
  String? createdAt;
  String? updatedAt;

  BookingActivity({this.id, this.bookingId, this.datetime, this.activityType, this.activityMessage, this.activityData, this.createdAt, this.updatedAt});

  BookingActivity.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bookingId = json['booking_id'];
    datetime = json['datetime'];
    activityType = json['activity_type'];
    activityMessage = json['activity_message'];
    activityData = json['activity_data'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['booking_id'] = bookingId;
    data['datetime'] = datetime;
    data['activity_type'] = activityType;
    data['activity_message'] = activityMessage;
    data['activity_data'] = activityData;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class RatingData {
  num? id;
  num? rating;
  String? review;
  num? serviceId;
  num? bookingId;
  String? createdAt;
  String? customerName;
  String? profileImage;
  String? customerProfileImage;
  String? handymanProfileImage;

  String? serviceName;
  num? handymanId;
  num? customerId;
  String? handymanName;
  List<Attachments>? attachments;

  RatingData({
    this.id,
    this.rating,
    this.review,
    this.serviceId,
    this.bookingId,
    this.createdAt,
    this.customerName,
    this.profileImage,
    this.customerProfileImage,
    this.handymanProfileImage,
    this.serviceName,
    this.handymanId,
    this.customerId,
    this.handymanName,
    this.attachments,
  });

  RatingData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    rating = json['rating'];
    review = json['review'];
    serviceId = json['service_id'];
    bookingId = json['booking_id'];
    createdAt = json['created_at'];
    customerName = json['customer_name'];
    profileImage = json['profile_image'];
    customerProfileImage = json['customer_profile_image'];
    handymanProfileImage = json['handyman_profile_image'];
    serviceName = json['service_name'];
    handymanId = json['handyman_id'];
    customerId = json['customer_id'];
    handymanName = json['handyman_name'];
    attachments = json['attchments_array'] != null ? (json['attchments_array'] as List).map((i) => Attachments.fromJson(i)).toList() : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['rating'] = rating;
    data['review'] = review;
    data['service_id'] = serviceId;
    data['booking_id'] = bookingId;
    data['created_at'] = createdAt;
    data['customer_name'] = customerName;
    data['profile_image'] = profileImage;
    data['customer_profile_image'] = customerProfileImage;
    data['handyman_profile_image'] = handymanProfileImage;
    data['service_name'] = serviceName;
    data['handyman_id'] = handymanId;
    data['customer_id'] = customerId;
    data['handyman_name'] = handymanName;
    if (attachments != null) {
      data['attchments_array'] = attachments!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ServiceProof {
  int? id;
  String? title;
  String? description;
  int? serviceId;
  int? bookingId;
  int? userId;
  String? handymanName;
  String? serviceName;
  List<String>? attachments;

  ServiceProof({
    this.id,
    this.title,
    this.description,
    this.serviceId,
    this.bookingId,
    this.userId,
    this.handymanName,
    this.serviceName,
    this.attachments,
  });

  ServiceProof.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    serviceId = json['service_id'];
    bookingId = json['booking_id'];
    userId = json['user_id'];
    handymanName = json['handyman_name'];
    serviceName = json['service_name'];
    attachments = json['attachments'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['service_id'] = serviceId;
    data['booking_id'] = bookingId;
    data['user_id'] = userId;
    data['handyman_name'] = handymanName;
    data['service_name'] = serviceName;
    data['attachments'] = attachments;
    return data;
  }
}

class ServiceAddon {
  int id;
  String name;
  String serviceName;
  String serviceAddonImage;
  int serviceId;
  int serviceAddonId;
  num price;
  int status;
  String deletedAt;
  String createdAt;
  String updatedAt;
  bool isSelected = false;
  Map<String, MultiLanguageRequest>? translations;

  ServiceAddon(
      {this.id = -1,
      this.name = "",
      this.serviceName = "",
      this.serviceAddonImage = "",
      this.serviceId = -1,
      this.serviceAddonId = -1,
      this.price = 0,
      this.status = -1,
      this.deletedAt = "",
      this.createdAt = "",
      this.updatedAt = "",
      this.translations});

  factory ServiceAddon.fromJson(Map<String, dynamic> json) {
    return ServiceAddon(
      id: json['id'] is int ? json['id'] : -1,
      name: json['name'] is String ? json['name'] : "",
      serviceName: json['service_name'] is String ? json['service_name'] : "",
      serviceAddonImage: json['serviceaddon_image'] is String ? json['serviceaddon_image'] : "",
      serviceId: json['service_id'] is int ? json['service_id'] : -1,
      serviceAddonId: json['service_addon_id'] is int ? json['service_addon_id'] : -1,
      price: json['price'] is num ? json['price'] : 0,
      status: json['status'] is int ? json['status'] : -1,
      deletedAt: json['deleted_at'] is String ? json['deleted_at'] : "",
      createdAt: json['created_at'] is String ? json['created_at'] : "",
      updatedAt: json['updated_at'] is String ? json['updated_at'] : "",
      translations: json['translations'] != null
          ? (jsonDecode(json['translations']) as Map<String, dynamic>).map(
              (key, value) {
                if (value is Map<String, dynamic>) {
                  return MapEntry(key, MultiLanguageRequest.fromJson(value));
                } else {
                  print('Unexpected translation value for key $key: $value');
                  return MapEntry(key, MultiLanguageRequest());
                }
              },
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'service_name': serviceName,
      'serviceaddon_image': serviceAddonImage,
      if (serviceId > 0) 'service_id': serviceId,
      if (serviceAddonId > 0) 'service_addon_id': serviceAddonId,
      'price': price,
      'status': status,
      if (deletedAt.isNotEmpty) 'deleted_at': deletedAt,
      if (createdAt.isNotEmpty) 'created_at': createdAt,
      if (updatedAt.isNotEmpty) 'updated_at': updatedAt,
      if (translations != null) 'translations': translations!.map((key, value) => MapEntry(key, value.toJson())),
    };
  }
}