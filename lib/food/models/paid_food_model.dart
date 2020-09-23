import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PaidFood {
  Timestamp timestamp;
  String phoneNumber;
  String email;
  String address;
  List<String> fastFoodNames;
  List<Map> orders;
  String uniName;

  // this will be a map of area name and address
  Map addressDetails;

  PaidFood({
    @required this.address,
    @required this.phoneNumber,
    @required this.email,
    @required this.fastFoodNames,
    @required this.orders,
    @required this.uniName,
    @required this.addressDetails,
  });

  PaidFood.fromMap(Map<String, dynamic> mapData) {
    this.timestamp = mapData['timestamp'];
    this.phoneNumber = mapData['phoneNumber'];
    this.fastFoodNames = mapData['fastFoodName'];
    this.email = mapData['email'];
    this.address = mapData['address'];
    this.orders = mapData['orders'];
    this.uniName = mapData['uniName'];
    this.addressDetails = mapData['addressDetails'];
  }

  Map toMap() {
    Map<String, dynamic> data = Map<String, dynamic>();
    data['timestamp'] = Timestamp.now();
    data['address'] = this.address;
    data['phoneNumber'] = this.phoneNumber;
    data['fastFoodName'] = this.fastFoodNames;
    data['email'] = this.email;
    data['orders'] = this.orders;
    data['uniName'] = this.uniName;
    data['addressDetails'] = this.addressDetails;

    return data;
  }
}

class EachOrder {
  String fastFoodName;
  String mainItem;
  List<String> extraItems;
  int numberOfPlates;

  EachOrder({
    @required this.fastFoodName,
    @required this.mainItem,
    @required this.extraItems,
    @required this.numberOfPlates,
  });

  EachOrder.fromMap(Map<String, dynamic> mapData) {
    this.mainItem = mapData['mainItem'];
    this.fastFoodName = mapData['fastFoodName'];
    this.extraItems = mapData['extraItems'];
    this.numberOfPlates = mapData['numberOfPlates'];
  }

  Map toMap() {
    Map data = Map<String, dynamic>();
    data['fastFoodName'] = this.fastFoodName;
    data['mainItem'] = this.mainItem;
    data['extraItems'] = this.extraItems;
    data['numberOfPlates'] = this.numberOfPlates;

    return data;
  }
}
