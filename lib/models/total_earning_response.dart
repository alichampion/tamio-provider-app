import 'package:handyman_provider_flutter/models/pagination_model.dart';

class TotalEarningResponse {
  List<TotalData>? data;
  Pagination? pagination;

  TotalEarningResponse({this.data, this.pagination});

  factory TotalEarningResponse.fromJson(Map<String, dynamic> json) {
    return TotalEarningResponse(
      data: json['data'] != null ? (json['data'] as List).map((i) => TotalData.fromJson(i)).toList() : null,
      pagination: json['pagination'] != null ? Pagination.fromJson(json['pagination']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (pagination != null) {
      data['pagination'] = pagination!.toJson();
    }
    return data;
  }
}

class TotalData {
  num? amount;
  String? createdAt;
  String? description;
  int? id;
  String? paymentMethod;

  TotalData({this.amount, this.createdAt, this.description, this.id, this.paymentMethod});

  factory TotalData.fromJson(Map<String, dynamic> json) {
    return TotalData(
      amount: json['amount'],
      createdAt: json['created_at'],
      description: json['description'],
      id: json['id'],
      paymentMethod: json['payment_method'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['amount'] = amount;
    data['created_at'] = createdAt;
    data['id'] = id;
    data['payment_method'] = paymentMethod;
    data['description'] = description;
    return data;
  }
}
