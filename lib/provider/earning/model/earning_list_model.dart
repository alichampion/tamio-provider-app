class EarningListModel {
  int? handymanId;
  String? handymanName;
  num? commission;
  String? commissionType;
  num? totalBookings;
  num? totalEarning;
  num? taxes;
  num? adminEarning;
  num? handymanPaidEarningFormate;
  String? handymanImage;
  String? email;
  String? taxesFormate;
  num? handymanDueAmount;
  num? handymanPaidEarning;
  num? handymanTotalAmount;
  num? providerTotalAmount;

  EarningListModel({
    this.adminEarning,
    this.commission,
    this.commissionType,
    this.handymanPaidEarningFormate,
    this.handymanId,
    this.handymanName,
    this.taxes,
    this.totalBookings,
    this.totalEarning,
    this.handymanImage,
    this.email,
    this.taxesFormate,
    this.handymanDueAmount,
    this.handymanPaidEarning,
    this.handymanTotalAmount,
    this.providerTotalAmount,
  });

  factory EarningListModel.fromJson(Map<String, dynamic> json) {
    return EarningListModel(
      commission: json['commission'],
      handymanPaidEarningFormate: json['handyman_paid_earning_formate'],
      handymanId: json['handyman_id'],
      commissionType: json['commission_type'],
      handymanName: json['handyman_name'],
      taxes: json['taxes'],
      adminEarning: json['admin_earning'],
      totalBookings: json['total_bookings'],
      totalEarning: json['total_earning'],
      handymanImage: json['handyman_image'],
      email: json['email'],
      taxesFormate: json['taxes_formate'],
      handymanDueAmount: json['handyman_due_amount'],
      handymanPaidEarning: json['handyman_paid_earning'],
      handymanTotalAmount: json['handyman_total_amount'],
      providerTotalAmount: json['provider_total_amount'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['admin_earning'] = adminEarning;
    data['commission'] = commission;
    data['handyman_paid_earning_formate'] = handymanPaidEarningFormate;
    data['commission_type'] = commissionType;
    data['handyman_id'] = handymanId;
    data['handyman_name'] = handymanName;
    data['taxes'] = taxes;
    data['total_bookings'] = totalBookings;
    data['total_earning'] = totalEarning;
    data['handyman_image'] = handymanImage;
    data['email'] = email;
    data['taxes_formate'] = taxesFormate;
    data['handyman_due_amount'] = handymanDueAmount;
    data['handyman_paid_earning'] = handymanPaidEarning;
    data['handyman_total_amount'] = handymanTotalAmount;
    data['provider_total_amount'] = providerTotalAmount;
    return data;
  }
}
