import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ohostel_hostel_agent_app/hostel_booking/model/hostel_model.dart';

class HostelBookingMethods {
  CollectionReference hostelRef =
      Firestore.instance.collection('hostelBookings');

  CollectionReference hostelInspectionRef =
      Firestore.instance.collection('bookingInspections');

  CollectionReference paidHostelRef =
      Firestore.instance.collection('paidHostel');

  Future saveHostelToServer({@required HostelModel hostelModel}) async {
    try {
      print('saving');
      await hostelRef.document(hostelModel.id).setData(hostelModel.toMap());
      print('saved');
    } catch (err) {
      print(err);
      Fluttertoast.showToast(msg: '$err');
    }
  }

  Future confirmInspection({@required String id}) async {
    try {
      await hostelInspectionRef
          .document(id)
          .updateData({'inspectionMade': true});
      print('done');
      Fluttertoast.showToast(msg: 'Comfirmed!!');
    } catch (err) {
      print(err);
      Fluttertoast.showToast(msg: '$err');
    }
  }

  Future isClaimed({@required String id}) async {
    try {
      await paidHostelRef.document(id).updateData({'isClaimed': true});
      Fluttertoast.showToast(msg: 'Comfirmed!!');
    } catch (err) {
      print(err);
      Fluttertoast.showToast(msg: '$err');
    }
  }

  Future<List<HostelModel>> fetchHostelByKeyWord(
      {@required String keyWord, @required String uniName}) async {
    List<HostelModel> hostelList = List<HostelModel>();

    QuerySnapshot querySnapshot = await hostelRef
        .where('hostelName', isGreaterThanOrEqualTo: keyWord)
        .orderBy('hostelName', descending: true)
        .limit(6)
        .getDocuments();

    for (var i = 0; i < querySnapshot.documents.length; i++) {
      print('key : $keyWord');
      debugPrint(
          'hostel Name: ${querySnapshot.documents[i].data['hostelName']}');

      hostelList.add(HostelModel.fromMap(querySnapshot.documents[i].data));
    }

    print(hostelList);
    print(hostelList.length);
    return hostelList;
  }

  Future<List<HostelModel>> fetchHostelByKeyWordWithPagination({
    @required String keyWord,
    @required HostelModel lastHostel,
    @required String uniName,
  }) async {
    print(lastHostel.id);
    List<HostelModel> hostelList = List<HostelModel>();

    QuerySnapshot querySnapshot = await hostelRef
        .where('uniName', isEqualTo: uniName)
        .where('hostelName', isGreaterThanOrEqualTo: keyWord)
        .orderBy('hostelName', descending: true)
        .startAfter([lastHostel.dateAdded])
        .limit(3)
        .getDocuments();

    for (var i = 0; i < querySnapshot.documents.length; i++) {
      hostelList.add(HostelModel.fromMap(querySnapshot.documents[i].data));
      print(querySnapshot.documents[i].data['id']);
      print(querySnapshot.documents[i].data);
    }

    print(hostelList);
    print(hostelList.length);
    return hostelList;
  }

  Future updateHostelDetails({
    @required String id,
    @required String hostelName,
    @required int hostelPrice,
    @required bool roommateNeeded,
  }) async {
    try {
      await hostelRef.document(id).updateData({
        'hostelName': hostelName,
        'price': hostelPrice,
        'isRoomMateNeeded': roommateNeeded,
      });
      print('Updated!!');
      Fluttertoast.showToast(msg: 'Updated!!');
    } catch (err) {
      print(err);
      Fluttertoast.showToast(msg: '$err');
    }
  }

  Future deleteHostelDetails({
    @required String id,
  }) async {
    try {
      await hostelRef.document(id).delete();
      print('Deleted!!');
      Fluttertoast.showToast(msg: 'Deleted!!');
    } catch (err) {
      print(err);
      Fluttertoast.showToast(msg: '$err');
    }
  }
}
