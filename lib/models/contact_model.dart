import 'package:cloud_firestore/cloud_firestore.dart';

class ContactModel {
  String? uid;
  Timestamp? addedOn;

  ContactModel({this.uid, this.addedOn});

  factory ContactModel.fromJson(Map<String, dynamic> json) {
    return ContactModel(
      uid: json['uid'],
      addedOn: json['addedOn'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['uid'] = uid;
    data['addedOn'] = addedOn;

    return data;
  }
}
