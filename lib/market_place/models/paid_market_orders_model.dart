import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class PaidOrderModel {
  String buyerFullName;
  String buyerEmail;
  String buyerPhoneNumber;
  String buyerAddress;
  String buyerID;
  int amountPaid;
  Timestamp timestamp;
  List listOfShopsPurchasedFrom;
  List orders;
  String id = Uuid().v1().toString();

  PaidOrderModel({
    @required this.buyerFullName,
    @required this.buyerEmail,
    @required this.buyerPhoneNumber,
    @required this.buyerAddress,
    @required this.buyerID,
    @required this.amountPaid,
    @required this.listOfShopsPurchasedFrom,
    @required this.orders,
  });

  PaidOrderModel.fromMap(Map<String, dynamic> mapData) {
    this.buyerFullName = mapData['buyerFullName'];
    this.buyerEmail = mapData['buyerEmail'];
    this.buyerPhoneNumber = mapData['buyerPhoneNumber'];
    this.buyerAddress = mapData['buyerAddress'];
    this.buyerID = mapData['buyerID'];
    this.amountPaid = mapData['amountPaid'];
    this.timestamp = mapData['timestamp'];
    this.listOfShopsPurchasedFrom = mapData['listOfShopsPurchasedFrom'];
    this.orders = mapData['orders'];
    this.id = mapData['id'];
  }

  Map toMap() {
    Map data = Map<String, dynamic>();
    data['buyerFullName'] = this.buyerFullName;
    data['buyerEmail'] = this.buyerEmail;
    data['buyerPhoneNumber'] = this.buyerPhoneNumber;
    data['buyerAddress'] = this.buyerAddress;
    data['buyerID'] = this.buyerID;
    data['amountPaid'] = this.amountPaid;
    data['timestamp'] = Timestamp.now();
    data['listOfShopsPurchasedFrom'] = this.listOfShopsPurchasedFrom;
    data['orders'] = this.orders;
    data['id'] = this.id;

    return data;
  }
}

class EachPaidOrderModel {
  String productName;
  List<String> imageUrls;
  String productCategory;
  int productPrice;
  String deliveryStatus;
  String productShopName;
  String productShopOwnerEmail;
  String size;
  int productShopOwnerPhoneNumber;
  int units;

  EachPaidOrderModel({
    @required this.productName,
    @required this.imageUrls,
    @required this.productCategory,
    @required this.productPrice,
    @required this.productShopName,
    @required this.productShopOwnerEmail,
    @required this.productShopOwnerPhoneNumber,
    @required this.units,
    @required this.size,
  });

  EachPaidOrderModel.fromMap(Map<String, dynamic> mapData) {
    this.productName = mapData['productName'];
    this.imageUrls = mapData['imageUrls'].cast<String>();
    this.productCategory = mapData['productCategory'];
    this.productPrice = mapData['productPrice'];
    this.deliveryStatus = mapData['deliveryStatus'];
    this.productShopName = mapData['productShopName'];
    this.productShopOwnerEmail = mapData['productShopOwnerEmail'];
    this.units = mapData['units'];
    this.productShopOwnerPhoneNumber =
        int.parse(mapData['productShopOwnerPhoneNumber']);
    this.size = mapData['size'];
  }

  Map toMap() {
    Map data = Map<String, dynamic>();

    data['productName'] = this.productName.toLowerCase();
    data['imageUrls'] = this.imageUrls;
    data['productCategory'] = this.productCategory.toLowerCase();
    data['productShopName'] = this.productShopName.toLowerCase();
    data['productShopOwnerEmail'] = this.productShopOwnerEmail;
    data['deliveryStatus'] = 'Awaiting Dispatch';
    data['units'] = this.units;
    data['size'] = this.size;
    data['productShopOwnerPhoneNumber'] =
        this.productShopOwnerPhoneNumber.toString();
    data['productPrice'] = this.productPrice;

    return data;
  }
}
