import 'package:carousel_slider/carousel_slider.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:ohostel_hostel_agent_app/hire/hire_methods.dart';
import 'package:ohostel_hostel_agent_app/hire/model/laundry_address_details_model.dart';
import 'package:ohostel_hostel_agent_app/hire/model/laundry_basket_model.dart';
import 'package:ohostel_hostel_agent_app/hire/model/paid_laundry_model.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

enum LaundryStatus { AwaitingWashUp, AwaitingDelivery, Delivered }

class AllLaundryOrder extends StatefulWidget {
  @override
  _AllLaundryOrderState createState() => _AllLaundryOrderState();
}

class _AllLaundryOrderState extends State<AllLaundryOrder> {
  int _current = 0;
  bool loading = false;

  Future<void> refresh() async {
    int count = 0;

    Navigator.popUntil(context, (route) {
      return count++ == 2;
    });

    setState(() {
      loading = true;
    });
    await Future.delayed(Duration(milliseconds: 500));
    setState(() {
      loading = false;
    });
  }

  Future<void> updateOrderDetails(
      {@required PaidLaundryBookingModel laundry,
      @required int index,
      @required LaundryStatus type}) async {
    List<Map> _updatedLaundryList = [];
    bool doneWith = false;

    for (var i = 0; i < laundry.listOfLaundry.length; i++) {
      Map eachLaundry = laundry.listOfLaundry[i];
      print('ooooo');

      if (i == index) {
        if (type == LaundryStatus.AwaitingWashUp) {
          eachLaundry['status'] = 'Picked Up, washing In Progress...';
        } else if (type == LaundryStatus.AwaitingDelivery) {
          eachLaundry['status'] = 'Washing Done, delivery In Progress....';
        } else if (type == LaundryStatus.Delivered) {
          eachLaundry['status'] = 'Delivered';
        }

        _updatedLaundryList.add(eachLaundry);
      }

      if (eachLaundry['status'] == 'Delivered') {
        doneWith = true;
      } else {
        doneWith = false;
      }
    }

    print(laundry.id);
    print(_updatedLaundryList);

    await HireMethods()
        .updateLaundryOrders(
      id: laundry.id,
      listOfLaundry: _updatedLaundryList,
      doneWith: doneWith,
    )
        .whenComplete(() {
      refresh();
    });
  }

