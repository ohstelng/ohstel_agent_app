import 'package:flutter/cupertino.dart';

class ItemDetails {
  String itemName;
  String itemFastFoodName;
  String itemCategory;
  int price;
  String shortDescription;
  String imageUrl;

  ItemDetails({
    @required this.itemName,
    @required this.itemCategory,
    @required this.price,
    @required this.imageUrl,
    @required this.shortDescription,
    @required this.itemFastFoodName,
  });

  ItemDetails.formMap(Map<String, dynamic> mapData) {
    this.itemName = mapData['itemName'];
    this.itemCategory = mapData['itemCategory'];
    this.price = mapData['price'];
    this.imageUrl = mapData['imageUrl'];
    this.shortDescription = mapData['shortDescription'];
    this.itemFastFoodName = mapData['itemFastFoodName'];
  }

  Map toMap() {
    Map data = Map<String, dynamic>();
    data['itemName'] = this.itemName;
    data['itemCategory'] = this.itemCategory;
    data['price'] = this.price;
    data['imageUrl'] = this.imageUrl;
    data['shortDescription'] = this.shortDescription;
    data['itemFastFoodName'] = this.itemFastFoodName;
    return data;
  }
}
