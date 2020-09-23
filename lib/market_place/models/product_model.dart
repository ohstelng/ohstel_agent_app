import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';

class ProductModel {
  String productName;
  List<String> imageUrls;
  String productCategory;
  String productOriginLocation;
  String productSubCategory;
  String productDescription;
  int productPrice;
  String productShopName;
  String productShopOwnerEmail;
  int productShopOwnerPhoneNumber;
  Timestamp dateAdded;
  List<String> searchKeys;
  String id = Uuid().v1().toString();

  ProductModel({
    @required this.productName,
    @required this.imageUrls,
    @required this.productCategory,
    @required this.productOriginLocation,
    @required this.productDescription,
    @required this.productSubCategory,
    @required this.productPrice,
    @required this.productShopName,
    @required this.productShopOwnerEmail,
    @required this.productShopOwnerPhoneNumber,
  });

  ProductModel.fromMap(Map<String, dynamic> mapData) {
    this.productName = mapData['productName'];
    this.imageUrls = mapData['imageUrls'].cast<String>();
    this.productCategory = mapData['productCategory'];
    this.productOriginLocation = mapData['productOriginLocation'];
    this.productSubCategory = mapData['productSubCategory'];
    this.productDescription = mapData['productDescription'];
    this.productPrice = mapData['productPrice'];
    this.productShopName = mapData['productShopName'];
    this.productShopOwnerEmail = mapData['productShopOwnerEmail'];
    this.productShopOwnerPhoneNumber =
        int.parse(mapData['productShopOwnerPhoneNumber']);
    this.dateAdded = mapData['dateAdded'];
    this.id = mapData['id'];
    this.searchKeys = mapData['searchKeys'].cast<String>();
  }

  Map toMap() {
    Map data = Map<String, dynamic>();
    List _searchKeys = [];

    String prodCat = this.productCategory.toLowerCase();
    var prodNames = this.productName.split(' ');
    String prodshopOwnerName = this.productShopName.toLowerCase();
    String prodSubCat = this.productSubCategory.toLowerCase();

    _searchKeys.add(prodCat);
    _searchKeys.add(prodshopOwnerName);
    _searchKeys.add(prodSubCat.toLowerCase());
    prodNames.forEach((element) {
      _searchKeys.add(element.toLowerCase());
    });

    data['productName'] = this.productName.toLowerCase();
    data['imageUrls'] = this.imageUrls;
    data['productCategory'] = this.productCategory.toLowerCase();
    data['productOriginLocation'] = this.productOriginLocation.toLowerCase();
    data['productSubCategory'] = this.productSubCategory.toLowerCase();
    data['productDescription'] = this.productDescription.toLowerCase();
    data['productShopName'] = this.productShopName.toLowerCase();
    data['productShopOwnerEmail'] = this.productShopOwnerEmail;
    data['productShopOwnerPhoneNumber'] =
        this.productShopOwnerPhoneNumber.toString();
    data['productPrice'] = this.productPrice;
    data['dateAdded'] = Timestamp.now();
    data['id'] = this.id;
    data['searchKeys'] = _searchKeys;

    return data;
  }
}

