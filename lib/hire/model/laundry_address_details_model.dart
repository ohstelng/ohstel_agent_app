import 'package:flutter/cupertino.dart';

class LaundryAddressDetailsModel {
  String pickUpDate; // either shirt trouser etc
  String pickUpTime;
  Map pickUpAddress;
  Map dropOffAddress;
  String pickUpNumber;
  String dropOffNumber;

  LaundryAddressDetailsModel({
    @required this.pickUpDate,
    @required this.pickUpTime,
    @required this.pickUpAddress,
    @required this.dropOffAddress,
    @required this.pickUpNumber,
    @required this.dropOffNumber,
  });

  LaundryAddressDetailsModel.fromMap(Map<String, dynamic> mapData) {
    this.pickUpDate = mapData['pickUpDate'];
    this.pickUpTime = mapData['pickUpTime'];
    this.pickUpAddress = mapData['pickUpAddress'];
    this.dropOffAddress = mapData['dropOffAddress'];
    this.pickUpNumber = mapData['pickUpNumber'];
    this.dropOffNumber = mapData['dropOffNumber'];
  }

  Map toMap() {
    Map<String, dynamic> data = Map<String, dynamic>();
    data['pickUpDate'] = this.pickUpDate;
    data['pickUpTime'] = this.pickUpTime;
    data['pickUpAddress'] = this.pickUpAddress;
    data['dropOffAddress'] = this.dropOffAddress;
    data['pickUpNumber'] = this.pickUpNumber;
    data['dropOffNumber'] = this.dropOffNumber;

    return data;
  }
}
