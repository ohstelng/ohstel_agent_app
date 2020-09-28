import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ohostel_hostel_agent_app/hire/model/hire_agent_model.dart';
import 'package:ohostel_hostel_agent_app/hive_methods/hive_class.dart';

class HireMethods {
  CollectionReference hireRef = Firestore.instance
      .collection('hire')
      .document('workers')
      .collection('allWorkers');

  CollectionReference laundryOrdersRef =
      Firestore.instance.collection('laundryOrder');

  Future<void> saveHireWorker({@required HireWorkerModel worker}) async {
    Map userData = await HiveMethods().getUserData();
    String userUid = userData['uid'];
    print(userUid);

    try {
      DocumentSnapshot doc = await hireRef.document(userUid).get();

      if (doc.exists) {
        print('User Already Exist!!');
        throw Exception('User Already Exist!!');
      }

      QuerySnapshot querySnapshot = await hireRef
          .where('userName', isEqualTo: worker.userName)
          .getDocuments();

      if (querySnapshot.documents.length > 1) {
        print('User Name Already Exist!!');
        throw Exception('User Name Already Exist!!');
      }

      await hireRef.document(userUid).setData(worker.toMap());
      print('Uploaded');
      Fluttertoast.showToast(msg: 'Uploaded');
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: '$e');
    }
  }

  Future<void> saveLaundryClothesTypesAndPrice({@required Map data}) async {
    Map userData = await HiveMethods().getUserData();
    String userUid = userData['uid'];
    print(userUid);

    try {
      await hireRef.document(userUid).updateData({
        'laundryList': FieldValue.arrayUnion([data]),
      });
      print('UpDated!!');
      Fluttertoast.showToast(msg: 'UpDated!!');
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: '$e');
    }
  }

  Future<void> deleteLaundryClothesTypesAndPrice({@required Map data}) async {
    Map userData = await HiveMethods().getUserData();
    String userUid = userData['uid'];
    print(userUid);

    try {
      await hireRef.document(userUid).updateData({
        'laundryList': FieldValue.arrayRemove([data]),
      });
      print('UpDated!!');
      Fluttertoast.showToast(msg: 'UpDated!!');
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: '$e');
    }
  }

  Future<void> updateLaundryOrders({
    @required String id,
    @required List listOfLaundry,
    @required bool doneWith,
  }) async {
    try {
      DocumentSnapshot doc = await hireRef.document(id).get();

      if (doc.exists) {
        print('User Already Exist!!');
        throw Exception('User Already Exist!!');
      }

      await laundryOrdersRef.document(id).updateData({
        'listOfLaundry': listOfLaundry,
        'doneWith': doneWith,
      });
      print('Updated');
      Fluttertoast.showToast(msg: 'Updated');
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: '$e');
    }
  }

  Future<void> getLaundryUserData() async {
    Map userData = await HiveMethods().getUserData();
    String userUid = userData['uid'];
    print(userUid);

    try {
      DocumentSnapshot doc = await hireRef.document(userUid).get();
      Map data = doc.data;
      print(data);
      data.remove('dateJoined');
      print(data);

      await HiveMethods().saveLaundryUserData(data: data);

      print('Gotten Data!!');
//      Fluttertoast.showToast(msg: 'UpDated!!');
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: '$e');
    }
  }
}