//List<ProductModel> list = [
//  ProductModel(
//    productName: 'Dangote Sugars',
//    imageUrls: [
//      'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSVUlqCtI1EqLkv0Tt2MyIo3qdZgJl9aPsn1Q&usqp=CAU',
//      'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSVUlqCtI1EqLkv0Tt2MyIo3qdZgJl9aPsn1Q&usqp=CAU',
//      'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSVUlqCtI1EqLkv0Tt2MyIo3qdZgJl9aPsn1Q&usqp=CAU',
//    ],
//    productCategory: 'Foodstuff',
//    productSubCategory: 'Sugars',
//    productDescription: 'this wiil contain product description',
//    productPrice: 500,
//    productShopName: 'ola',
//    productShopOwnerEmail: 'olashop123@gmail.com',
//    productShopOwnerPhoneNumber: 08099776655,
//    productOriginLocation: 'unilorin',
//  ),
//  ProductModel(
//    productName: 'Kings oil',
//    imageUrls: [
//      'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSVUlqCtI1EqLkv0Tt2MyIo3qdZgJl9aPsn1Q&usqp=CAU',
//      'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSVUlqCtI1EqLkv0Tt2MyIo3qdZgJl9aPsn1Q&usqp=CAU',
//      'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSVUlqCtI1EqLkv0Tt2MyIo3qdZgJl9aPsn1Q&usqp=CAU',
//    ],
//    productCategory: 'Foodstuff',
//    productSubCategory: 'Oil',
//    productDescription: 'this wiil contain product description',
//    productPrice: 500,
//    productShopName: 'ola',
//    productShopOwnerEmail: 'olashop123@gmail.com',
//    productShopOwnerPhoneNumber: 08099776655,
//    productOriginLocation: 'unilorin',
//  ),
//  ProductModel(
//    productName: 'Holladia Yoghurt',
//    imageUrls: [
//      'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSVUlqCtI1EqLkv0Tt2MyIo3qdZgJl9aPsn1Q&usqp=CAU',
//      'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSVUlqCtI1EqLkv0Tt2MyIo3qdZgJl9aPsn1Q&usqp=CAU',
//      'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSVUlqCtI1EqLkv0Tt2MyIo3qdZgJl9aPsn1Q&usqp=CAU',
//    ],
//    productCategory: 'Foodstuff',
//    productSubCategory: 'Drinks',
//    productDescription: 'this wiil contain product description',
//    productPrice: 500,
//    productShopName: 'ola',
//    productShopOwnerEmail: 'olashop123@gmail.com',
//    productShopOwnerPhoneNumber: 08099776655,
//    productOriginLocation: 'unilorin',
//  ),
//  ProductModel(
//    productName: 'Red Blanket',
//    imageUrls: [
//      'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSVUlqCtI1EqLkv0Tt2MyIo3qdZgJl9aPsn1Q&usqp=CAU',
//      'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSVUlqCtI1EqLkv0Tt2MyIo3qdZgJl9aPsn1Q&usqp=CAU',
//      'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSVUlqCtI1EqLkv0Tt2MyIo3qdZgJl9aPsn1Q&usqp=CAU',
//    ],
//    productCategory: 'Bed and Beddings',
//    productSubCategory: 'Blanket',
//    productDescription: 'this wiil contain product description',
//    productPrice: 500,
//    productShopName: 'ola',
//    productShopOwnerEmail: 'olashop123@gmail.com',
//    productShopOwnerPhoneNumber: 08099776655,
//    productOriginLocation: 'unilorin',
//  ),
//  ProductModel(
//    productName: 'Vita Foam',
//    imageUrls: [
//      'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSVUlqCtI1EqLkv0Tt2MyIo3qdZgJl9aPsn1Q&usqp=CAU',
//      'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSVUlqCtI1EqLkv0Tt2MyIo3qdZgJl9aPsn1Q&usqp=CAU',
//      'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSVUlqCtI1EqLkv0Tt2MyIo3qdZgJl9aPsn1Q&usqp=CAU',
//    ],
//    productCategory: 'Bed and Beddings',
//    productSubCategory: 'Mattress',
//    productDescription: 'this wiil contain product description',
//    productPrice: 500,
//    productShopName: 'ola',
//    productShopOwnerEmail: 'olashop123@gmail.com',
//    productShopOwnerPhoneNumber: 08099776655,
//    productOriginLocation: 'unilorin',
//  ),
//  ProductModel(
//    productName: 'Fila Polo',
//    imageUrls: [
//      'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSVUlqCtI1EqLkv0Tt2MyIo3qdZgJl9aPsn1Q&usqp=CAU',
//      'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSVUlqCtI1EqLkv0Tt2MyIo3qdZgJl9aPsn1Q&usqp=CAU',
//      'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSVUlqCtI1EqLkv0Tt2MyIo3qdZgJl9aPsn1Q&usqp=CAU',
//    ],
//    productCategory: 'Men Fashion',
//    productSubCategory: 'Clothing',
//    productDescription: 'this wiil contain product description',
//    productPrice: 500,
//    productShopName: 'ola',
//    productShopOwnerEmail: 'olashop123@gmail.com',
//    productShopOwnerPhoneNumber: 08099776655,
//    productOriginLocation: 'unilorin',
//  ),
//  ProductModel(
//    productName: 'Nike Shoes',
//    imageUrls: [
//      'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSVUlqCtI1EqLkv0Tt2MyIo3qdZgJl9aPsn1Q&usqp=CAU',
//      'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSVUlqCtI1EqLkv0Tt2MyIo3qdZgJl9aPsn1Q&usqp=CAU',
//      'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSVUlqCtI1EqLkv0Tt2MyIo3qdZgJl9aPsn1Q&usqp=CAU',
//    ],
//    productCategory: 'Men Fashion',
//    productSubCategory: 'Men Shoes',
//    productDescription: 'this wiil contain product description',
//    productPrice: 500,
//    productShopName: 'ola',
//    productShopOwnerEmail: 'olashop123@gmail.com',
//    productShopOwnerPhoneNumber: 08099776655,
//    productOriginLocation: 'unilorin',
//  ),
//  ProductModel(
//    productName: 'Apple watch',
//    imageUrls: [
//      'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSVUlqCtI1EqLkv0Tt2MyIo3qdZgJl9aPsn1Q&usqp=CAU',
//      'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSVUlqCtI1EqLkv0Tt2MyIo3qdZgJl9aPsn1Q&usqp=CAU',
//      'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSVUlqCtI1EqLkv0Tt2MyIo3qdZgJl9aPsn1Q&usqp=CAU',
//    ],
//    productCategory: 'Men Fashion',
//    productSubCategory: 'Men Watches',
//    productDescription: 'this wiil contain product description',
//    productPrice: 500,
//    productShopName: 'ola shop',
//    productShopOwnerEmail: 'olashop123@gmail.com',
//    productShopOwnerPhoneNumber: 08099776655,
//    productOriginLocation: 'unilorin',
//  ),
//  ProductModel(
//    productName: 'NoteBooks',
//    imageUrls: [
//      'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSVUlqCtI1EqLkv0Tt2MyIo3qdZgJl9aPsn1Q&usqp=CAU',
//      'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSVUlqCtI1EqLkv0Tt2MyIo3qdZgJl9aPsn1Q&usqp=CAU',
//      'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSVUlqCtI1EqLkv0Tt2MyIo3qdZgJl9aPsn1Q&usqp=CAU',
//    ],
//    productCategory: 'Educational Needs',
//    productSubCategory: 'Stationery',
//    productDescription: 'this wiil contain product description',
//    productPrice: 500,
//    productShopName: 'teni',
//    productShopOwnerEmail: 'teniShop123@gmail.com',
//    productShopOwnerPhoneNumber: 08011223344,
//    productOriginLocation: 'unilag',
//  ),
//  ProductModel(
//    productName: 'School Bag',
//    imageUrls: [
//      'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSVUlqCtI1EqLkv0Tt2MyIo3qdZgJl9aPsn1Q&usqp=CAU',
//      'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSVUlqCtI1EqLkv0Tt2MyIo3qdZgJl9aPsn1Q&usqp=CAU',
//      'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSVUlqCtI1EqLkv0Tt2MyIo3qdZgJl9aPsn1Q&usqp=CAU',
//    ],
//    productCategory: 'Educational Needs',
//    productSubCategory: 'School Bags',
//    productDescription: 'this wiil contain product description',
//    productPrice: 500,
//    productShopName: 'teni',
//    productShopOwnerEmail: 'teniShop123@gmail.com',
//    productShopOwnerPhoneNumber: 08011223344,
//    productOriginLocation: 'unilag',
//  ),
//];
//
/////
//
//List<Map> catList = [
//  {
//    'searchKey': 'Bed and Beddings',
//    'imageUrl':
//        'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcS5pnms0lVT0jKIN7MlIGMXW15dZRAvjFeTvQ&usqp=CAU'
//  },
//  {
//    'searchKey': 'Educational Needs',
//    'imageUrl':
//        'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSoQI17QtBhJqhWNiPSyTVj6U3v2Bm7je2mEg&usqp=CAU'
//  },
//  {
//    'searchKey': 'Foodstuff',
//    'imageUrl':
//        'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTJQC1IZE_j8hQTXDNgAZCL9zePHuok4n51xg&usqp=CAU'
//  },
//  {
//    'searchKey': 'Health and Beauty',
//    'imageUrl':
//        'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcR6cYb8w8LcRt11k2wijpkVjPfLA3qeBgn0aw&usqp=CAU'
//  },
//  {
//    'searchKey': 'Hostel Cleaning',
//    'imageUrl':
//        'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcRB0_N9ii4KMjIpe56pYCWd9TdQ6wHClfVx2A&usqp=CAU'
//  },
//  {
//    'searchKey': 'Men Fashion',
//    'imageUrl':
//        'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcReh2rKhXB4vWgcmIjFQ82Z9dO8xcqeF0dWlA&usqp=CAU'
//  },
//  {
//    'searchKey': 'Phone and Tablets',
//    'imageUrl':
//        'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTAVFkjYl6n4fgpSfJkKF_OWn0cjFdqTUfDiA&usqp=CAU'
//  },
//  {
//    'searchKey': 'Women Fashion',
//    'imageUrl':
//        'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTCmF8OLf8CW3ffRr0a743R5biIdkSW3x2ZVg&usqp=CAU'
//  },
//];
//
////void savecat() async {
////  final CollectionReference marketRef = Firestore.instance.collection('market');
////
////  for (Map i in catList) {
////    await marketRef
////        .document('categories')
////        .collection('productsList')
////        .document(i['searchKey'])
////        .setData(i.cast<String, dynamic>());
////  }
////}
//
//Future<void> saveProduct() async {
//  final CollectionReference collectionReference =
//      Firestore.instance.collection('market');
//
//  for (ProductModel productModel in list) {
//    print(productModel.productOriginLocation);
////    print(list.length);
//    await collectionReference
//        .document('products')
//        .collection('allProducts')
//        .document(productModel.id)
//        .setData(productModel.toMap());
//  }
//}
