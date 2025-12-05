import 'package:handyman_provider_flutter/models/booking_detail_response.dart';
import 'package:handyman_provider_flutter/models/service_model.dart';
import 'package:handyman_provider_flutter/models/shop_model.dart';

class ServiceDetailResponse {
  Provider? provider;
  List<RatingData>? ratingData;
  List<ServiceFaq>? serviceFaq;
  ServiceData? serviceDetail;
  List<ShopModel> shop;
  List<Zones>? zones;

  ServiceDetailResponse({
    this.provider,
    this.serviceDetail,
    this.ratingData,
    this.serviceFaq,
    this.shop = const [],
    this.zones,
  });

  factory ServiceDetailResponse.fromJson(Map<String, dynamic> json) {
    return ServiceDetailResponse(
      provider: json['provider'] != null ? Provider.fromJson(json['provider']) : null,
      ratingData: json['rating_data'] != null ? (json['rating_data'] as List).map((i) => RatingData.fromJson(i)).toList() : null,
      serviceFaq: json['service_faq'] != null ? (json['service_faq'] as List).map((i) => ServiceFaq.fromJson(i)).toList() : null,
      serviceDetail: json['service_detail'] != null ? ServiceData.fromJson(json['service_detail']) : null,
      shop: json['shop'] != null ? (json['shop'] as List).map((i) => ShopModel.fromJson(i)).toList() : [],
      zones: json['zones'] != null ? (json['zones'] as List).map((i) => Zones.fromJson(i)).toList() : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();

    if (ratingData != null) {
      data['rating_data'] = ratingData!.map((v) => v.toJson()).toList();
    }
    if (serviceFaq != null) {
      data['service_faq'] = serviceFaq!.map((v) => v.toJson()).toList();
    }
    if (provider != null) {
      data['provider'] = provider!.toJson();
    }
    if (serviceDetail != null) {
      data['service_detail'] = serviceDetail!.toJson();
    }
    if (zones != null) {
      data['zones'] = zones!.map((v) => v.toJson()).toList();
    }
    if (this.shop != null) {
      data['shop'] = this.shop!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ServiceAddressMapping {
  String? createdAt;
  int? id;
  int? providerAddressId;
  ProviderAddressMapping? providerAddressMapping;

  ProviderZonesMapping? providerZonesMapping;
  int? serviceId;
  String? updatedAt;

  ServiceAddressMapping({this.createdAt, this.id, this.providerAddressId, this.providerAddressMapping, this.serviceId, this.updatedAt, ProviderZonesMapping? providerZonesMapping});

  factory ServiceAddressMapping.fromJson(Map<String, dynamic> json) {
    return ServiceAddressMapping(
      createdAt: json['created_at'],
      id: json['id'],
      providerAddressId: json['provider_address_id'],
      providerAddressMapping: json['provider_address_mapping'] != null ? ProviderAddressMapping.fromJson(json['provider_address_mapping']) : null,
      providerZonesMapping: json['provider_address_mapping'] != null ? ProviderZonesMapping.fromJson(json['provider_address_mapping']) : null,
      serviceId: json['service_id'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['provider_address_id'] = providerAddressId;
    data['service_id'] = serviceId;
    if (createdAt != null) {
      data['created_at'] = createdAt;
    }
    if (providerAddressMapping != null) {
      data['provider_address_mapping'] = providerAddressMapping!.toJson();
    }
    if (updatedAt != null) {
      data['updated_at'] = updatedAt;
    }
    return data;
  }
}

class Zones {
  int? id;
  String? name;

  Zones({
    this.id,
    this.name,
  });

  factory Zones.fromJson(Map<String, dynamic> json) {
    return Zones(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}

class ProviderAddressMapping {
  String? address;
  String? createdAt;
  int? id;
  String? latitude;
  String? longitude;
  int? providerId;
  var status;
  String? updatedAt;

  ProviderAddressMapping({this.address, this.createdAt, this.id, this.latitude, this.longitude, this.providerId, this.status, this.updatedAt});

  factory ProviderAddressMapping.fromJson(Map<String, dynamic> json) {
    return ProviderAddressMapping(
      address: json['address'],
      createdAt: json['created_at'],
      id: json['id'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      providerId: json['provider_id'],
      status: json['status'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['address'] = address;
    data['created_at'] = createdAt;
    data['id'] = id;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['provider_id'] = providerId;
    data['status'] = status;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class Provider {
  String? address;
  int? cityId;
  String? cityName;
  String? contactNumber;
  int? countryId;
  String? createdAt;
  String? description;
  String? displayName;
  String? email;
  String? firstName;
  int? id;
  int? isFeatured;
  String? lastName;
  String? lastNotificationSeen;
  String? loginType;
  String? profileImage;
  var providerId;
  String? providerType;
  var providerTypeId;
  var serviceAddressId;
  int? stateId;
  int? status;
  String? timeZone;
  var uid;
  String? updatedAt;
  String? userType;
  String? username;

  Provider({
    this.address,
    this.cityId,
    this.cityName,
    this.contactNumber,
    this.countryId,
    this.createdAt,
    this.description,
    this.displayName,
    this.email,
    this.firstName,
    this.id,
    this.isFeatured,
    this.lastName,
    this.lastNotificationSeen,
    this.loginType,
    this.profileImage,
    this.providerId,
    this.providerType,
    this.providerTypeId,
    this.serviceAddressId,
    this.stateId,
    this.status,
    this.timeZone,
    this.uid,
    this.updatedAt,
    this.userType,
    this.username,
  });

  factory Provider.fromJson(Map<String, dynamic> json) {
    return Provider(
      address: json['address'],
      cityId: json['city_id'],
      cityName: json['city_name'],
      contactNumber: json['contact_number'],
      countryId: json['country_id'],
      createdAt: json['created_at'],
      description: json['description'],
      displayName: json['display_name'],
      email: json['email'],
      firstName: json['first_name'],
      id: json['id'],
      isFeatured: json['is_featured'],
      lastName: json['last_name'],
      lastNotificationSeen: json['last_notification_seen'],
      loginType: json['login_type'],
      profileImage: json['profile_image'],
      providerId: json['provider_id'],
      providerType: json['providertype'],
      providerTypeId: json['providertype_id'],
      serviceAddressId: json['service_address_id'],
      stateId: json['state_id'],
      status: json['status'],
      timeZone: json['time_zone'],
      uid: json['uid'],
      updatedAt: json['updated_at'],
      userType: json['user_type'],
      username: json['username'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['address'] = address;
    data['city_id'] = cityId;
    data['city_name'] = cityName;
    data['contact_number'] = contactNumber;
    data['country_id'] = countryId;
    data['created_at'] = createdAt;
    data['display_name'] = displayName;
    data['email'] = email;
    data['first_name'] = firstName;
    data['id'] = id;
    data['is_featured'] = isFeatured;
    data['last_name'] = lastName;
    data['last_notification_seen'] = lastNotificationSeen;
    data['profile_image'] = profileImage;
    data['providertype'] = providerType;
    data['providertype_id'] = providerTypeId;
    data['state_id'] = stateId;
    data['status'] = status;
    data['time_zone'] = timeZone;
    data['updated_at'] = updatedAt;
    data['user_type'] = userType;
    data['username'] = username;
    if (description != null) {
      data['description'] = description;
    }
    if (loginType != null) {
      data['login_type'] = loginType;
    }
    if (providerId != null) {
      data['provider_id'] = providerId;
    }
    if (serviceAddressId != null) {
      data['service_address_id'] = serviceAddressId.toJson();
    }
    if (uid != null) {
      data['uid'] = uid.toJson();
    }
    return data;
  }
}

class ProviderZonesMapping {
  int? id;
  String? name;

  ProviderZonesMapping({this.id, this.name});

  factory ProviderZonesMapping.fromJson(Map<String, dynamic> json) {
    return ProviderZonesMapping(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;

    return data;
  }
}

class ServiceFaq {
  String? createdAt;
  String? description;
  int? id;
  int? serviceId;
  int? status;
  String? title;
  String? updatedAt;

  ServiceFaq({this.createdAt, this.description, this.id, this.serviceId, this.status, this.title, this.updatedAt});

  factory ServiceFaq.fromJson(Map<String, dynamic> json) {
    return ServiceFaq(
      createdAt: json['created_at'],
      description: json['description'],
      id: json['id'],
      serviceId: json['service_id'],
      status: json['status'],
      title: json['title'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['created_at'] = createdAt;
    data['description'] = description;
    data['id'] = id;
    data['service_id'] = serviceId;
    data['status'] = status;
    data['title'] = title;
    data['updated_at'] = updatedAt;
    return data;
  }
}