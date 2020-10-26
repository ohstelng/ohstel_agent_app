import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:ohostel_hostel_agent_app/hive_methods/hive_class.dart';
import 'package:ohostel_hostel_agent_app/market_place/market_methods.dart';
import 'package:ohostel_hostel_agent_app/market_place/models/product_model.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

class ShopOwnerProductPage extends StatefulWidget {
  @override
  _ShopOwnerProductPageState createState() => _ShopOwnerProductPageState();
}

class _ShopOwnerProductPageState extends State<ShopOwnerProductPage> {
  bool loading;
  String shopName;
  int current = 0;

  Future<void> getData() async {
    setState(() {
      loading = true;
    });
    Map data = await HiveMethods().getUserData();
    shopName = data['shopName'];
    print(shopName);
    print(data);
    setState(() {
      loading = false;
    });
  }

  void editPopUp({@required ProductModel product}) {
    int _price;
    String _productName;
    final formKey = GlobalKey<FormState>();
    TextEditingController productNameController = TextEditingController();
    TextEditingController productPriceController = TextEditingController();
    productNameController.text = product.productName.toString();
    productPriceController.text = product.productPrice.toString();

    showDialog(
      context: context,
      barrierDismissible: false,
      // false = user must tap button, true = tap outside dialog
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Edit Info'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  child: TextFormField(
                    validator: (value) {
                      if (value.trim().isEmpty) {
                        return 'Product Name Can\'t Be Empty';
                      } else {
                        return null;
                      }
                    },
                    controller: productNameController,
                    decoration: InputDecoration(
                      labelText: 'Product Name',
                    ),
                    onSaved: (value) => _productName = value.trim(),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 15),
                ),
                Container(
                  child: TextFormField(
                    validator: (value) {
                      if (value.trim().isEmpty) {
                        return 'Product Price Can\'t Be Empty';
                      } else {
                        return null;
                      }
                    },
                    keyboardType: TextInputType.number,
                    controller: productPriceController,
                    decoration: InputDecoration(
                      labelText: 'Product Price',
                    ),
                    onSaved: (value) => _price = int.parse(value.trim()),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 15),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Edit'),
              onPressed: () {
                if (formKey.currentState.validate()) {
                  formKey.currentState.save();

//                  print(_productName);
//                  print(_price);
//                  print(product.toMap());
                  ask(id: product.id, name: _productName, price: _price);
                }
              },
            ),
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

  void ask({@required String id, name, price}) {
    StreamController loading = StreamController();

    showDialog(
      context: context,
      barrierDismissible: false,
      // false = user must tap button, true = tap outside dialog
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Warning'),
          content: Text('Are You Sure You Want To Proceed'),
          actions: <Widget>[
            StreamBuilder(
                stream: loading.stream,
                builder: (context, snapshot) {
                  if (snapshot.data == null) {
                    return FlatButton(
                      child: Text('Yes'),
                      onPressed: () async {
                        loading.add('loading..');
                        await MarketMethods()
                            .updateProduct(
                          name: name,
                          id: id,
                          price: price,
                        )
                            .then((value) {
                          Navigator.pop(context);
                          Navigator.pop(context);
                          refresh();
                        });
                      },
                    );
                  } else {
                    return CircularProgressIndicator();
                  }
                }),
            FlatButton(
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

  void delete({@required String id}) {
    StreamController loading = StreamController();

    showDialog(
      context: context,
      barrierDismissible: false,
      // false = user must tap button, true = tap outside dialog
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Warning'),
          content: Text('Are You Sure You Want To Delete This Product'),
          actions: <Widget>[
            StreamBuilder(
                stream: loading.stream,
                builder: (context, snapshot) {
                  if (snapshot.data == null) {
                    return FlatButton(
                      child: Text('Yes'),
                      onPressed: () async {
                        loading.add('loading..');
                        await MarketMethods()
                            .deleteProduct(
                          id: id,
                        )
                            .then((value) {
                          Navigator.pop(context);
                          refresh();
                        });
                      },
                    );
                  } else {
                    return CircularProgressIndicator();
                  }
                }),
            FlatButton(
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

  Future<void> refresh() async {
    setState(() {
      loading = true;
    });
    await Future.delayed(Duration(milliseconds: 500));
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
                    .productRef
                    .where('productShopName',
                        isEqualTo: shopName.toString().trim())
                    .orderBy('dateAdded', descending: true),
                itemBuilder: (_, context, snap) {
                  ProductModel product = ProductModel.fromMap(snap.data);

                  return Container(
                    margin: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            displayMultiPic(imageList: product.imageUrls),
                            details(currentProduct: product),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            FlatButton(
                              color: Colors.green,
                              onPressed: () {
                                editPopUp(product: product);
                              },
                              child: Text('Edit Product Info'),
                            ),
                            FlatButton(
                              color: Colors.red,
                              onPressed: () {
                                delete(id: product.id);
//                                editPopUp(product: product);
                              },
                              child: Text('Delete Product'),
                            ),
                          ],
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
    );
  }

  Widget details({@required ProductModel currentProduct}) {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('productName: ${currentProduct.productName}'),
          Text('ShopName: ${currentProduct.productShopName}'),
          Text('Shop Email: ${currentProduct.productShopOwnerEmail}'),
          Text('Shop Number: ${currentProduct.productShopOwnerPhoneNumber}'),
          Text('Price: ${currentProduct.productPrice}'),
          Text('Category: ${currentProduct.productCategory}'),
//          Text('deliveryStatus: ${currentProduct.deliveryStatus}'),
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
                    current = index;
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
