import 'package:handyman_provider_flutter/main.dart';
import 'package:handyman_provider_flutter/models/booking_list_response.dart';
import 'package:handyman_provider_flutter/models/service_model.dart';
import 'package:handyman_provider_flutter/models/user_data.dart';
import 'package:nb_utils/nb_utils.dart';

import '../provider/jobRequest/models/post_job_data.dart';
import '../utils/constant.dart';
import 'provider_subscription_model.dart';
import 'revenue_chart_data.dart';

class DashboardResponse {
  bool? status;
  int? totalBooking;
  int? totalService;
  num? todayCashAmount;
  num? totalCashInHand;
  int? totalActiveHandyman;
  List<ServiceData>? service;
  List<UserData>? handyman;
  num? totalRevenue;
  Commission? commission;
  int? isSubscribed;
  int? isEmailVerified;
  ProviderSubscriptionModel? subscription;
  ProviderWallet? providerWallet;
  List<String>? onlineHandyman;
  List<PostJobData>? myPostJobData;
  List<BookingData>? upcomingBookings;
  num? notificationUnreadCount;
  num? remainingPayout;

  //Local
  bool get isPlanAboutToExpire => isSubscribed == 1;

  bool get userNeverPurchasedPlan => isSubscribed == 0 && subscription == null;

  bool get isPlanExpired => isSubscribed == 0 && subscription != null;

  DashboardResponse({
    this.status,
    this.totalBooking,
    this.service,
    this.totalService,
    this.totalActiveHandyman,
    this.totalCashInHand,
    this.handyman,
    this.totalRevenue,
    this.commission,
    this.providerWallet,
    this.onlineHandyman,
    this.myPostJobData,
    this.upcomingBookings,
    this.notificationUnreadCount,
    this.todayCashAmount,
    this.isEmailVerified = 0,
    this.remainingPayout,
  });

  DashboardResponse.fromJson(Map<String, dynamic> json) {
    isEmailVerified = json['is_email_verified'];
    status = json['status'];
    totalBooking = json['total_booking'];
    totalRevenue = json['total_revenue'];
    totalService = json['total_service'];
    totalActiveHandyman = json['total_active_handyman'];
    todayCashAmount = json['today_cash'];
    totalCashInHand = json['total_cash_in_hand'];
    commission = json['commission'] != null ? Commission.fromJson(json['commission']) : null;
    if (json['service'] != null) {
      service = [];
      json['service'].forEach((v) {
        service!.add(ServiceData.fromJson(v));
      });
    }
    if (json['handyman'] != null) {
      handyman = [];
      json['handyman'].forEach((v) {
        handyman!.add(UserData.fromJson(v));
      });
    }

    final Iterable it = json['monthly_revenue']['revenueData'];
    chartData = [];
    it.forEachIndexed((element, index) {
      if ((element as Map).containsKey('${index + 1}')) {
        chartData.add(RevenueChartData(month: months[index], revenue: element[(index + 1).toString()].toString().toDouble()));
      } else {
        chartData.add(RevenueChartData(month: months[index], revenue: 0));
      }
    });

    providerWallet = json['provider_wallet'] != null ? ProviderWallet.fromJson(json['provider_wallet']) : null;

    onlineHandyman = json['online_handyman'] != null ? json['online_handyman'].cast<String>() : null;
    myPostJobData = json['post_requests'] != null ? (json['post_requests'] as List).map((i) => PostJobData.fromJson(i)).toList() : null;
    upcomingBookings = json['upcomming_booking'] != null ? (json['upcomming_booking'] as List).map((i) => BookingData.fromJson(i)).toList() : null;
    isSubscribed = json['is_subscribed'] ?? 0;
    subscription = json['subscription'] != null ? ProviderSubscriptionModel.fromJson(json['subscription']) : null;
    notificationUnreadCount = json['notification_unread_count'];
    remainingPayout = json['remaining_payout'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['status'] = status;
    data['total_booking'] = totalBooking;
    data['total_service'] = totalService;
    data['today_cash'] = todayCashAmount;
    data['total_cash_in_hand'] = totalCashInHand;
    data['is_email_verified'] = isEmailVerified;
    if (commission != null) {
      data['commission'] = commission!.toJson();
    }
    data['total_active_handyman'] = totalActiveHandyman;
    if (service != null) {
      data['service'] = service!.map((v) => v.toJson()).toList();
    }
    if (handyman != null) {
      data['handyman'] = handyman!.map((v) => v.toJson()).toList();
    }
    data['total_revenue'] = totalRevenue;
    data['online_handyman'] = onlineHandyman;
    if (providerWallet != null) {
      data['provider_wallet'] = providerWallet!.toJson();
    }

    if (myPostJobData != null) {
      data['post_requests'] = myPostJobData!.map((v) => v.toJson()).toList();
    }

    if (upcomingBookings != null) {
      data['upcomming_booking'] = upcomingBookings!.map((v) => v.toJson()).toList();
    }
    data['notification_unread_count'] = notificationUnreadCount;
    data['remaining_payout'] = remainingPayout;

    return data;
  }
}

class CategoryData {
  int? id;
  String? name;
  int? status;
  String? description;
  int? isFeatured;
  String? color;
  String? categoryImage;

