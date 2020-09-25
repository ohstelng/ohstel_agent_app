import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ohostel_hostel_agent_app/hostel_booking/model/hostel_model.dart';
import 'package:ohostel_hostel_agent_app/hostel_booking/model/paid_hostel_details_model.dart';
import 'package:ohostel_hostel_agent_app/hostel_booking/view_hostel_page.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:ohostel_hostel_agent_app/widgets/styles.dart' as Styles;

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
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            children: [
              Row(
                children: [
                  Text('Paid Hostel',style: Styles.subTitle1TextStyle,),
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.refresh,color: Colors.black,),
                    onPressed: () {
                      reload();
                    },
                  )


                ],),
              Container(
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
                            decoration: Styles.cardDec,
                            padding:
                            EdgeInsets.symmetric(vertical: 8.0,horizontal: 8),
                            margin: EdgeInsets.symmetric(vertical: 3),
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
                                  Text('NAME: ${inspectionModel.fullName}',style: Styles.headingTextStyle,),
                                  Text('E-MAIL: ${inspectionModel.email}'),
                                  Text(
                                      'PHONE NUMBER: ${inspectionModel.phoneNumber}'),
                                  Text('PRICE: ${inspectionModel.price}'),
                                ],
                              ),
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
