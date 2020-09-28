import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';

class ProductModel {
  String productName;
  List imageUrls;
  String productCategory;
  String productOriginLocation;
  String productSubCategory;
  String productDescription;
  int productPrice;
  String productShopName;
  String productShopOwnerEmail;
  int productShopOwnerPhoneNumber;
  Timestamp dateAdded;
  List searchKeys;
  List sizeInfo;
  String id = Uuid().v1().toString();

  ProductModel({
    @required this.productName,
    @required this.imageUrls,
    @required this.productCategory,
    @required this.productOriginLocation,
    @required this.productDescription,
    @required this.productSubCategory,
    @required this.productPrice,
    @required this.productShopName,
    @required this.productShopOwnerEmail,
    @required this.productShopOwnerPhoneNumber,
    this.sizeInfo,
  });

  ProductModel.fromMap(Map<String, dynamic> mapData) {
    this.productName = mapData['productName'];
//    this.imageUrls = mapData['imageUrls'].cast<String>();
    this.imageUrls = mapData['imageUrls'] == null
        ? mapData['imageUrls']
        : mapData['imageUrls'].cast<String>();
    this.productCategory = mapData['productCategory'];
    this.productOriginLocation = mapData['productOriginLocation'];
    this.productSubCategory = mapData['productSubCategory'];
    this.productDescription = mapData['productDescription'];
    this.productPrice = mapData['productPrice'];
    this.productShopName = mapData['productShopName'];
    this.productShopOwnerEmail = mapData['productShopOwnerEmail'];
    this.productShopOwnerPhoneNumber =
        int.parse(mapData['productShopOwnerPhoneNumber']);
    this.dateAdded = mapData['dateAdded'];
    this.id = mapData['id'];
    this.sizeInfo = mapData['sizeInfo'];
    this.searchKeys = mapData['searchKeys'].cast<String>();
  }

  Map toMap() {
    Map data = Map<String, dynamic>();
    List _searchKeys = [];

    String prodCat = this.productCategory.toLowerCase();
    var prodNames = this.productName.split(' ');
    String prodshopOwnerName = this.productShopName.toLowerCase();
    String prodSubCat = this.productSubCategory.toLowerCase();

    _searchKeys.add(prodCat);
    _searchKeys.add(prodshopOwnerName);
    _searchKeys.add(prodSubCat.toLowerCase());
    prodNames.forEach((element) {
      _searchKeys.add(element.toLowerCase());
    });

    data['productName'] = this.productName.toLowerCase();
    data['imageUrls'] = this.imageUrls;
    data['productCategory'] = this.productCategory.toLowerCase();
    data['productOriginLocation'] = this.productOriginLocation.toLowerCase();
    data['productSubCategory'] = this.productSubCategory.toLowerCase();
    data['productDescription'] = this.productDescription.toLowerCase();
    data['productShopName'] = this.productShopName.toLowerCase();
    data['productShopOwnerEmail'] = this.productShopOwnerEmail;
    data['productShopOwnerPhoneNumber'] =
        this.productShopOwnerPhoneNumber.toString();
    data['productPrice'] = this.productPrice;
    data['dateAdded'] = Timestamp.now();
    data['id'] = this.id;
    data['searchKeys'] = _searchKeys;
    data['hasSize'] = this.sizeInfo;

    return data;
  }
}

