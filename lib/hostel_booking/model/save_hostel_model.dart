import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SavedHostelModel {
  String hostelID;
  Map userDetails;
  List hostelImageUrls;
  String hostelName;
  String hostelLocation;
  Timestamp timestamp;

  SavedHostelModel({
    @required this.hostelID,
    @required this.userDetails,
    @required this.hostelImageUrls,
    @required this.hostelName,
    @required this.hostelLocation,
  });

  SavedHostelModel.fromMap(Map<String, dynamic> mapData) {
    this.hostelID = mapData['hostelID'];
    this.userDetails = mapData['userDetails'];
    this.hostelImageUrls = mapData['hostelImageUrls'];
    this.hostelName = mapData['hostelName'];
    this.hostelLocation = mapData['hostelLocation'];
    this.timestamp = mapData['timestamp'];
  }

  Map toMap() {
    Map data = Map<String, dynamic>();

    data['hostelID'] = this.hostelID;
    data['userDetails'] = this.userDetails;
    data['hostelImageUrls'] = this.hostelImageUrls;
    data['hostelName'] = this.hostelName;
    data['hostelLocation'] = this.hostelLocation;
    data['timestamp'] = Timestamp.now();

    return data;
  }
}
