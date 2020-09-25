import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';

class HireWorkerModel {
  String workerName;
  String userName;
  String priceRange;
  String workType;
  String workerPhoneNumber;
  String workerEmail;
  String uniName;
  String about;
  String openTime;
  Timestamp dateJoined;
  String profileImageUrl;
  List searchKeys;
  List laundryList;

  HireWorkerModel({
    @required this.workerName,
    @required this.userName,
    @required this.workType,
    @required this.priceRange,
    @required this.workerPhoneNumber,
    @required this.workerEmail,
    @required this.uniName,
    @required this.profileImageUrl,
    @required this.about,
    @required this.openTime,
    @required this.laundryList,
  });

  HireWorkerModel.fromMap(Map<String, dynamic> mapData) {
    this.workerName = mapData['workerName'];
    this.userName = mapData['userName'];
    this.workType = mapData['workType'];
    this.workerPhoneNumber = mapData['workerPhoneNumber'];
    this.priceRange = mapData['priceRange'];
    this.workerEmail = mapData['workerEmail'];
    this.uniName = mapData['uniName'];
    this.dateJoined = mapData['dateJoined'];
    this.profileImageUrl = mapData['profileImageUrl'];
    this.searchKeys = mapData['searchKeys'];
    this.laundryList = mapData['laundryList'];
    this.about = mapData['about'];
    this.openTime = mapData['openTime'];
  }

  Map toMap() {
    Map<String, dynamic> data = Map<String, dynamic>();
    List<String> _searchKeys = [];
    _searchKeys.add(this.userName.toLowerCase());

    workerName.trim().split(' ').forEach((element) {
      _searchKeys.add(element.toLowerCase());
    });

    data['workerName'] = this.workerName.toLowerCase();
    data['userName'] = this.userName.toLowerCase();
    data['workType'] = this.workType.toLowerCase();
    data['workerPhoneNumber'] = this.workerPhoneNumber;
    data['priceRange'] = this.priceRange;
    data['workerEmail'] = this.workerEmail;
    data['uniName'] = this.uniName.toLowerCase();
    data['dateJoined'] = Timestamp.now();
    data['profileImageUrl'] = this.profileImageUrl;
    data['searchKeys'] = _searchKeys;
    data['laundryList'] = laundryList;
    data['openTime'] = this.openTime;
    data['about'] = this.about;
    data['id'] = Uuid().v1().toString();

    return data;
  }
}

//List<HireWorkerModel> list = [
//  HireWorkerModel(
//    workerName: 'Kristin Stephens',
//    userName: 'Stephens',
//    workerPhoneNumber: '08011223344',
//    workerEmail: 'workMan@gmail.com',
//    uniName: 'unilorin',
//    profileImageUrl: null,
//    workType: 'Laundry',
//  ),
//  HireWorkerModel(
//    workerName: 'Janet Garner',
//    userName: 'Janet',
//    workerPhoneNumber: '08011223344',
//    workerEmail: 'workMan@gmail.com',
//    uniName: 'unilorin',
//    profileImageUrl: null,
//    workType: 'Laundry',
//  ),
//  HireWorkerModel(
//    workerName: 'Janet Garner3',
//    userName: 'Jet',
//    workerPhoneNumber: '08011223344',
//    workerEmail: 'workMan@gmail.com',
//    uniName: 'unilorin',
//    profileImageUrl: null,
//    workType: 'Laundry',
//  ),
//  HireWorkerModel(
//    workerName: 'Hikmat',
//    userName: 'Hikmat',
//    workerPhoneNumber: '08011223344',
//    workerEmail: 'workMan@gmail.com',
//    uniName: 'unilag',
//    profileImageUrl:
//        'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQ8dceeddkD9IrvfZK0FfA-ZvvSEblMOdQIPA&usqp=CAU',
//    workType: 'Laundry',
//  ),
//  HireWorkerModel(
//    workerName: 'April Peters',
//    userName: 'Peters',
//    workerPhoneNumber: '08011223344',
//    workerEmail: 'workMan@gmail.com',
//    uniName: 'unilorin',
//    profileImageUrl:
//        'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQ8dceeddkD9IrvfZK0FfA-ZvvSEblMOdQIPA&usqp=CAU',
//    workType: 'Painter',
//  ),
//  HireWorkerModel(
//    workerName: 'Rosa Payne',
//    userName: 'Rosa',
//    workerPhoneNumber: '08011223344',
//    workerEmail: 'workMan@gmail.com',
//    uniName: 'unilorin',
//    profileImageUrl:
//        'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQ8dceeddkD9IrvfZK0FfA-ZvvSEblMOdQIPA&usqp=CAU',
//    workType: 'Painter',
//  ),
//  HireWorkerModel(
//    workerName: 'Jan Ortega',
//    userName: 'Jan',
//    workerPhoneNumber: '08011223344',
//    workerEmail: 'workMan@gmail.com',
//    uniName: 'unilorin',
//    profileImageUrl:
//        'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQ8dceeddkD9IrvfZK0FfA-ZvvSEblMOdQIPA&usqp=CAU',
//    workType: 'Painter',
//  ),
//  HireWorkerModel(
//    workerName: 'Teni Ola',
//    userName: 'Teni',
//    workerPhoneNumber: '08011223344',
//    workerEmail: 'workMan@gmail.com',
//    uniName: 'unilag',
//    profileImageUrl:
//        'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQ8dceeddkD9IrvfZK0FfA-ZvvSEblMOdQIPA&usqp=CAU',
//    workType: 'Painter',
//  ),
//  HireWorkerModel(
//    workerName: 'Teni Ola',
//    userName: 'Ola',
//    workerPhoneNumber: '08011223344',
//    workerEmail: 'workMan@gmail.com',
//    uniName: 'unilorin',
//    profileImageUrl:
//        'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQ8dceeddkD9IrvfZK0FfA-ZvvSEblMOdQIPA&usqp=CAU',
//    workType: 'Painter',
//  ),
//  HireWorkerModel(
//    workerName: 'Teni Ola',
//    userName: 'Ola',
//    workerPhoneNumber: '08011223344',
//    workerEmail: 'workMan@gmail.com',
//    uniName: 'unilorin',
//    profileImageUrl:
//        'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQ8dceeddkD9IrvfZK0FfA-ZvvSEblMOdQIPA&usqp=CAU',
//    workType: 'Carpenter',
//  ),
//  HireWorkerModel(
//    workerName: 'Marsha',
//    userName: 'Marsha',
//    workerPhoneNumber: '08011223344',
//    workerEmail: 'workMan@gmail.com',
//    uniName: 'unilorin',
//    profileImageUrl:
//        'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQ8dceeddkD9IrvfZK0FfA-ZvvSEblMOdQIPA&usqp=CAU',
//    workType: 'Carpenter',
//  ),
//];
//
//Future<void> saveHire() async {
//  for (HireWorkerModel h in list) {
//    print(h.workType);
//    print(h.toMap());
//
//    await HireMethods()
//        .hireCollection
//        .document('workers')
//        .collection('allWorkers')
//        .document()
//        .setData(h.toMap());
//  }
//}