  CategoryData({this.id, this.name, this.status, this.description, this.isFeatured, this.color, this.categoryImage});

  CategoryData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    status = json['status'];
    description = json['description'];
    isFeatured = json['is_featured'];
    color = json['color'];
    categoryImage = json['category_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['status'] = status;
    data['description'] = description;
    data['is_featured'] = isFeatured;
    data['color'] = color;
    data['category_image'] = categoryImage;
    return data;
  }
}

class Commission {
  num? commission;
  String? createdAt;
  String? deletedAt;
  int? id;
  String? name;
  int? status;
  String? type;
  String? updatedAt;

  Commission({this.commission, this.createdAt, this.deletedAt, this.id, this.name, this.status, this.type, this.updatedAt});

  factory Commission.fromJson(Map<String, dynamic> json) {
    return Commission(
      commission: json['commission'],
      createdAt: json['created_at'],
      deletedAt: json['deleted_at'],
      id: json['id'],
      name: json['name'],
      status: json['status'],
      type: json['type'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['commission'] = commission;
    data['created_at'] = createdAt;
    data['id'] = id;
    data['name'] = name;
    data['status'] = status;
    data['type'] = type;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    return data;
  }
}

class ProviderWallet {
  int? id;
  String? title;
  int? userId;
  num? amount;
  int? status;
  String? createdAt;
  String? updatedAt;

  ProviderWallet(this.id, this.title, this.userId, this.amount, this.status, this.createdAt, this.updatedAt);

  ProviderWallet.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    userId = json['user_id'];
    amount = json['amount'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['title'] = title;
    data['user_id'] = userId;
    data['amount'] = amount;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class ServiceAddressMapping {
  int? id;
  int? serviceId;
  int? providerAddressId;
  String? createdAt;
  String? updatedAt;
  ProviderAddressMapping? providerAddressMapping;

  ServiceAddressMapping({this.id, this.serviceId, this.providerAddressId, this.createdAt, this.updatedAt, this.providerAddressMapping});

  ServiceAddressMapping.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    serviceId = json['service_id'];
    providerAddressId = json['provider_address_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    providerAddressMapping = json['provider_address_mapping'] != null ? ProviderAddressMapping.fromJson(json['provider_address_mapping']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['service_id'] = serviceId;
    data['provider_address_id'] = providerAddressId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (providerAddressMapping != null) {
      data['provider_address_mapping'] = providerAddressMapping!.toJson();
    }
    return data;
  }
}

class ProviderAddressMapping {
  int? id;
  int? providerId;
  String? address;
  String? latitude;
  String? longitude;
  int? status;
  String? createdAt;
  String? updatedAt;

  ProviderAddressMapping({this.id, this.providerId, this.address, this.latitude, this.longitude, this.status, this.createdAt, this.updatedAt});

  ProviderAddressMapping.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    providerId = json['provider_id'];
    address = json['address'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['provider_id'] = providerId;
    data['address'] = address;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class MonthlyRevenue {
  List<RevenueData>? revenueData;

  MonthlyRevenue({this.revenueData});

  MonthlyRevenue.fromJson(Map<String, dynamic> json) {
    if (json['revenueData'] != null) {
      revenueData = [];
      json['revenueData'].forEach((v) {
        revenueData!.add(RevenueData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (revenueData != null) {
      data['revenueData'] = revenueData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RevenueData {
  var i;

  RevenueData({this.i});

  RevenueData.fromJson(Map<String, dynamic> json) {
    for (int i = 1; i <= 12; i++) {
      i = json['$i'];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    for (int i = 1; i <= 12; i++) {
      data['$i'] = this.i;
    }
    return data;
  }
}
