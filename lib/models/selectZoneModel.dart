import 'package:handyman_provider_flutter/models/pagination_model.dart';

class SelectZoneModelResponse {
  Pagination? pagination;
  List<ZoneResponse>? zoneListResponse;

  SelectZoneModelResponse({this.pagination, this.zoneListResponse});

  SelectZoneModelResponse.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null ? new Pagination.fromJson(json['pagination']) : null;
    if (json['data'] != null && json['data']['data'] != null) {
      zoneListResponse = [];
      json['data']['data'].forEach((v) {
        zoneListResponse!.add(ZoneResponse.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (pagination != null) {
      data['pagination'] = pagination!.toJson();
    }
    if (zoneListResponse != null) {
      data['data'] = zoneListResponse!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ZoneResponse {
  int? id;
  String? name;
  bool? isSelected;

  ZoneResponse({this.id, this.name, this.isSelected});

  ZoneResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}