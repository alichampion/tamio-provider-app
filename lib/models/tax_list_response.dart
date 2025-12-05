import 'package:handyman_provider_flutter/models/pagination_model.dart';

class TaxListResponse {
  List<TaxData>? taxData;
  Pagination? pagination;

  TaxListResponse({this.taxData, this.pagination});

  factory TaxListResponse.fromJson(Map<String, dynamic> json) {
    return TaxListResponse(
      taxData: json['data'] != null ? (json['data'] as List).map((i) => TaxData.fromJson(i)).toList() : null,
      pagination: json['pagination'] != null ? Pagination.fromJson(json['pagination']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (taxData != null) {
      data['data'] = taxData!.map((v) => v.toJson()).toList();
    }
    if (pagination != null) {
      data['pagination'] = pagination!.toJson();
    }
    return data;
  }
}

class TaxData {
  int? id;
  int? providerId;
  String? title;
  String? type;
  num? value;
  num? totalCalculatedValue;

  TaxData({this.id, this.providerId, this.title, this.type, this.value, this.totalCalculatedValue});

  factory TaxData.fromJson(Map<String, dynamic> json) {
    return TaxData(
      id: json['id'],
      providerId: json['provider_id'],
      title: json['title'],
      type: json['type'],
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['provider_id'] = providerId;
    data['title'] = title;
    data['type'] = type;
    data['value'] = value;
    return data;
  }
}