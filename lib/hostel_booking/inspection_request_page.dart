import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ohostel_hostel_agent_app/hostel_booking/model/hostel_booking_inspection_model.dart';
import 'package:ohostel_hostel_agent_app/hostel_booking/model/hostel_model.dart';
import 'package:ohostel_hostel_agent_app/hostel_booking/view_hostel_page.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

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
      appBar: AppBar(
        title: Text('Inspection Requests'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              reload();
            },
          )
        ],
      ),
      body: SafeArea(
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
                    margin:
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.0),
                    child: Card(
                      elevation: 0,
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
                            Text('name: ${inspectionModel.fullName}'),
                            Text('email: ${inspectionModel.email}'),
                            Text(
                                'phone number: ${inspectionModel.phoneNumber}'),
                            Text('date: ${inspectionModel.date}'),
                            Text('time: ${inspectionModel.time}'),
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
                    ),
                  );
                }, itemBuilderType: PaginateBuilderType.listView,
              ),
      ),
    );
  }
}
