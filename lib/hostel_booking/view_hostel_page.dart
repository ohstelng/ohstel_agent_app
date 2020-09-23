import 'package:carousel_slider/carousel_slider.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ohostel_hostel_agent_app/hostel_booking/methods.dart';

import 'model/hostel_model.dart';

class HostelBookingInFoPage extends StatefulWidget {
  final HostelModel hostelModel;
  final String type;
  final String id;

  HostelBookingInFoPage({
    @required this.hostelModel,
    @required this.type,
    @required this.id,
  });

  @override
  _HostelBookingInFoPageState createState() => _HostelBookingInFoPageState();
}

class _HostelBookingInFoPageState extends State<HostelBookingInFoPage> {
  int _current = 0;

  void confirmInspection() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Warning!'),
            content: Container(
              child: Text(
                'Are you Sure You Want To Comfirm Inspection!!',
                style: TextStyle(
                  color: Colors.red[300],
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            actions: [
              FlatButton(
                onPressed: () async {
                  await HostelBookingMethods().confirmInspection(id: widget.id);
                  Navigator.pop(context);
                },
                child: Text(
                  'Yes',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'No',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        });
  }

  void claimHostel() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Warning!'),
            content: Container(
              child: Text(
                'Are you Sure You Want To Comfirm Hostel Has Being Claimed!!',
                style: TextStyle(
                  color: Colors.red[300],
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            actions: [
              FlatButton(
                onPressed: () async {
                  await HostelBookingMethods().isClaimed(id: widget.id);
                  Navigator.pop(context);
                },
                child: Text(
                  'Yes',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'No',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            body(),
            footer(),
          ],
        ),
      ),
    );
  }

  Widget footer() {
    if (widget.type == 'inspection') {
      return Container(
        child: FlatButton(
          color: Colors.green,
          onPressed: () {
            confirmInspection();
          },
          child: Text('Confirm Inspection'),
        ),
      );
    } else if (widget.type == 'paid') {
      return Container(
        child: FlatButton(
          color: Colors.green,
          onPressed: () {
            claimHostel();
          },
          child: Text('Confrim'),
        ),
      );
    }
  }

  Widget body() {
    return Expanded(
      child: Container(
        child: Column(
          children: <Widget>[
            Stack(children: [
              displayMultiPic(imageList: widget.hostelModel.imageUrl),
              Positioned(
                  top: 0.0,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
//                    height: MediaQuery.of(context).size.height * 0.2,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                          Colors.grey[900].withOpacity(0.9),
                          Colors.grey[800].withOpacity(0.9),
                          Colors.grey[800].withOpacity(0.9),
                          Colors.grey[800].withOpacity(0.7),
                          Colors.grey[800].withOpacity(0.6),
                          Colors.grey[800].withOpacity(0.2),
                          Colors.transparent
                        ])),
                  )),
              Container(
                padding: EdgeInsets.only(right: 10, top: 10, left: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Center(
                          child: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 6,
                      child: Text(
                        'Hostel Details',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              )
            ]),
            hostelDetails(),
          ],
        ),
      ),
    );
  }

  Widget hostelDetails() {
    TextStyle _titlestyle =
        TextStyle(fontSize: 22, fontWeight: FontWeight.bold);
    return DefaultTabController(
      length: 2,
      child: Expanded(
        child: Container(
//        height: MediaQuery.of(context).size.height * 0.36,
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.transparent,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    '${widget.hostelModel.hostelName}',
                    style: _titlestyle,
                  ),
                  Spacer(),
                  Text(
                    '₦${(widget.hostelModel.price)}',
                    style: _titlestyle,
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: <Widget>[
                  Text('${widget.hostelModel.hostelLocation}'),
                  Spacer(),
                  Text(widget.hostelModel.isSchoolHostel
                      ? 'Roommate Needed'
                      : 'Roomate not Needed')
                ],
              ),
              SizedBox(height: 8),
              Row(children: <Widget>[
                Icon(
                  Icons.location_on,
                  size: 16,
                ),
                Text(
                    '${widget.hostelModel.distanceFromSchoolInKm.toLowerCase().contains('km') ? widget.hostelModel.distanceFromSchoolInKm + ' from Unilorin' : widget.hostelModel.distanceFromSchoolInKm + 'KM from Unilorin'}'),
                Spacer(),
                Text("12/12/2020")
              ]),
              SizedBox(height: 16),
              Container(
                child: TabBar(
                  tabs: <Widget>[
                    Tab(
                      child: Text(
                        'Details',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    Tab(
                        child: Text(
                      'Reviews',
                      style: TextStyle(color: Colors.black),
                    ))
                  ],
                ),
              ),
              Container(
//                  height: MediaQuery.of(context).size.height * 0.13,
                  child: Expanded(
                child: TabBarView(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SingleChildScrollView(
                          child: Text('${widget.hostelModel.description}')),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SingleChildScrollView(
                          child: Text(
                              'At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate non provident, similique sunt in culpa qui officia deserunt mollitia animi, id est laborum et dolorum fuga. Et harum quidem rerum facilis est et expedita distinctio. Nam libero tempore, cum soluta nobis est eligendi optio cumque nihil impedit quo minus id quod maxime placeat facere possimus, omnis voluptas assumenda est, omnis dolor repellendus. Temporibus autem quibusdam et aut officiis debitis aut rerum necessitatibus saepe eveniet ut et voluptates repudiandae sint et molestiae non recusandae. Itaque earum rerum hic tenetur a sapiente delectus, ut aut reiciendis voluptatibus maiores alias consequatur aut perferendis doloribus asperiores repellat')),
                    )
                  ],
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }

  Widget displayMultiPic({@required List imageList}) {
    List imgs = imageList.map(
      (images) {
        return Container(
          child: ExtendedImage.network(
            images,
            fit: BoxFit.fill,
            handleLoadingProgress: true,
            shape: BoxShape.rectangle,
            cache: false,
            enableMemoryCache: true,
          ),
        );
      },
    ).toList();
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.474,
        maxWidth: MediaQuery.of(context).size.width,
      ),
      child: Column(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20)),
            child: CarouselSlider(
              items: imgs,
              options: CarouselOptions(
                onPageChanged: (index, reason) {
                  setState(() {
                    _current = index;
                  });
                },
                height: 310.0,
                aspectRatio: 2.0,
                viewportFraction: 1,
                initialPage: 0,
                enableInfiniteScroll: true,
                reverse: false,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 3),
                autoPlayAnimationDuration: Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                enlargeCenterPage: false,
                scrollDirection: Axis.horizontal,
              ),
            ),
          ),
          SizedBox(height: 8),
//          Row(
//              mainAxisAlignment: MainAxisAlignment.center,
//              children: map<Widget>(imageList, (index, url) {
//                return Container(
//                  width: 8.0,
//                  height: 8.0,
//                  margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
//                  decoration: BoxDecoration(
//                      shape: BoxShape.circle,
//                      color: _current == index ? Colors.grey : Colors.black),
//                );
//              }).toList())
        ],
      ),
    );
  }
}
