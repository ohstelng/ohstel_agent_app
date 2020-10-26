import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';

class HostelModel {
  String hostelName;
  String hostelNameForSearch;
  String hostelLocation;
  int price;
  String distanceFromSchoolInKm;
  String distanceTime;
  bool isRoomMateNeeded;
  int bedSpace;
  bool isSchoolHostel;
  String description;
  String extraFeatures;
  List<dynamic> imageUrl;
  int dateAdded;
  double ratings;
  String searchKey;
  String dormType;
  String uniName;
  String hostelAccommodationType;
  String landMark;
  String id = Uuid().v1().toString();

  HostelModel({
    @required this.hostelName,
    @required this.hostelLocation,
    @required this.price,
    @required this.distanceFromSchoolInKm,
    @required this.bedSpace,
    @required this.isSchoolHostel,
    @required this.description,
    @required this.distanceTime,
    @required this.extraFeatures,
    @required this.imageUrl,
    @required this.dormType,
    @required this.landMark,
    @required this.hostelAccommodationType,
    @required this.uniName,
  });

  HostelModel.fromMap(Map<String, dynamic> mapData) {
    this.hostelName = mapData['hostelName'];
    this.hostelNameForSearch = mapData['hostelNameForSearch'];
    this.hostelLocation = mapData['hostelLocation'];
    this.price = mapData['price'];
    this.distanceFromSchoolInKm = mapData['distanceFromSchoolInKm'].toString();
    this.distanceTime = mapData['distanceTime'];
    this.isRoomMateNeeded = mapData['isRoomMateNeeded'];
    this.bedSpace = mapData['bedSpace'];
    this.isSchoolHostel = mapData['isSchoolHostel'];
    this.description = mapData['description'];
    this.extraFeatures = mapData['extraFeatures'];
    this.imageUrl = mapData['imageUrl'];
    this.dateAdded = mapData['dateAdded'];
    this.ratings = mapData['ratings'];
    this.searchKey = mapData['searchKey'];
    this.dormType = mapData['hostelType'];
    this.landMark = mapData['landMark'];
    this.uniName = mapData['uniName'];
    this.hostelAccommodationType = mapData['hostelAccommodationType'];
    this.id = mapData['id'];
  }

  Map toMap() {
    Map data = Map<String, dynamic>();
    data['hostelName'] = this.hostelName;
    data['hostelNameForSearch'] = this.hostelNameForSearch;
    data['hostelLocation'] = this.hostelLocation;
    data['hostelLocation'] = this.hostelLocation;
    data['price'] = this.price;
    data['distanceFromSchoolInKm'] = this.distanceFromSchoolInKm;
    data['distanceTime'] = this.distanceTime;
    data['isRoomMateNeeded'] = false;
    data['bedSpace'] = this.bedSpace;
    data['isSchoolHostel'] = this.isSchoolHostel;
    data['description'] = this.description;
    data['extraFeatures'] = this.extraFeatures;
    data['imageUrl'] = this.imageUrl;
    data['uniName'] = this.uniName;
    data['dateAdded'] = Timestamp.now().microsecondsSinceEpoch;
    data['ratings'] = this.ratings;

    data['dormType'] = this.dormType;
    data['landMark'] = this.landMark;
    data['hostelAccommodationType'] = this.hostelAccommodationType;
//        'accoomdation type one room, self contain, 2 bedroom(for off campus) while two, three or 4 to a room(for school hoste)';

    data['searchKey'] = this.hostelName.toLowerCase()[0].toLowerCase();
    data['id'] = this.id;

    return data;
  }
}
