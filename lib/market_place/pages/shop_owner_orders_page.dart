import 'package:carousel_slider/carousel_slider.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:ohostel_hostel_agent_app/hive_methods/hive_class.dart';
import 'package:ohostel_hostel_agent_app/market_place/market_methods.dart';
import 'package:ohostel_hostel_agent_app/market_place/models/paid_market_orders_model.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

class ShopOwnerOrders extends StatefulWidget {
  @override
  _ShopOwnerOrdersState createState() => _ShopOwnerOrdersState();
}

class _ShopOwnerOrdersState extends State<ShopOwnerOrders> {
  int _current = 0;
  bool loading;
  String shopName;

  Future<void> getData() async {
    setState(() {
      loading = true;
    });
    Map data = await HiveMethods().getUserData();
    shopName = data['shopName'];
    print(data);
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading
          ? Center(child: CircularProgressIndicator())
          : SafeArea(
              child: PaginateFirestore(
                itemsPerPage: 10,
                itemBuilderType: PaginateBuilderType.listView,
                query: MarketMethods()
                    .productOrdersRef
                    .where('listOfShopsPurchasedFrom', arrayContains: shopName)
                    .orderBy('timestamp', descending: true),
                itemBuilder: (_, context, snap) {
                  PaidOrderModel paidOrder = PaidOrderModel.fromMap(snap.data);

                  return Container(
//              margin: EdgeInsets.all(5.0),
                    child: Card(
                      elevation: 2.0,
                      child: ExpansionTile(
                        title: Text('${paidOrder.id}'),
                        subtitle: Text('${paidOrder.timestamp.toDate()}'),
                        children: [
                          Container(
                            width: double.infinity,
                            margin: EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('Buyer Name: ${paidOrder.buyerFullName}'),
                                Text(
                                    'Buyer Number: ${paidOrder.buyerPhoneNumber}'),
                                Text('Amount Paid: ${paidOrder.amountPaid}'),
                                Text('Buyer Email: ${paidOrder.buyerEmail}'),
                                Text(
                                    'Buyer Address: ${paidOrder.buyerAddress}'),
                                Text(
                                    'Number Of Orders: ${paidOrder.orders.length}'),
                              ],
                            ),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: paidOrder.orders.length,
                            itemBuilder: (context, index) {
                              EachPaidOrderModel currentOrder =
                                  EachPaidOrderModel.fromMap(
                                paidOrder.orders[index],
                              );

                              if (currentOrder.productShopName != shopName) {
                                return Container();
                              }
                              return Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black),
                                ),
                                margin: EdgeInsets.all(10.0),
                                child: Row(
                                  children: [
                                    displayMultiPic(
                                        imageList: currentOrder.imageUrls),
                                    details(currentOrder: currentOrder),
                                  ],
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

  Widget details({@required EachPaidOrderModel currentOrder}) {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('productName: ${currentOrder.productName}'),
          Text('product Size: ${currentOrder.size ?? 'None'}'),
          Text('ShopName: ${currentOrder.productShopName}'),
          Text('Shop Email: ${currentOrder.productShopOwnerEmail}'),
          Text('Shop Number: ${currentOrder.productShopOwnerPhoneNumber}'),
          Text('Price: ${currentOrder.productPrice}'),
          Text('Category: ${currentOrder.productCategory}'),
          Text('deliveryStatus: ${currentOrder.deliveryStatus}'),
        ],
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
