import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ohostel_hostel_agent_app/market_place/models/paid_market_orders_model.dart';
import 'package:ohostel_hostel_agent_app/market_place/models/product_model.dart';

class MarketMethods {
  CollectionReference productRef = Firestore.instance
      .collection('market')
      .document('products')
      .collection('allProducts');

  CollectionReference productOrdersRef =
      Firestore.instance.collection('marketOrders');

  CollectionReference productCategoriesRef = Firestore.instance
      .collection('market')
      .document('categories')
      .collection('productsList');

  Future saveProductToServer({@required ProductModel productModel}) async {
    try {
      print('saving');
      await productRef.document(productModel.id).setData(productModel.toMap());
      print('saved');
    } catch (err) {
      print(err);
      Fluttertoast.showToast(msg: '$err');
    }
  }

  Future updateOrder(
      {@required PaidOrderModel paidOrder, @required String id}) async {
    bool doneWith = false;
    try {
      print('saving');
      print(id);
      print('saving');

      paidOrder.orders.forEach((element) {
        Map data = element;
        String status = data['deliveryStatus'];
        if (status == 'Delivered To Buyer') {
          doneWith = true;
        } else {
          doneWith = false;
        }
        print(doneWith);
      });

      await productOrdersRef.document(id).updateData({
        'orders': paidOrder.orders,
        'doneWith': doneWith,
      });
      print('Updated!!');
      Fluttertoast.showToast(msg: 'Updated!!');
    } catch (err) {
      print(err);
      Fluttertoast.showToast(msg: '$err');
    }
  }

  Future updateProduct({
    @required String name,
    @required String id,
    @required int price,
  }) async {
    print(id);
    try {
      print('saving');
      await productRef.document(id).updateData({
        'productName': name,
        'productPrice': price,
      });
      print('Updated!!');
      Fluttertoast.showToast(msg: 'Updated!!');
    } catch (err) {
      print(err);
      Fluttertoast.showToast(msg: '$err');
    }
  }

  Future deleteProduct({@required String id}) async {
    print(id);
    try {
      print('Deleted');
      await productRef.document(id).delete();
      print('Deleted!!');
      Fluttertoast.showToast(msg: 'Deleted!!');
    } catch (err) {
      print(err);
      Fluttertoast.showToast(msg: '$err');
    }
  }
}
