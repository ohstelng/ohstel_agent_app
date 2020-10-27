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

  final CollectionReference shopCollection =
      Firestore.instance.collection('shopOwnersData');

  CollectionReference productCategoriesRef = Firestore.instance
      .collection('market')
      .document('categories')
      .collection('productsList');

  Future saveProductToServer({@required ProductModel productModel}) async {
    var dateParse = DateTime.parse(DateTime.now().toString());
    Firestore db = Firestore.instance;
    var batch = db.batch();

    try {
      print('saving');

      await shopCollection
          .where('shopName', isEqualTo: productModel.productShopName)
          .getDocuments()
          .then((doc) {
        print(doc.documents);

        /// get first document. note they can only be one shop with a particular name
        /// so this will always return a list of one document snapshot. So ill just take the
        /// first one
        DocumentSnapshot document = doc.documents[0];

        /// Now will can perform our batch write
        batch.setData(
          shopCollection.document(document.documentID),
          {"numberOfProducts": FieldValue.increment(1)},
          merge: true,
        );
      });

      batch.setData(
        productRef.document(productModel.id),
        productModel.toMap(),
      );

      await batch.commit();
      print('saved');
      Fluttertoast.showToast(msg: 'Saved To Database');
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

  Future<void> makePartneredShop({@required String shopName}) async {
    try {
      await shopCollection
          .where('shopName', isEqualTo: shopName)
          .getDocuments()
          .then((shop) async {
        print(shop.documents.length);

        /// since there can be only one shop with a particular name "shop.documents"
        /// will return an array of one element. So we'll just take the first
        String shopId = shop.documents[0].documentID;

        await shopCollection.document(shopId).updateData({
          'isPartner': true,
        });

        Fluttertoast.showToast(msg: 'Done');
      });
    } catch (e, s) {
      print(e);
      print(s);
      Fluttertoast.showToast(msg: 'Error: $e');
    }
  }

  Future<void> undoPartneredShop({@required String shopName}) async {
    try {
      await shopCollection
          .where('shopName', isEqualTo: shopName)
          .getDocuments()
          .then((shop) async {
        print(shop.documents.length);

        /// since there can be only one shop with a particular name "shop.documents"
        /// will return an array of one element. So we'll just take the first
        String shopId = shop.documents[0].documentID;

        await shopCollection.document(shopId).updateData({
          'isPartner': false,
        });

        Fluttertoast.showToast(msg: 'Undo Done');
      });
    } catch (e, s) {
      print(e);
      print(s);
      Fluttertoast.showToast(msg: 'Error: $e');
    }
  }
}
