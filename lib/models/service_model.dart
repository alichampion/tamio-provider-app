import 'dart:convert';
import 'package:handyman_provider_flutter/models/attachment_model.dart';
import 'package:handyman_provider_flutter/models/booking_detail_response.dart';
import 'package:handyman_provider_flutter/models/package_response.dart';
import 'package:handyman_provider_flutter/models/service_detail_response.dart';
import 'package:handyman_provider_flutter/provider/timeSlots/models/slot_data.dart';
import 'package:handyman_provider_flutter/utils/constant.dart';
import 'package:nb_utils/nb_utils.dart';
import '../utils/model_keys.dart';
import 'multi_language_request_model.dart';

class ServiceData {
  int? id;
  String? name;
  int? categoryId;
  int? subCategoryId;
  int? providerId;
  num? price;
  var priceFormat;
  String? type;
  num? discount;
  String? duration;
  int? status;
  String? description;
  int? isFeatured;
  String? providerName;
  String? providerImage;
  int? cityId;
  String? categoryName;

  List<String>? imageAttachments;
  List<Attachments>? attchments;
  num? totalReview;
  num? totalRating;
  int? isFavourite;
  List<ServiceAddressMapping>? serviceAddressMapping;
  Map<String, MultiLanguageRequest>? translations;
  String? rejectReason;
  String? serviceRequestStatus;

  //Set Values
  num? totalAmount;
  num? discountPrice;
  num? taxAmount;
  num? couponDiscountAmount;
  String? dateTimeVal;
  String? couponId;
  num? qty;
  String? address;
  int? bookingAddressId;
  CouponData? appliedCouponData;
  num? isSlot;
  String? visitType;
  List<SlotData>? providerSlotData;
  List<PackageData>? servicePackage;
  num? advancePaymentSetting;
  num? isEnableAdvancePayment;
  num? advancePaymentAmount;
  num? advancePaymentPercentage;
  String? reason;

  //Local
  bool get isHourlyService => type.validate() == SERVICE_TYPE_HOURLY;

  bool get isFixedService => type.validate() == SERVICE_TYPE_FIXED;

  bool get isFreeService => price.validate() == 0;

  bool get isAdvancePayment => isEnableAdvancePayment.validate() == 1;

  bool get isAdvancePaymentSetting => advancePaymentSetting.validate() == 1;

  String? subCategoryName;

  bool? isSelected;

  bool get isOnlineService => visitType == VISIT_OPTION_ONLINE;

  bool get isOnSiteService => visitType == VISIT_OPTION_ON_SITE;

  bool get isOnShop => visitType == VISIT_OPTION_SHOP;
  List<Zones>? zones;

  ServiceData({
    this.id,
    this.name,
    this.imageAttachments,
    this.providerSlotData,
    this.categoryId,
    this.providerId,
    this.price,
    this.priceFormat,
    this.type,
    this.discount,
    this.duration,
    this.status,
    this.isSlot,
    this.visitType,
    this.description,
    this.isFeatured,
    this.providerName,
    this.subCategoryId,
    this.providerImage,
    this.cityId,
    this.categoryName,
    this.attchments,
    this.totalReview,
    this.totalRating,
    this.isFavourite,
    this.serviceAddressMapping,
    this.rejectReason,
    this.serviceRequestStatus,
    this.totalAmount,
    this.discountPrice,
    this.taxAmount,
    this.couponDiscountAmount,
    this.dateTimeVal,
    this.couponId,
    this.subCategoryName,
    this.qty,
    this.address,
    this.bookingAddressId,
    this.appliedCouponData,
    this.isSelected,
    this.servicePackage,
    this.advancePaymentSetting,
    this.isEnableAdvancePayment,
    this.advancePaymentAmount,
    this.advancePaymentPercentage,
    this.translations,
    this.reason,
    this.zones,
  });

