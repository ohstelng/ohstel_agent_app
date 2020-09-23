import 'package:flutter/cupertino.dart';

class UserModel{
  String uid;
  String email;
  String fullName;
  String userName;
  String schoolLocation;
  String phoneNumber;
  String uniName;

  UserModel({
    @required this.uid,
    @required this.email,
    @required this.fullName,
    @required this.userName,
    @required this.schoolLocation,
    @required this.phoneNumber,
    @required this.uniName,
});

  UserModel.fromMap(Map<String, dynamic> mapData){
    this.uid = mapData['uid'];
    this.email = mapData['email'];
    this.fullName = mapData['fullName'];
    this.userName = mapData['userName'];
    this.schoolLocation = mapData['schoolLocation'];
    this.phoneNumber = mapData['phoneNumber'];
    this.uniName = mapData['uniName'];
  }


}