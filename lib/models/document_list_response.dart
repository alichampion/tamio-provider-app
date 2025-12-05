import 'package:handyman_provider_flutter/models/pagination_model.dart';

class DocumentListResponse {
  Pagination? pagination;
  List<Documents>? documents;

  DocumentListResponse({this.pagination, this.documents});

  DocumentListResponse.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null ? Pagination.fromJson(json['pagination']) : null;
    if (json['data'] != null) {
      documents = [];
      json['data'].forEach((v) {
        documents!.add(Documents.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (pagination != null) {
      data['pagination'] = pagination!.toJson();
    }
    if (documents != null) {
      data['data'] = documents!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Documents {
  int? id;
  String? name;
  int? status;
  int? isRequired;
  String? filePath;

  Documents({this.id, this.name, this.status, this.isRequired, this.filePath});

  Documents.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    status = json['status'];
    isRequired = json['is_required'];
    filePath = json['file_path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['status'] = status;
    data['is_required'] = isRequired;
    data['file_path'] = filePath;
    return data;
  }

  Documents copyWith({
    int? id,
    String? name,
    int? status,
    int? isRequired,
    String? filePath,
  }) {
    return Documents(
      id: id ?? this.id,
      name: name ?? this.name,
      status: status ?? this.status,
      isRequired: isRequired ?? this.isRequired,
      filePath: filePath ?? this.filePath,
    );
  }
}
