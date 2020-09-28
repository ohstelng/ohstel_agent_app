import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ohostel_hostel_agent_app/hire/hire_methods.dart';
import 'package:ohostel_hostel_agent_app/hire/model/hire_agent_model.dart';
import 'package:ohostel_hostel_agent_app/hire/model/laundry_booking_model.dart';
import 'package:ohostel_hostel_agent_app/hive_methods/hive_class.dart';

class LaundryItemPage extends StatefulWidget {
  @override
  _LaundryItemPageState createState() => _LaundryItemPageState();
}

class _LaundryItemPageState extends State<LaundryItemPage> {
  bool loading;
  Map userData;

  Future<void> getUserData() async {
    userData = await HiveMethods().getUserData();
    print(userData);
    setState(() {
      loading = false;
    });
  }

  Future<void> deleteLaundryItem({@required Map data}) async {
    await HireMethods().deleteLaundryClothesTypesAndPrice(data: data);
  }

  void ask({@required Map data}) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      // false = user must tap button, true = tap outside dialog
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Warning'),
          content: Text('Are You sure you want to delete this????'),
          actions: <Widget>[
            FlatButton(
              color: Colors.green,
              child: Text('Yes'),
              onPressed: () {
                deleteLaundryItem(data: data);
              },
            ),
            FlatButton(
              color: Colors.red,
              child: Text('No'),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Dismiss alert dialog
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: loading
            ? Center(child: CircularProgressIndicator())
            : FutureBuilder(
                future: HireMethods().hireRef.document(userData['uid']).get(),
                builder: (context, snap) {
                  if (!snap.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  DocumentSnapshot doc = snap.data;
                  HireWorkerModel hireWorker =
                      HireWorkerModel.fromMap(doc.data);

                  return Card(
                    child: Container(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(hireWorker.workerName),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: hireWorker.laundryList.length,
                            itemBuilder: (context, index) {
                              LaundryBookingModel currentLaundry =
                                  LaundryBookingModel.fromMap(
                                hireWorker.laundryList[index],
                              );
                              return Container(
                                margin: EdgeInsets.all(10.0),
                                padding: EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black),
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                        'Cloth Type: ${currentLaundry.clothTypes}'),
                                    Text(
                                        'Wash Only = ${currentLaundry.laundryModeAndPrice['Wash Only']}'),
                                    Text(
                                        'Dry Clean = ${currentLaundry.laundryModeAndPrice['Dry Clean']}'),
                                    Text(
                                        'Wash And Iron = ${currentLaundry.laundryModeAndPrice['Wash And Iron']}'),
                                    Text(
                                        'Iron Only = ${currentLaundry.laundryModeAndPrice['Iron Only']}'),
                                    FlatButton(
                                      onPressed: () {
                                        ask(data: currentLaundry.toMap());
                                      },
                                      child: Text('Delete'),
                                      color: Colors.red,
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
//          return Container(
////              margin: EdgeInsets.all(5.0),
//            child: Card(
//              elevation: 2.0,
//              child: ExpansionTile(
//                title: Text('${laundry.clothesOwnerName}'),
//                subtitle: Text('${laundry.timestamp.toDate()}'),
//                children: [
//                  Container(
//                    width: double.infinity,
//                    margin: EdgeInsets.all(10.0),
//                    child: Column(
//                      crossAxisAlignment: CrossAxisAlignment.start,
//                      mainAxisAlignment: MainAxisAlignment.start,
//                      mainAxisSize: MainAxisSize.min,
//                      children: [
//                        Text('Owner Name: ${laundry.clothesOwnerName}'),
//                        Text(
//                            'Owner Email: ${laundry.clothesOwnerEmail}'),
//                        Text(
//                            'Owner Number: ${laundry.clothesOwnerPhoneNumber}'),
//                        Text(
//                            'Pick Up Address: ${addressDetails.pickUpAddress['address']}, ${addressDetails.pickUpAddress['areaName']}. onCampus: ${addressDetails.pickUpAddress['onCampus']}'),
//                        Text(
//                            'Pick Up Number: ${addressDetails.pickUpNumber}'),
//                        Text(
//                            'Pick Up Date: ${addressDetails.pickUpDate}'),
//                        Text(
//                            'Pick Up Time: ${addressDetails.pickUpTime}'),
//                        Text(
//                            'Drop Off Address: ${addressDetails.dropOffAddress['address']}, ${addressDetails.dropOffAddress['areaName']}. onCampus: ${addressDetails.dropOffAddress['onCampus']}'),
//                        Text(
//                            'Drop off Number: ${addressDetails.dropOffNumber}'),
//                      ],
//                    ),
//                  ),
//                  ListView.builder(
//                    shrinkWrap: true,
//                    physics: NeverScrollableScrollPhysics(),
//                    itemCount: laundry.listOfLaundry.length,
//                    itemBuilder: (context, index) {
//                      LaundryBookingBasketModel currentLaundry =
//                      LaundryBookingBasketModel.fromMap(
//                          laundry.listOfLaundry[index]);
//                      return InkWell(
//                        onTap: () {
//                          optionPopUp(laundry: laundry, index: index);
//                        },
//                        child: Container(
//                          decoration: BoxDecoration(
//                            border: Border.all(color: Colors.black),
//                          ),
//                          margin: EdgeInsets.all(10.0),
//                          child: Row(
//                            children: [
//                              displayMultiPic(
//                                  imageList: [currentLaundry.imageUrl]),
//                              details(laundryBooking: currentLaundry),
//                            ],
//                          ),
//                        ),
//                      );
//                    },
//                  ),
//                ],
//              ),
//            ),
//          );
                },
              ),
      ),
    );
  }
}
