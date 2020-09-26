//import 'package:Ohstel_app/hive_methods/hive_class.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:ohostel_hostel_agent_app/hive_methods/hive_class.dart';
import 'package:uuid/uuid.dart';

class PaidLaundryBookingModel {
  String clothesOwnerName;
  String clothesOwnerEmail;
  String clothesOwnerPhoneNumber;
  Map clothesOwnerAddressDetails;
  List listOfLaundry;
  List listOfLaundryShopsOrderedFrom;
  bool doneWith;
  String status;
  String id;
  Timestamp timestamp;

  PaidLaundryBookingModel({
    @required this.clothesOwnerName,
    @required this.clothesOwnerEmail,
    @required this.clothesOwnerAddressDetails,
    @required this.clothesOwnerPhoneNumber,
    @required this.listOfLaundry,
    @required this.listOfLaundryShopsOrderedFrom,
  });

  PaidLaundryBookingModel.fromMap(Map<String, dynamic> mapData) {
    this.clothesOwnerName = mapData['clothesOwnerName'];
    this.clothesOwnerEmail = mapData['clothesOwnerEmail'];
    this.clothesOwnerAddressDetails = mapData['clothesOwnerAddressDetails'];
    this.clothesOwnerPhoneNumber = mapData['clothesOwnerPhoneNumber'];
    this.listOfLaundry = mapData['listOfLaundry'];
    this.doneWith = mapData['doneWith'];
    this.status = mapData['status'];
    this.id = mapData['id'];
    this.timestamp = mapData['timestamp'];
    this.listOfLaundryShopsOrderedFrom =
        mapData['listOfLaundryShopsOrderedFrom'];
  }

  Future<Map> toMap() async {
    String uni = await HiveMethods().getUniName();
    Map<String, dynamic> data = Map<String, dynamic>();
    data['clothesOwnerName'] = this.clothesOwnerName;
    data['clothesOwnerAddressDetails'] = this.clothesOwnerAddressDetails;
    data['clothesOwnerEmail'] = this.clothesOwnerEmail;
    data['clothesOwnerPhoneNumber'] = this.clothesOwnerPhoneNumber;
    data['listOfLaundry'] = this.listOfLaundry;
    data['listOfLaundryShopsOrderedFrom'] = this.listOfLaundryShopsOrderedFrom;
    data['timestamp'] = Timestamp.now();
//    data['listOfLaundryShop'] = this.listOfLaundry;
    data['doneWith'] = false;
    data['id'] = Uuid().v1().toString();
    data['uniName'] = uni.toString();

    return data;
  }
}
