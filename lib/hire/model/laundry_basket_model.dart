import 'package:flutter/cupertino.dart';

class LaundryBookingBasketModel {
  String clothTypes; // either shirt trouser etc
  String laundryPersonName;
  String laundryPersonEmail;
  String laundryPersonUniName;
  String laundryPersonPhoneNumber;
  String imageUrl;
  int units;
  int price;
  String laundryMode;

  LaundryBookingBasketModel({
    @required this.clothTypes,
    @required this.imageUrl,
    @required this.units,
    @required this.laundryMode,
    @required this.price,
    @required this.laundryPersonName,
    @required this.laundryPersonEmail,
    @required this.laundryPersonUniName,
    @required this.laundryPersonPhoneNumber,
  });

  LaundryBookingBasketModel.fromMap(Map<String, dynamic> mapData) {
    this.clothTypes = mapData['clothTypes'];
    this.imageUrl = mapData['imageUrl'];
    this.units = mapData['units'];
    this.laundryMode = mapData['laundryMode'];
    this.price = mapData['price'];
    this.laundryPersonName = mapData['laundryPersonName'];
    this.laundryPersonEmail = mapData['laundryPersonEmail'];
    this.laundryPersonUniName = mapData['laundryPersonUniName'];
    this.laundryPersonPhoneNumber = mapData['laundryPersonPhoneNumber'];
  }

  Map toMap() {
    Map<String, dynamic> data = Map<String, dynamic>();
    data['clothTypes'] = this.clothTypes;
    data['units'] = this.units;
    data['imageUrl'] = this.imageUrl;
    data['laundryMode'] = this.laundryMode;
    data['price'] = this.price;
    data['laundryPersonName'] = this.laundryPersonName;
    data['laundryPersonEmail'] = this.laundryPersonEmail;
    data['laundryPersonUniName'] = this.laundryPersonUniName;
    data['laundryPersonPhoneNumber'] = this.laundryPersonPhoneNumber;

    return data;
  }
}