  void setShippingInfo(
      {@required PaidLaundryBookingModel laundry,
      @required int index,
      @required LaundryStatus type}) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      // false = user must tap button, true = tap outside dialog
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Warning'),
          content: Text('Are You Sure You Want To Proceeed!'),
          actions: <Widget>[
            FlatButton(
              color: Colors.green,
              child: Text('Yes'),
              onPressed: () {
                updateOrderDetails(
                  laundry: laundry,
                  index: index,
                  type: type,
                );
              },
            ),
            FlatButton(
              child: Text('No'),
              color: Colors.red,
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Dismiss alert dialog
              },
            ),
          ],
        );
      },
    );
  }

  void optionPopUp(
      {@required PaidLaundryBookingModel laundry, @required int index}) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      // false = user must tap button, true = tap outside dialog
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Select Options'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FlatButton(
                color: Colors.green,
                child: Text('Confirm Laundry Has been Picked Up'),
                onPressed: () => setShippingInfo(
                  laundry: laundry,
                  index: index,
                  type: LaundryStatus.AwaitingWashUp,
                ),
              ),
              SizedBox(height: 5),
              FlatButton(
                color: Colors.green,
                child: Text('Confirm Laundry Has been Washed And packaged'),
                onPressed: () => setShippingInfo(
                  laundry: laundry,
                  index: index,
                  type: LaundryStatus.AwaitingDelivery,
                ),
              ),
              SizedBox(height: 5),
              FlatButton(
                color: Colors.green,
                child: Text('Confirm Delivered'),
                onPressed: () => setShippingInfo(
                  laundry: laundry,
                  index: index,
                  type: LaundryStatus.Delivered,
                ),
              ),
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Cancel'),
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: loading
            ? Center(child: CircularProgressIndicator())
            : PaginateFirestore(
                itemsPerPage: 10,
                itemBuilderType: PaginateBuilderType.listView,
                query: HireMethods()
                    .laundryOrdersRef
                    .where('doneWith', isEqualTo: false)
//                    .where('uniName', isEqualTo: false)
                    .orderBy('timestamp', descending: true),
                itemBuilder: (_, context, snap) {
                  PaidLaundryBookingModel laundry =
                      PaidLaundryBookingModel.fromMap(snap.data);
                  LaundryAddressDetailsModel addressDetails =
                      LaundryAddressDetailsModel.fromMap(
                          laundry.clothesOwnerAddressDetails);

                  return Container(
//              margin: EdgeInsets.all(5.0),
                    child: Card(
                      elevation: 2.0,
                      child: ExpansionTile(
                        title: Text('${laundry.clothesOwnerName}'),
                        subtitle: Text('${laundry.timestamp.toDate()}'),
                        children: [
                          Container(
                            width: double.infinity,
                            margin: EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('Owner Name: ${laundry.clothesOwnerName}'),
                                Text(
                                    'Owner Email: ${laundry.clothesOwnerEmail}'),
                                Text(
                                    'Owner Number: ${laundry.clothesOwnerPhoneNumber}'),
                                Text(
                                    'Pick Up Address: ${addressDetails.pickUpAddress['address']}, ${addressDetails.pickUpAddress['areaName']}. onCampus: ${addressDetails.pickUpAddress['onCampus']}'),
                                Text(
                                    'Pick Up Number: ${addressDetails.pickUpNumber}'),
                                Text(
                                    'Pick Up Date: ${addressDetails.pickUpDate}'),
                                Text(
                                    'Pick Up Time: ${addressDetails.pickUpTime}'),
                                Text(
                                    'Drop Off Address: ${addressDetails.dropOffAddress['address']}, ${addressDetails.dropOffAddress['areaName']}. onCampus: ${addressDetails.dropOffAddress['onCampus']}'),
                                Text(
                                    'Drop off Number: ${addressDetails.dropOffNumber}'),
                              ],
                            ),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: laundry.listOfLaundry.length,
                            itemBuilder: (context, index) {
                              LaundryBookingBasketModel currentLaundry =
                                  LaundryBookingBasketModel.fromMap(
                                      laundry.listOfLaundry[index]);
                              return InkWell(
                                onTap: () {
                                  optionPopUp(laundry: laundry, index: index);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black),
                                  ),
                                  margin: EdgeInsets.all(10.0),
                                  child: Row(
                                    children: [
                                      displayMultiPic(
                                          imageList: [currentLaundry.imageUrl]),
                                      details(laundryBooking: currentLaundry),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }

  Widget details({@required LaundryBookingBasketModel laundryBooking}) {
    return Container(
//      height: 150,
      margin: EdgeInsets.all(5.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Shop Name: ${laundryBooking.laundryPersonName}'),
          Text('Shop phone Number: ${laundryBooking.laundryPersonPhoneNumber}'),
          Text('Shop Email: ${laundryBooking.laundryPersonEmail}'),
          Text('Cloth Type: ${laundryBooking.clothTypes}'),
          Text('Wash Mode: ${laundryBooking.laundryMode}'),
          Text('Price: ${laundryBooking.price}'),
          Text('uints: ${laundryBooking.units}'),
          Text('status: ${laundryBooking.status}'),
        ],
      ),
    );
  }

  Widget displayMultiPic({@required List imageList}) {
    List imgs = imageList.map(
      (images) {
        return images != null
            ? Container(
                child: ExtendedImage.network(
                  images,
                  fit: BoxFit.fill,
                  handleLoadingProgress: true,
                  shape: BoxShape.rectangle,
                  cache: false,
                  enableMemoryCache: true,
                ),
              )
            : Center(child: Icon(Icons.image));
      },
    ).toList();
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
      ),
      constraints: BoxConstraints(
        maxHeight: 120,
        maxWidth: 150,
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
                height: 100.0,
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
//          SizedBox(height: 8),
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
