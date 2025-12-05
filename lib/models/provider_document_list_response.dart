import 'package:handyman_provider_flutter/models/pagination_model.dart';

class ProviderDocumentListResponse {
  Pagination? pagination;
  List<ProviderDocuments>? providerDocuments;

  ProviderDocumentListResponse({this.pagination, this.providerDocuments});

  ProviderDocumentListResponse.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null ? Pagination.fromJson(json['pagination']) : null;
    if (json['data'] != null) {
      providerDocuments = [];
      json['data'].forEach((v) {
        providerDocuments!.add(ProviderDocuments.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (pagination != null) {
      data['pagination'] = pagination!.toJson();
    }
    if (providerDocuments != null) {
      data['data'] = providerDocuments!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProviderDocuments {
  int? id;
  int? providerId;
  int? documentId;
  String? documentName;
  int? isVerified;
  String? providerDocument;
  int? shopId;
  String? shopName;
  String? shopDocument;

  ProviderDocuments({this.id, this.providerId, this.documentId, this.documentName, this.isVerified, this.providerDocument, this.shopId, this.shopDocument, this.shopName});

  ProviderDocuments.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    providerId = json['provider_id'];
    documentId = json['document_id'];
    documentName = json['document_name'];
    isVerified = json['is_verified'];
    providerDocument = json['provider_document'];
    shopId = json['shop_id'];
    shopName = json['shop_name'];
    shopDocument = json['shop_document'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['provider_id'] = providerId;
    data['document_id'] = documentId;
    data['document_name'] = documentName;
    data['is_verified'] = isVerified;
    data['provider_document'] = providerDocument;
    data['shop_id'] = this.shopId;
    data['shop_name'] = this.shopName;
    data['shop_document'] = this.shopDocument;
    return data;
  }
}