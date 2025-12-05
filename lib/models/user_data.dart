import 'dart:convert';

import 'package:handyman_provider_flutter/models/provider_subscription_model.dart';
import 'package:nb_utils/nb_utils.dart';

class UserData {
  int? id;
  String? uid;
  String? username;
  String? firstName;
  String? lastName;
  String? email;
  String? emailVerifiedAt;
  String? userType;
  String? contactNumber;
  int? countryId;
  int? stateId;
  int? cityId;
  String? address;
  int? providerId;
  String? playerId;
  int? status;
  int? providertypeId;
  int? isFeatured;
  String? displayName;
  String? timeZone;
  String? lastNotificationSeen;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  String? apiToken;
  String? profileImage;
  String? description;
  String? knownLanguages;
  String? whyChooseMe;
  String? skills;
  int? serviceAddressId;
  num? handymanRating;
  int? isSubscribe;
  String? designation;
  String? password;
  String? cityName;
  num? providerServiceRating;
  String? providerType;
  bool? isHandymanAvailable;
  String? loginType;
  int? handymanCommissionId;
  String? handymanType;
  String? handymanCommission;
  num? slotsForAllServices;
  int? isOnline;
  List<String>? userRole;
  ProviderSubscriptionModel? subscription;

  int? isEmailVerified;

  int? isVerifiedAccount;
  int? totalBooking;

  //Handyman Data
  String? handymanImage;
  int? isVerifiedHandyman;

  //Local
  bool isSelected = false;
  bool isActive = false;

  int? handymanZoneID;

  bool get isUserActive => status == 0;

  ///  This is to check if the provider's all services have time slot or not.
  bool get isSlotsForAllServices => slotsForAllServices == 1;

  List<String> get knownLanguagesArray => buildKnownLanguages();

  List<String> get skillsArray => buildSkills();

  List<String> buildKnownLanguages() {
    final List<String> array = [];
    final String tempLanguages = knownLanguages.validate();
    if (tempLanguages.isNotEmpty && tempLanguages.isJson()) {
      final Iterable it1 = jsonDecode(knownLanguages.validate());
      array.addAll(it1.map((e) => e.toString()).toList());
    }

    return array;
  }

  List<String> buildSkills() {
    final List<String> array = [];
    final String tempSkills = skills.validate();
    if (tempSkills.isNotEmpty && tempSkills.isJson()) {
      final Iterable it2 = jsonDecode(skills.validate());
      array.addAll(it2.map((e) => e.toString()).toList());
    }

    return array;
  }

  WhyChooseMe get whyChooseMeObj => buildWhyChooseMe();

  WhyChooseMe buildWhyChooseMe() {
    WhyChooseMe obj = WhyChooseMe();
    final String tempWhyChooseMe = whyChooseMe.validate();
    if (tempWhyChooseMe.isNotEmpty && tempWhyChooseMe.isJson()) {
      try {
        obj = WhyChooseMe.fromJson(jsonDecode(tempWhyChooseMe));
      } catch (e) {
        print("Error parsing WhyChooseMe: $e");
      }
    }

    return obj;
  }

  UserData({
    this.id,
    this.username,
    this.firstName,
    this.lastName,
    this.email,
    this.emailVerifiedAt,
    this.userType,
    this.contactNumber,
    this.countryId,
    this.providerServiceRating,
    this.stateId,
    this.cityId,
    this.address,
    this.providerId,
    this.playerId,
    this.slotsForAllServices,
    this.status,
    this.providertypeId,
    this.isFeatured,
    this.displayName,
    this.timeZone,
    this.lastNotificationSeen,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.userRole,
    this.apiToken,
    this.profileImage,
    this.description,
    this.knownLanguages,
    this.whyChooseMe,
    this.skills,
    this.serviceAddressId,
    this.handymanRating,
    this.subscription,
    this.isSubscribe,
    this.uid,
    this.designation,
    this.cityName,
    this.providerType,
    this.handymanType,
    this.handymanCommissionId,
    this.handymanCommission,
    this.isHandymanAvailable,
    this.loginType,
    this.isEmailVerified,
    this.isVerifiedAccount = 0,
    this.totalBooking,
    this.handymanImage,
    this.isVerifiedHandyman = 0,
    this.handymanZoneID,
  });

