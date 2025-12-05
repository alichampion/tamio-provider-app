import 'package:handyman_provider_flutter/models/booking_detail_response.dart';
import 'package:handyman_provider_flutter/models/user_data.dart';

import 'service_model.dart';

class HandymanInfoResponse {
  UserData? handymanData;
  List<ServiceData>? service;
  List<RatingData>? handymanRatingReview;

  HandymanInfoResponse({this.handymanData, this.service, this.handymanRatingReview});

  HandymanInfoResponse.fromJson(Map<String, dynamic> json) {
    handymanData = json['data'] != null ? UserData.fromJson(json['data']) : null;
    if (json['service'] != null) {
      service = [];
      json['service'].forEach((v) {
        service!.add(ServiceData.fromJson(v));
      });
    }
    if (json['handyman_rating_review'] != null) {
      handymanRatingReview = [];
      json['handyman_rating_review'].forEach((v) {
        handymanRatingReview!.add(RatingData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (handymanData != null) {
      data['data'] = handymanData!.toJson();
    }
    if (service != null) {
      data['service'] = service!.map((v) => v.toJson()).toList();
    }
    if (handymanRatingReview != null) {
      data['handyman_rating_review'] = handymanRatingReview!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class HandymanRatingReview {
  int? id;
  int? customerId;
  num? rating;
  String? review;
  int? serviceId;
  int? bookingId;
  int? handymanId;
  String? handymanName;
  String? handymanProfileImage;
  String? customerName;
  String? customerProfileImage;
  String? createdAt;

  HandymanRatingReview(
      {this.id,
      this.customerId,
      this.rating,
      this.review,
      this.serviceId,
      this.bookingId,
      this.handymanId,
      this.handymanName,
      this.handymanProfileImage,
      this.customerName,
      this.customerProfileImage,
      this.createdAt});

  HandymanRatingReview.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerId = json['customer_id'];
    rating = json['rating'];
    review = json['review'];
    serviceId = json['service_id'];
    bookingId = json['booking_id'];
    handymanId = json['handyman_id'];
    handymanName = json['handyman_name'];
    handymanProfileImage = json['handyman_profile_image'];
    customerName = json['customer_name'];
    customerProfileImage = json['customer_profile_image'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['customer_id'] = customerId;
    data['rating'] = rating;
    data['review'] = review;
    data['service_id'] = serviceId;
    data['booking_id'] = bookingId;
    data['handyman_id'] = handymanId;
    data['handyman_name'] = handymanName;
    data['handyman_profile_image'] = handymanProfileImage;
    data['customer_name'] = customerName;
    data['customer_profile_image'] = customerProfileImage;
    data['created_at'] = createdAt;
    return data;
  }
}