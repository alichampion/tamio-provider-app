import 'package:handyman_provider_flutter/models/pagination_model.dart';

class WalletHistoryListResponse {
  List<WalletHistory>? data;
  Pagination? pagination;
  num? availableBalance;

  WalletHistoryListResponse({this.data, this.pagination, this.availableBalance});

  factory WalletHistoryListResponse.fromJson(Map<String, dynamic> json) {
    return WalletHistoryListResponse(
      data: json['data'] != null ? (json['data'] as List).map((i) => WalletHistory.fromJson(i)).toList() : null,
      pagination: json['pagination'] != null ? Pagination.fromJson(json['pagination']) : null,
      availableBalance: json['available_balance'] != null ? json['available_balance'] : 0,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (pagination != null) {
      data['pagination'] = pagination!.toJson();
    }
    data['available_balance'] = availableBalance;
    return data;
  }
}

class WalletHistory {
  ActivityData? activityData;
  String? activityMessage;
  String? activityType;
  String? datetime;
  int? id;
  String? userImage;
  WalletHistory({
    this.activityData,
    this.activityMessage,
    this.activityType,
    this.datetime,
    this.id,
    this.userImage,
  });

  factory WalletHistory.fromJson(Map<String, dynamic> json) {
    return WalletHistory(
      activityData: json['activity_data'] != null ? ActivityData.fromJson(json['activity_data']) : null,
      activityMessage: json['activity_message'],
      activityType: json['activity_type'],
      datetime: json['datetime'],
      id: json['id'],
      userImage: json['user_image'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (data['activity_data'] != null) {
      data['activity_data'] = activityData;
    }
    data['activity_message'] = activityMessage;
    data['activity_type'] = activityType;
    data['datetime'] = datetime;

    data['id'] = id;
    data['user_image'] = userImage;
    return data;
  }
}

class ActivityData {
  num? amount;
  num? creditDebitAmount;
  String? providerName;
  String? title;
  int? userId;
  String? transactionType;

  ActivityData({
    this.amount,
    this.providerName,
    this.title,
    this.userId,
    this.creditDebitAmount,
    this.transactionType,
  });

  factory ActivityData.fromJson(Map<String, dynamic> json) {
    return ActivityData(
      amount: json['amount'],
      providerName: json['provider_name'],
      title: json['title'],
      userId: json['user_id'],
      creditDebitAmount: json['credit_debit_amount'],
      transactionType: json['transaction_type'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['amount'] = amount;
    data['provider_name'] = providerName;
    data['title'] = title;
    data['user_id'] = userId;
    data['credit_debit_amount'] = creditDebitAmount;
    return data;
  }
}