  UserData.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString().toInt();
    username = json['username'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    slotsForAllServices = json['slots_for_all_services'] ?? 0;
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    providerServiceRating = json['providers_service_rating'];
    isOnline = json['isOnline'];
    userType = json['user_type'];
    contactNumber = json['contact_number'];
    countryId = json['country_id'];
    stateId = json['state_id'];
    cityId = json['city_id'];
    address = json['address'];
    providerId = json['provider_id'];
    playerId = json['player_id'];
    status = json['status'];
    isActive = status == 1;
    serviceAddressId = json['service_address_id'];
    handymanRating = json['handyman_rating'];
    isFeatured = json['is_featured'];
    displayName = json['display_name'];
    timeZone = json['time_zone'];
    lastNotificationSeen = json['last_notification_seen'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    apiToken = json['api_token'];
    profileImage = json['profile_image'];
    description = json['description'];
    knownLanguages = json['known_languages'];
    whyChooseMe = json['why_choose_me'];
    skills = json['skills'];
    uid = json['uid'];
    subscription = json['subscription'] != null ? ProviderSubscriptionModel.fromJson(json['subscription']) : null;
    isSubscribe = json['is_subscribe'];
    designation = json['designation'];
    cityName = json['city_name'];
    providerType = json['providertype'];
    handymanCommissionId = json['handymantype_id'];
    handymanType = json['handyman_type'];
    handymanCommission = json['handyman_commission'];
    isHandymanAvailable = json['isHandymanAvailable'] != null ? json['isHandymanAvailable'] == 1 : false;
    loginType = json['login_type'];
    isEmailVerified = json['is_email_verified'];
    isVerifiedAccount = json['is_verify_provider'] is int ? json['is_verify_provider'] : 0;
    totalBooking = json['total_services_booked'];
    handymanImage = json['handyman_image'];
    isVerifiedHandyman = json['is_verified'];
    handymanZoneID = json['handyman_zone_id'] is int ? json['handyman_zone_id'] : -1;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (id != null) data['id'] = id;
    if (slotsForAllServices != null) data['slots_for_all_services'] = slotsForAllServices;
    if (username != null) data['username'] = username;
    if (firstName != null) data['first_name'] = firstName;
    if (lastName != null) data['last_name'] = lastName;
    if (email != null) data['email'] = email;
    if (providerServiceRating != null) data['providers_service_rating'] = providerServiceRating;
    if (serviceAddressId != null) data['service_address_id'] = serviceAddressId;
    if (handymanRating != null) data['handyman_rating'] = handymanRating;
    if (emailVerifiedAt != null) data['email_verified_at'] = emailVerifiedAt;
    if (userType != null) data['user_type'] = userType;
    if (contactNumber != null) data['contact_number'] = contactNumber;
    if (countryId != null) data['country_id'] = countryId;
    if (isOnline != null) data['isOnline'] = isOnline;
    if (handymanType != null) data['handyman_type'] = handymanType;
    if (handymanCommission != null) data['handyman_commission'] = handymanCommission;
    if (stateId != null) data['state_id'] = stateId;
    if (cityId != null) data['city_id'] = cityId;
    if (address != null) data['address'] = address;
    if (providerId != null) data['provider_id'] = providerId;
    if (playerId != null) data['player_id'] = playerId;
    if (status != null) data['status'] = status;
    if (providertypeId != null) data['providertype_id'] = providertypeId;
    if (isFeatured != null) data['is_featured'] = isFeatured;
    if (displayName != null) data['display_name'] = displayName;
    if (timeZone != null) data['time_zone'] = timeZone;
    if (lastNotificationSeen != null) data['last_notification_seen'] = lastNotificationSeen;
    if (createdAt != null) data['created_at'] = createdAt;
    if (updatedAt != null) data['updated_at'] = updatedAt;
    if (deletedAt != null) data['deleted_at'] = deletedAt;
    if (userRole != null) data['user_role'] = userRole;
    if (apiToken != null) data['api_token'] = apiToken;
    if (profileImage != null) data['profile_image'] = profileImage;
    if (description != null) data['description'] = description;
    if (knownLanguages != null) data['known_languages'] = knownLanguages;
    if (whyChooseMe != null) data['why_choose_me'] = whyChooseMe;
    if (skills != null) data['skills'] = skills;
    if (uid != null) data['uid'] = uid;
    if (isSubscribe != null) data['is_subscribe'] = isSubscribe;
    if (cityName != null) data['city_name'] = cityName;
    if (handymanCommissionId != null) data['handymantype_id'] = handymanCommissionId;
    if (providerType != null) data['providertype'] = providerType;
    if (isHandymanAvailable != null) data['isHandymanAvailable'] = isHandymanAvailable;
    if (loginType != null) data['login_type'] = loginType;
    if (isEmailVerified != null) data['is_email_verified'] = isEmailVerified;
    if (isVerifiedAccount != null) data['is_verify_provider'] = isVerifiedAccount;
    if (totalBooking != null) data['total_services_booked'] = totalBooking;
    if (handymanImage != null) data['handyman_image'] = handymanImage;
    if (isVerifiedHandyman != null) data['is_verified'] = isVerifiedHandyman;
    if (handymanZoneID != null) data['handyman_zone_id'] = handymanZoneID;

    if (subscription != null) {
      data['subscription'] = subscription!.toJson();
    }
    if (designation != null) data['designation'] = designation;
    return data;
  }

  Map<String, dynamic> toFirebaseJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (id != null) data['id'] = id;
    if (uid != null) data['uid'] = uid;
    if (firstName != null) data['first_name'] = firstName;
    if (lastName != null) data['last_name'] = lastName;
    if (email != null) data['email'] = email;
    if (profileImage != null) data['profile_image'] = profileImage;
    if (isOnline != null) data['isOnline'] = isOnline;
    if (updatedAt != null) data['updated_at'] = updatedAt;
    if (createdAt != null) data['created_at'] = createdAt;
    return data;
  }
}

class WhyChooseMe {
  String title;
  String aboutDescription;
  List<String> reason;

  WhyChooseMe({
    this.title = "",
    this.aboutDescription = "",
    this.reason = const <String>[],
  });

  factory WhyChooseMe.fromJson(Map<String, dynamic> json) {

    final dynamic rawReasons = json['reason'] ?? json['why_choose_me_reason'];
    return WhyChooseMe(
      title: (json['title'] ?? json['why_choose_me_title'] ?? "").toString(),
      aboutDescription: (json['about_description'] ?? "").toString(),
      reason: rawReasons is List ? List<String>.from(rawReasons.map((x) => x.toString())) : <String>[],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'why_choose_me_title': title,
      'why_choose_me_reason': reason.map((e) => e).toList(),
      'about_description': aboutDescription,
    };
  }
}