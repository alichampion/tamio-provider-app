import 'dart:convert';

import 'package:handyman_provider_flutter/models/attachment_model.dart';
import 'package:handyman_provider_flutter/models/pagination_model.dart';
import 'package:handyman_provider_flutter/models/service_model.dart';

import 'multi_language_request_model.dart';

class PackageResponse {
  Pagination? pagination;
  List<PackageData>? packageList;

  PackageResponse(this.pagination, this.packageList);

  PackageResponse.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null ? new Pagination.fromJson(json['pagination']) : null;
    if (json['data'] != null) {
      packageList = [];
      json['data'].forEach((v) {
        packageList!.add(PackageData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (pagination != null) {
      data['pagination'] = pagination!.toJson();
    }
    if (packageList != null) {
      data['data'] = packageList!.map((v) => v.toJson()).toList();
    }

    return data;
  }
}

class PackageData {
  int? id;
  String? name;
  String? description;
  num? price;
  String? startDate;
  String? endDate;
  List<ServiceData>? serviceList;
  var isFeatured;
  int? categoryId;
  int? subCategoryId;
  List<Attachments>? attchments;
  List<String>? imageAttachments;
  int? status;
  String? categoryName;
  String? subCategoryName;
  String? packageType;
  Map<String, MultiLanguageRequest>? translations;

  PackageData(
      {this.id,
      this.name,
      this.description,
      this.price,
      this.startDate,
      this.endDate,
      this.serviceList,
      this.isFeatured,
      this.categoryId,
      this.attchments,
      this.imageAttachments,
      this.status,
      this.categoryName,
      this.packageType,
      this.translations});

  PackageData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    categoryName = json['category_name'];
    subCategoryName = json['subcategory_name'];
    description = json['description'];
    price = json['price'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    status = json['status'];
    packageType = json['package_type'];
    serviceList = json['services'] != null ? (json['services'] as List).map((i) => ServiceData.fromJson(i)).toList() : null;
    attchments = json['attchments_array'] != null ? (json['attchments_array'] as List).map((i) => Attachments.fromJson(i)).toList() : null;
    imageAttachments = json['attchments'] != null ? List<String>.from(json['attchments']) : null;
    categoryId = json['category_id'];
    subCategoryId = json['subcategory_id'];
    isFeatured = json['is_featured'];
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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['price'] = price;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['status'] = status;
    data['category_name'] = categoryName;
    data['subcategory_name'] = subCategoryName;
    data['status'] = status;
    data['package_type'] = packageType;
    if (translations != null) {
      data['translations'] = translations!.map((key, value) => MapEntry(key, value.toJson()));
    }
    if (serviceList != null) {
      data['services'] = serviceList!.map((v) => v.toJson()).toList();
    }
    data['category_id'] = categoryId;
    data['subcategory_id'] = subCategoryId;
    data['is_featured'] = isFeatured;
    if (attchments != null) {
      data['attchments_array'] = attchments!.map((v) => v.toJson()).toList();
    }
    if (imageAttachments != null) {
      data['attchments'] = imageAttachments;
    }
    return data;
  }
}