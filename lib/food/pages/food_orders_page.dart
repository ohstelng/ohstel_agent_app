import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:ohostel_hostel_agent_app/food/food_methods.dart';
import 'package:ohostel_hostel_agent_app/food/models/fast_food_details_model.dart';
import 'package:ohostel_hostel_agent_app/food/models/paid_food_model.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

class FoodOrderPage extends StatelessWidget {
  final List uniList = ['unilorin', 'unilag', 'lasu', 'al-hikmat'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: uniList.length,
        itemBuilder: (context, index) {
          return FlatButton(
            color: Colors.green,
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => SelectFoodPage(
                    uniName: uniList[index],
                  ),
                ),
              );
            },
            child: Text('${uniList[index]}'),
          );
        },
      ),
    );
  }
}

class SelectFoodPage extends StatelessWidget {
  final String uniName;

  SelectFoodPage({@required this.uniName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PaginateFirestore(
          itemsPerPage: 10,
          itemBuilderType: PaginateBuilderType.listView,
          query: FoodMethods()
              .foodCollectionRef
              .orderBy('fastFood', descending: true),
          itemBuilder: (_, context, snap) {
            FastFoodModel fastFood = FastFoodModel.fromMap(snap.data);
//                  return Text('jmjjj');

            return Container(
              margin: EdgeInsets.all(5.0),
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => SelectedOrderPage(
                        uniName: uniName,
                        fastFoodName: fastFood.fastFoodName,
                      ),
                    ),
                  );
                },
                child: Card(
                  elevation: 2.0,
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.all(25.0),
                      child: Text('${fastFood.fastFoodName}'),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class SelectedOrderPage extends StatefulWidget {
  final String uniName;
  final String fastFoodName;

  SelectedOrderPage({@required this.uniName, @required this.fastFoodName});

  @override
  _SelectedOrderPageState createState() => _SelectedOrderPageState();
}

class _SelectedOrderPageState extends State<SelectedOrderPage> {
  bool loading = false;

  Future<void> refresh({bool pop = true}) async {
    int count = 0;

    if (pop == true) {
      Navigator.popUntil(context, (route) {
        return count++ == 2;
      });
    }

    setState(() {
      loading = true;
    });
    await Future.delayed(Duration(milliseconds: 500));
    setState(() {
      loading = false;
    });
  }

  Future<void> updateOrderDetails(
      {@required PaidFood order, @required int index}) async {
    List<Map> _updatedOrdersList = [];

    for (var i = 0; i < order.orders.length; i++) {
      Map eachOrder = order.orders[i];
      print('ooooo');

      if (i == index) {
        eachOrder['status'] = 'Delivered To Buyer';
      }

      _updatedOrdersList.add(eachOrder);
    }

    PaidFood updatedOrder = PaidFood(
      buyerFullName: order.buyerFullName,
      addressDetails: order.addressDetails,
      phoneNumber: order.phoneNumber,
      email: order.email,
      orders: _updatedOrdersList,
      fastFoodNames: order.fastFoodNames,
      address: order.address,
      uniName: order.uniName,
    );

    print(order.id);
    print(updatedOrder.toMap());
    await FoodMethods()
        .updateFoodOrder(paidOrder: updatedOrder, id: order.id)
        .whenComplete(() async {
      refresh();
    });
  }

  void setShippingInfo({@required PaidFood order, @required int index}) {
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
                  order: order,
                  index: index,
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

  void optionPopUp({@required PaidFood order, @required int index}) {
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
                child: Text('Confirm Delivered'),
                onPressed: () => setShippingInfo(
                  order: order,
                  index: index,
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
    print(widget.uniName);
    print(widget.fastFoodName);
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.fastFoodName} Orders'),
        actions: [
          Container(
            margin: EdgeInsets.all(10.0),
            child: InkWell(
              onTap: () => refresh(pop: false),
              child: Icon(Icons.refresh),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: loading
            ? Center(child: CircularProgressIndicator())
            : PaginateFirestore(
                itemsPerPage: 10,
                itemBuilderType: PaginateBuilderType.listView,
                query: FoodMethods()
                    .orderedFoodCollectionRef
                    .where('doneWith', isEqualTo: false)
                    .where('uniName', isEqualTo: widget.uniName)
                    .where('fastFoodName', arrayContains: widget.fastFoodName)
                    .orderBy('timestamp', descending: true),
                itemBuilder: (_, context, snap) {
                  PaidFood paidOrder = PaidFood.fromMap(snap.data);
//                  return Text('jmjjj');

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
                                Text('Buyer Number: ${paidOrder.phoneNumber}'),
                                Text('id: ${paidOrder.id}'),
                                Text('Buyer Email: ${paidOrder.email}'),
                                Text(
                                    'Buyer Address: ${paidOrder.addressDetails['address']}, ${paidOrder.addressDetails['areaName']}. Oncampus: ${paidOrder.addressDetails['onCampus']}'),
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
                              EachOrder currentOrder =
                                  EachOrder.fromMap(paidOrder.orders[index]);
                              return InkWell(
                                onTap: () {
                                  optionPopUp(order: paidOrder, index: index);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black),
                                  ),
                                  margin: EdgeInsets.all(10.0),
                                  child: details(currentOrder: currentOrder),
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

  Widget details({@required EachOrder currentOrder}) {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Food Name: ${currentOrder.mainItem}'),
          Text('Fast Food: ${currentOrder.fastFoodName}'),
          currentOrder.extraItems.isEmpty
              ? Container()
              : Container(
//                  decoration: BoxDecoration(
//                    border: Border.all(color: Colors.black),
//                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Divider(),
                      Text('............ Extras ............'),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.70,
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: currentOrder.extraItems.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.all(2.0),
                              child: Text(
                                  'Extra ${currentOrder.extraItems[index]}'),
                            );
                          },
                        ),
                      ),
                      Divider(),
                    ],
                  ),
                ),
//          Text('Price: ${currentOrder.productPrice}'),
//          Text('Category: ${currentOrder.productCategory}'),
          Text('deliveryStatus: ${currentOrder.status}'),
        ],
      ),
    );
  }

  Widget displayMultiPic({@required String image}) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: 120,
        maxWidth: 150,
      ),
      child: image != null
          ? ExtendedImage.network(
              image,
              fit: BoxFit.fill,
              handleLoadingProgress: true,
              shape: BoxShape.rectangle,
              cache: false,
              enableMemoryCache: true,
            )
          : Center(child: Icon(Icons.image)),
    );
  }
}
