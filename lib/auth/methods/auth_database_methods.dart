import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class AuthDatabaseMethods {
  // collection ref
  final CollectionReference userDataCollectionRef =
      Firestore.instance.collection('userData');

  final CollectionReference shopOwnerDataCollectionRef =
      Firestore.instance.collection('shopOwnersData');

  Future createUserDataInFirestore({
    @required String uid,
    @required String email,
    @required String fullName,
    @required String userName,
    @required String schoolLocation,
    @required String phoneNumber,
    @required String uniName,
  }) {
    return userDataCollectionRef.document(uid).setData(
      {
        'uid': uid,
        'email': email,
        'fullName': fullName,
        'userName': userName,
        'schoolLocation': schoolLocation,
        'phoneNumber': phoneNumber,
        'uniName': uniName,
      },
      merge: true,
    );
  }

  Future createShopOwnerDataInFirestore({
    @required String uid,
    @required String email,
    @required String fullName,
    @required String shopName,
    @required String address,
    @required String phoneNumber,
    @required String uniName,
  }) {
    print('saving in db');
    return shopOwnerDataCollectionRef.document(uid).setData(
      {
        'uid': uid,
        'email': email,
        'fullName': fullName,
        'shopName': shopName,
        'address': address,
        'phoneNumber': phoneNumber,
        'uniName': uniName,
        'dateJoined': Timestamp.now(),
        'numberOfProducts': 0,
        'isPartner': false,
      },
      merge: true,
    );
  }
}
