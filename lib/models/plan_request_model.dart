import 'package:handyman_provider_flutter/models/provider_subscription_model.dart';

class PlanRequestModel {
  int? amount;
  String? description;
  String? duration;
  String? identifier;
  String? otherTransactionDetail;
  String? paymentStatus;
  String? paymentType;
  int? planId;
  PlanLimitation? planLimitation;
  String? planType;
  String? title;
  String? txnId;
  String? type;
  int? userId;
  String activeRevenueCatIdentifier;

  PlanRequestModel({
    this.amount,
    this.description,
    this.duration,
    this.identifier,
    this.otherTransactionDetail,
    this.paymentStatus,
    this.paymentType,
    this.planId,
    this.planLimitation,
    this.planType,
    this.title,
    this.txnId,
    this.type,
    this.userId,
    this.activeRevenueCatIdentifier = '',
  });

  factory PlanRequestModel.fromJson(Map<String, dynamic> json) {
    return PlanRequestModel(
      amount: json['amount'],
      description: json['description'],
      duration: json['duration'],
      identifier: json['identifier'],
      otherTransactionDetail: json['other_transaction_detail'],
      paymentStatus: json['payment_status'],
      paymentType: json['payment_type'],
      planId: json['plan_id'],
      planLimitation: json['plan_limitation'] != null ? PlanLimitation.fromJson(json['plan_limitation']) : null,
      planType: json['plan_type'],
      title: json['title'],
      txnId: json['txn_id'],
      type: json['type'],
      userId: json['user_id'],
      activeRevenueCatIdentifier: json['active_in_app_purchase_identifier'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['amount'] = amount;
    data['description'] = description;
    data['duration'] = duration;
    data['identifier'] = identifier;
    data['other_transaction_detail'] = otherTransactionDetail;
    data['payment_status'] = paymentStatus;
    data['payment_type'] = paymentType;
    data['plan_id'] = planId;
    data['plan_type'] = planType;
    data['title'] = title;
    data['txn_id'] = txnId;
    data['type'] = type;
    data['user_id'] = userId;
    data['active_in_app_purchase_identifier'] = activeRevenueCatIdentifier;
    if (planLimitation != null) {
      data['plan_limitation'] = planLimitation!.toJson();
    }
    return data;
  }
}