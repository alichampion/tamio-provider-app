import 'package:handyman_provider_flutter/models/user_data.dart';

class CommonResponseModel {
  UserData? data;
  String? message;

  CommonResponseModel({this.data, this.message});

  CommonResponseModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? UserData.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = message;
    return data;
  }
}