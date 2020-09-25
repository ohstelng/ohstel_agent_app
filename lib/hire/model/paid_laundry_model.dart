import 'package:flutter/cupertino.dart';

class PaidLaundryBookingModel {
  String clothesOwnerName;
  String clothesOwnerEmail;
  String clothesOwnerPhoneNumber;
  Map clothesOwnerAddressDetails;
  List listOfLaundry;

  PaidLaundryBookingModel({
    @required this.clothesOwnerName,
    @required this.clothesOwnerEmail,
    @required this.clothesOwnerAddressDetails,
    @required this.clothesOwnerPhoneNumber,
    @required this.listOfLaundry,
  });

  PaidLaundryBookingModel.fromMap(Map<String, dynamic> mapData) {
    this.clothesOwnerName = mapData['clothesOwnerName'];
    this.clothesOwnerEmail = mapData['clothesOwnerEmail'];
    this.clothesOwnerAddressDetails = mapData['clothesOwnerAddressDetails'];
    this.clothesOwnerPhoneNumber = mapData['clothesOwnerPhoneNumber'];
    this.listOfLaundry = mapData['listOfLaundry'];
  }

  Map toMap() {
    Map<String, dynamic> data = Map<String, dynamic>();
    data['clothesOwnerName'] = this.clothesOwnerName;
    data['clothesOwnerAddressDetails'] = this.clothesOwnerAddressDetails;
    data['clothesOwnerEmail'] = this.clothesOwnerEmail;
    data['clothesOwnerPhoneNumber'] = this.clothesOwnerPhoneNumber;
    data['listOfLaundry'] = this.listOfLaundry;

    return data;
  }
}
