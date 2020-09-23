import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class PaidHostelModel {
  String fullName;
  String phoneNumber;
  String email;
  int price;
  String id;
  Map hostelDetails;
  Timestamp timestamp;
  bool isClaimed;

  PaidHostelModel({
    @required this.fullName,
    @required this.phoneNumber,
    @required this.email,
    @required this.price,
    @required this.id,
    @required this.hostelDetails,
  });

  PaidHostelModel.fromMap(Map<String, dynamic> mapData) {
    this.fullName = mapData['fullName'];
    this.phoneNumber = mapData['phoneNumber'];
    this.email = mapData['email'];
    this.price = mapData['price'];
    this.id = mapData['id'];
    this.hostelDetails = mapData['hostelDetails'];
    this.timestamp = mapData['timestamp'];
    this.timestamp = mapData['timestamp'];
    this.isClaimed = mapData['isClaimed'];
  }

  Map toMap() {
    Map data = Map<String, dynamic>();
    data['fullName'] = this.fullName;
    data['phoneNumber'] = this.phoneNumber;
    data['email'] = this.email;
    data['price'] = this.price;
    data['id'] = this.id;
    data['isClaimed'] = false;
    data['hostelDetails'] = this.hostelDetails;
    data['timestamp'] = Timestamp.now();

    return data;
  }
}
