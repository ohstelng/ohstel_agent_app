import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ohostel_hostel_agent_app/hostel_booking/model/hostel_booking_inspection_model.dart';
import 'package:ohostel_hostel_agent_app/hostel_booking/model/hostel_model.dart';
import 'package:ohostel_hostel_agent_app/hostel_booking/view_hostel_page.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:ohostel_hostel_agent_app/widgets/styles.dart' as Styles;

class ViewInspectionRequestPage extends StatefulWidget {
  @override
  _ViewInspectionRequestPageState createState() =>
      _ViewInspectionRequestPageState();
}

class _ViewInspectionRequestPageState extends State<ViewInspectionRequestPage> {
  bool showLoading = false;

  Future<void> reload() async {
    if (!mounted) return;

    setState(() {
      showLoading = true;
    });

    await Future.delayed(Duration(milliseconds: 500));

    setState(() {
      showLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            children: [
              Row(
                children: [
                  Text('Inspection Requests',style: Styles.subTitle1TextStyle,),
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.refresh,color: Colors.black,),
                    onPressed: () {
                      reload();
                    },
                  )


              ],),
              Container(
                padding: EdgeInsets.symmetric(vertical: 8),
                height: MediaQuery.of(context).size.height*0.75,
                child: showLoading
                    ? Center(child: CircularProgressIndicator())
                    : PaginateFirestore(
                        scrollDirection: Axis.vertical,
                        itemsPerPage: 10,
                        physics: BouncingScrollPhysics(),
                        initialLoader: Container(
                          height: 50,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        bottomLoader: Center(
                          child: CircularProgressIndicator(),
                        ),
                        shrinkWrap: true,
                        query: Firestore.instance
                            .collection('bookingInspections')
                            .where('inspectionMade', isEqualTo: false)
                            .orderBy('timestamp', descending: true),
                        itemBuilder: (_, context, DocumentSnapshot documentSnapshot) {
                          Map data = documentSnapshot.data;
                          HostelBookingInspectionModel inspectionModel =
                              HostelBookingInspectionModel.fromMap(data);
                          HostelModel hostel =
                              HostelModel.fromMap(inspectionModel.hostelDetails);

                          return Container(
                            decoration: Styles.cardDec,
                            padding:
                                EdgeInsets.symmetric(vertical: 8.0,horizontal: 8),
                            margin: EdgeInsets.symmetric(vertical: 5),
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => HostelBookingInFoPage(
                                      hostelModel: hostel,
                                      id: data['id'].toString(),
                                      type: 'inspection',
                                    ),
                                  ),
                                );
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('NAME: ${inspectionModel.fullName}',style: Styles.headingTextStyle,),
                                  Text('E-MAIL: ${inspectionModel.email}'),
                                  Text(
                                      'PHONE NUMBER: ${inspectionModel.phoneNumber}'),
                                  Text('DATE: ${inspectionModel.date}'),
                                  Text('TIME: ${inspectionModel.time}'),
                                ],
                              ),
//                  child: Row(
//                    children: <Widget>[
//                      Container(
//                        height: 150,
//                        width: 200,
//                        margin: EdgeInsets.symmetric(
//                            horizontal: 5.0, vertical: 2.0),
//                        decoration: BoxDecoration(
//                          color: Colors.grey,
//                          border: Border.all(color: Colors.grey),
//                        ),
//                        child: ExtendedImage.network(
//                          data['imageUrl'],
//                          fit: BoxFit.fill,
//                          handleLoadingProgress: true,
//                          shape: BoxShape.rectangle,
//                          cache: false,
//                          enableMemoryCache: true,
//                        ),
//                      ),
//                      Expanded(
//                        child: Container(
//                          margin: EdgeInsets.symmetric(horizontal: 2.0),
//                          child: Text(
//                            '${data['searchKey']}',
//                            maxLines: 1,
//                            style: TextStyle(
//                                fontWeight: FontWeight.bold, fontSize: 18),
//                          ),
//                        ),
//                      )
//                    ],
//                  ),
                            ),
                          );
                        }, itemBuilderType: PaginateBuilderType.listView,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
