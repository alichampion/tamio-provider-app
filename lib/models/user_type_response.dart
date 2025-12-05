import 'dart:convert';

import 'package:handyman_provider_flutter/models/pagination_model.dart';

import 'multi_language_request_model.dart';

class UserTypeResponse {
  List<UserTypeData>? userTypeData;
  Pagination? pagination;

  UserTypeResponse({this.userTypeData, this.pagination});

  factory UserTypeResponse.fromJson(Map<String, dynamic> json) {
    return UserTypeResponse(
      userTypeData: json['data'] != null ? (json['data'] as List).map((i) => UserTypeData.fromJson(i)).toList() : null,
      pagination: json['pagination'] != null ? Pagination.fromJson(json['pagination']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (userTypeData != null) {
      data['data'] = userTypeData!.map((v) => v.toJson()).toList();
    }
    if (pagination != null) {
      data['pagination'] = pagination!.toJson();
    }
    return data;
  }
}

class UserTypeData {
  String? createdAt;
  int? id;
  String? name;
  num? commission;
  int? status;
  String? type;
  String? updatedAt;
  String? deletedAt;
  int? createdBy;
  int? updatedBy;
  Map<String, MultiLanguageRequest>? translations;

  UserTypeData({this.createdAt, this.id, this.name, this.commission, this.status, this.type, this.updatedAt, this.deletedAt, this.createdBy, this.updatedBy, this.translations});

  factory UserTypeData.fromJson(Map<String, dynamic> json) {
    return UserTypeData(
        createdAt: json['created_at'],
        id: json['id'],
        name: json['name'],
        commission: json['commission'],
        status: json['status'],
        type: json['type'],
        updatedAt: json['updated_at'],
        deletedAt: json['deleted_at'],
        createdBy: json['created_by'],
        updatedBy: json['updated_by'],
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
            : null);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['created_at'] = createdAt;
    data['id'] = id;
    data['name'] = name;
    data['commission'] = commission;
    data['status'] = status;
    data['type'] = type;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    data['created_by'] = createdBy;
    data['updated_by'] = updatedBy;
    if (translations != null) {
      data['translations'] = translations!.map((key, value) => MapEntry(key, value.toJson()));
    }
    return data;
  }
}