  ServiceData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    providerImage = json['provider_image'];
    categoryId = json['category_id'];
    subCategoryId = json['subcategory_id'];
    providerId = json['provider_id'];
    price = json['price'];
    priceFormat = json['price_format'];
    type = json['type'];
    discount = json['discount'];
    duration = json['duration'];
    status = json['status'];
    isSlot = json['is_slot'];
    visitType = json['visit_type'];
    description = json['description'];
    isFeatured = json['is_featured'];
    providerName = json['provider_name'];
    cityId = json['city_id'];
    categoryName = json['category_name'];
    imageAttachments = json['attchments'] != null ? List<String>.from(json['attchments']) : null;
    attchments = json['attchments_array'] != null ? (json['attchments_array'] as List).map((i) => Attachments.fromJson(i)).toList() : null;
    providerSlotData = json['slots'] != null ? (json['slots'] as List).map((i) => SlotData.fromJson(i)).toList() : null;
    subCategoryName = json['subcategory_name'];
    translations = json['translations'] != null
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
        : null;
    totalReview = json['total_review'];
    totalRating = json['total_rating'];
    isFavourite = json['is_favourite'];
    reason = json['reason'];
    rejectReason = json['reject_reason'] is String ? json['reject_reason'] : '';
    serviceRequestStatus = json['service_request_status'] is String ? json['service_request_status'] : '';

    if (json['service_address_mapping'] != null) {
      serviceAddressMapping = [];
      json['service_address_mapping'].forEach((v) {
        serviceAddressMapping!.add(new ServiceAddressMapping.fromJson(v));
      });
    }
    servicePackage = json['servicePackage'] != null ? (json['servicePackage'] as List).map((i) => PackageData.fromJson(i)).toList() : null;
    advancePaymentSetting = json[AdvancePaymentKey.advancePaymentSetting];
    isEnableAdvancePayment = json[AdvancePaymentKey.isEnableAdvancePayment];
    advancePaymentAmount = json[AdvancePaymentKey.advancePaymentAmount];
    advancePaymentPercentage = json[AdvancePaymentKey.advancePaymentAmount];
    zones = json['zones'] != null ? (json['zones'] as List).map((i) => Zones.fromJson(i)).toList() : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['provider_image'] = providerImage;
    data['category_id'] = categoryId;
    data['provider_id'] = providerId;
    data['is_slot'] = isSlot;
    data['visit_type'] = visitType;
    data['price'] = price;
    data['price_format'] = priceFormat;
    data['type'] = type;
    data['discount'] = discount;
    data['duration'] = duration;
    data['status'] = status;
    data['description'] = description;
    data['is_featured'] = isFeatured;
    data['provider_name'] = providerName;
    data['city_id'] = cityId;
    data['subcategory_id'] = subCategoryId;
    data['subcategory_name'] = subCategoryName;
    data['category_name'] = categoryName;
    data['reason'] = reason;
    data['reject_reason'] = rejectReason;
    data['service_request_status'] = serviceRequestStatus;
    if (imageAttachments != null) {
      data['attchments'] = imageAttachments;
    }
    if (providerSlotData != null) {
      data['slots'] = providerSlotData;
    }
    if (servicePackage != null) {
      data['servicePackage'] = servicePackage!.map((v) => v.toJson()).toList();
    }
    if (translations != null) {
      data['translations'] = translations!.map((key, value) => MapEntry(key, value.toJson()));
    }
    data['total_review'] = totalReview;
    data['total_rating'] = totalRating;
    data['is_favourite'] = isFavourite;
    if (serviceAddressMapping != null) {
      data['service_address_mapping'] = serviceAddressMapping!.map((v) => v.toJson()).toList();
    }
    if (attchments != null) {
      data['attchments_array'] = attchments!.map((v) => v.toJson()).toList();
    }

    data[AdvancePaymentKey.advancePaymentSetting] = advancePaymentSetting;
    data[AdvancePaymentKey.isEnableAdvancePayment] = isEnableAdvancePayment;
    data[AdvancePaymentKey.advancePaymentAmount] = advancePaymentAmount;
    data[AdvancePaymentKey.advancePaymentAmount] = advancePaymentPercentage;
    data['zones'] = zones != null ? zones!.map((v) => v.toJson()).toList() : null;
    return data;
  }
}