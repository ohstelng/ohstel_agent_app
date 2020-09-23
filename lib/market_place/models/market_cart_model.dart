import 'package:flutter/material.dart';

class MarketCartModel {
  String productName;
  List<String> imageUrls;
  String productCategory;
  String productSubCategory;
  String productOriginLocation;
  String productDescription;
  int productPrice;
  String productShopName;
  String productShopOwnerEmail;
  int productShopOwnerPhoneNumber;
  List<String> searchKeys;
  int units;

  MarketCartModel({
    @required this.productName,
    @required this.imageUrls,
    @required this.productCategory,
    @required this.productDescription,
    @required this.productOriginLocation,
    @required this.productSubCategory,
    @required this.productPrice,
    @required this.productShopName,
    @required this.productShopOwnerEmail,
    @required this.productShopOwnerPhoneNumber,
    @required this.units,
  });

  MarketCartModel.fromMap(Map<String, dynamic> mapData) {
    this.productName = mapData['productName'];
    this.imageUrls = mapData['imageUrls'].cast<String>();
    this.productCategory = mapData['productCategory'];
    this.productSubCategory = mapData['productSubCategory'];
    this.productOriginLocation = mapData['productOriginLocation'];
    this.productDescription = mapData['productDescription'];
    this.productPrice = mapData['productPrice'];
    this.productShopName = mapData['productShopName'];
    this.productShopOwnerEmail = mapData['productShopOwnerEmail'];
    this.units = mapData['units'];
    this.productShopOwnerPhoneNumber =
        int.parse(mapData['productShopOwnerPhoneNumber']);
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
    _searchKeys.add(prodSubCat);
    _searchKeys.addAll(prodNames);

    data['productName'] = this.productName.toLowerCase();
    data['imageUrls'] = this.imageUrls;
    data['productCategory'] = this.productCategory.toLowerCase();
    data['productSubCategory'] = this.productSubCategory.toLowerCase();
    data['productDescription'] = this.productDescription.toLowerCase();
    data['productShopName'] = this.productShopName.toLowerCase();
    data['productOriginLocation'] = this.productOriginLocation.toLowerCase();
    data['productShopOwnerEmail'] = this.productShopOwnerEmail;
    data['units'] = this.units;
    data['productShopOwnerPhoneNumber'] =
        this.productShopOwnerPhoneNumber.toString();
    data['productPrice'] = this.productPrice;
    data['searchKeys'] = _searchKeys;

    return data;
  }
}
