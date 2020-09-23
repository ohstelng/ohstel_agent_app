import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class HostelBookingInspectionModel {
  String fullName;
  String phoneNumber;
  String email;
  String date;
  String time;
  String id;
  Map hostelDetails;
  bool inspectionMade;
  Timestamp timestamp;

  HostelBookingInspectionModel({
    @required this.fullName,
    @required this.phoneNumber,
    @required this.email,
    @required this.date,
    @required this.time,
    @required this.id,
    @required this.hostelDetails,
  });

  HostelBookingInspectionModel.fromMap(Map<String, dynamic> mapData) {
    this.fullName = mapData['fullName'];
    this.phoneNumber = mapData['phoneNumber'];
    this.email = mapData['email'];
    this.date = mapData['date'];
    this.time = mapData['time'];
    this.id = mapData['id'];
    this.inspectionMade = mapData['inspectionMade'];
    this.hostelDetails = mapData['hostelDetails'];
    this.timestamp = mapData['timestamp'];
  }

  Map toMap() {
    Map data = Map<String, dynamic>();
    data['fullName'] = this.fullName;
    data['phoneNumber'] = this.phoneNumber;
    data['email'] = this.email;
    data['date'] = this.date;
    data['time'] = this.time;
    data['id'] = this.id;
    data['hostelDetails'] = this.hostelDetails;
    data['inspectionMade'] = false;
    data['timestamp'] = Timestamp.now();

    return data;
  }
}
