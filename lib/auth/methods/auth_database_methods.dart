import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:ohostel_hostel_agent_app/market_place/models/shop_model.dart';

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

  Future createShopOwnerDataInFirestore({@required ShopModel shopData}) {
    print('saving in db');

    return shopOwnerDataCollectionRef.document(shopData.uid).setData(
    shopData.toMap(),
      merge: true,
    );
  }
}
