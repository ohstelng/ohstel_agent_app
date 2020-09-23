import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ohostel_hostel_agent_app/hostel_booking/model/hostel_model.dart';
import 'package:ohostel_hostel_agent_app/hostel_booking/model/paid_hostel_details_model.dart';
import 'package:ohostel_hostel_agent_app/hostel_booking/view_hostel_page.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

class ViewPaidHostel extends StatefulWidget {
  @override
  _ViewPaidHostelState createState() => _ViewPaidHostelState();
}

class _ViewPaidHostelState extends State<ViewPaidHostel> {
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
        title: Text('Paid Hostel'),
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
                    .collection('paidHostel')
                    .where('isClaimed', isEqualTo: false)
                    .orderBy('timestamp', descending: true),
                itemBuilder: (_, context, DocumentSnapshot documentSnapshot) {
                  Map data = documentSnapshot.data;
                  PaidHostelModel inspectionModel =
                      PaidHostelModel.fromMap(data);
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
                                type: 'paid',
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
                            Text('price: ${inspectionModel.price}'),
                          ],
                        ),
                      ),
                    ),
                  );
                }, itemBuilderType: PaginateBuilderType.listView,
              ),
      ),
    );
  }
}
