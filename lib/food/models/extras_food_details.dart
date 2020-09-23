import 'package:flutter/cupertino.dart';

class ExtraItemDetails {
  String extraItemName;
  String shortDescription;
  String imageUrl;
  int price;
  String extraItemFastFoodName;
  String extraCategory;

  ExtraItemDetails({
    @required this.extraItemName,
    @required this.shortDescription,
    @required this.imageUrl,
    @required this.price,
    @required this.extraItemFastFoodName,
    @required this.extraCategory,
  });

  ExtraItemDetails.fromMap(Map<String, dynamic> mapData) {
    this.extraItemName = mapData['extraItemName'];
    this.shortDescription = mapData['shortDescription'];
    this.imageUrl = mapData['imageUrl'];
    this.price = mapData['price'];
    this.extraItemFastFoodName = mapData['extraItemFastFoodName'];
    this.extraCategory = mapData['extraCategory'];
  }

  Map toMap() {
    Map data = Map<String, dynamic>();
    data['extraItemName'] = this.extraItemName;
    data['shortDescription'] = this.shortDescription;
    data['imageUrl'] = this.imageUrl;
    data['price'] = this.price;
    data['extraItemFastFoodName'] = this.extraItemFastFoodName;
    data['extraCategory'] = this.extraCategory;
    return data;
  }
}


