import 'package:flutter/cupertino.dart';

class FastFoodModel {
  String fastFoodName;
  String address;
  String openTime;
  String logoImageUrl;
  List itemDetails;
  List extraItems;
  List itemCategoriesList;
  bool hasBatchTime;
  bool haveExtras;
  bool toDisplay;
//  String locationName;
  bool display;
  String foodFastLocation;
  String stateLocation;
  String mainArea;

  FastFoodModel({
    @required this.fastFoodName,
    @required this.address,
    @required this.openTime,
    @required this.logoImageUrl,
    @required this.itemDetails,
    @required this.extraItems,
    @required this.itemCategoriesList,
    @required this.hasBatchTime,
    @required this.haveExtras,
//    @required this.locationName,
    @required this.foodFastLocation,
    @required this.stateLocation,
    @required this.mainArea,
    this.display,
    this.toDisplay,
  });

  FastFoodModel.fromMap(Map<String, dynamic> mapData) {
    this.fastFoodName = mapData['fastFood'];
    this.address = mapData['address'];
    this.openTime = mapData['openTime'];
    this.logoImageUrl = mapData['logoImageUrl'];
    this.itemDetails = mapData['itemDetails'];
    this.extraItems = mapData['extraItems'];
    this.itemCategoriesList = mapData['itemCategoriesList'];
    this.hasBatchTime = mapData['hasBatchTime'];
    this.haveExtras = mapData['haveExtras'];
    this.toDisplay = mapData['toDisplay'];
//    this.locationName = mapData['locationName'];
    this.foodFastLocation = mapData['foodFastLocation'];
    this.stateLocation = mapData['stateLocation'];
    this.mainArea = mapData['mainArea'];
    this.display = mapData['display'];
  }

  Map toMap() {
    Map data = Map<String, dynamic>();
    data['fastFood'] = this.fastFoodName;
    data['address'] = this.address;
    data['openTime'] = this.openTime;
    data['logoImageUrl'] = this.logoImageUrl;
    data['itemDetails'] = this.itemDetails;
    data['extraItems'] = this.extraItems;
    data['itemCategoriesList'] = this.itemCategoriesList;
    data['hasBatchTime'] = this.hasBatchTime;
    data['haveExtras'] = this.haveExtras;
    data['toDisplay'] = true;
//    data['locationName'] = this.locationName;
    data['foodFastLocation'] = this.foodFastLocation;
    data['stateLocation'] = this.stateLocation;
    data['mainArea'] = this.mainArea;
    data['display'] = this.display;

    return data;
  }
}
