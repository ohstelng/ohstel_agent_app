import 'package:flutter/cupertino.dart';

class LaundryBookingModel {
  String clothTypes; // either shirt trouser etc

  /// LaundryModeAndPrice is a Map is key laundryMode (e.g wash only  or wash and Iron) corresponding to a value Price(i.e the price for that particular laundryMode)
  /// Example: {wash only = 500, wash and Iron = 600}
  /// this is how the clothes will be washed which are 1. wash only 2. wash and Iron 3. dry clean
  Map laundryModeAndPrice;
  String imageUrl;

  LaundryBookingModel({
    @required this.clothTypes,
    @required this.laundryModeAndPrice,
    @required this.imageUrl,
  });

  LaundryBookingModel.fromMap(Map<String, dynamic> mapData) {
    this.clothTypes = mapData['clothTypes'];
    this.laundryModeAndPrice = mapData['laundryModeAndPrice'];
    this.imageUrl = mapData['imageUrl'];
  }

  Map toMap() {
    Map<String, dynamic> data = Map<String, dynamic>();
    data['clothTypes'] = this.clothTypes;
    data['laundryModeAndPrice'] = this.laundryModeAndPrice;
    data['imageUrl'] = this.imageUrl;

    return data;
  }
}
