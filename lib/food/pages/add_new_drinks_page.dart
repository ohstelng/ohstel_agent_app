import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ohostel_hostel_agent_app/food/food_methods.dart';
import 'package:ohostel_hostel_agent_app/food/models/food_details_model.dart';
import 'package:uuid/uuid.dart';

class AddNewDrinksPage extends StatefulWidget {
  @override
  _AddNewDrinksPageState createState() => _AddNewDrinksPageState();
}

class _AddNewDrinksPageState extends State<AddNewDrinksPage> {
  final formKey = GlobalKey<FormState>();
  String fastFoodName;
  String _itemName;
  int _value;
  int _itemPrice;
  String _desc;
  File _drinkImage;
  String _drinkImageUrl;
  bool isSending = false;

  Future<void> selectItemImage() async {
    if (!mounted) return;
    setState(() {
      _drinkImage = null;
    });

    try {
//      _foodImage = await FilePicker.getFile(
//        type: FileType.custom,
//        allowedExtensions: ['jpg', 'png', 'jpg'],
//      );
      FilePickerResult result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'png', 'jpg'],
      );

      if (result != null) {
        _drinkImage = File(result.files.single.path);
      }

      setState(() {});
    } on Exception catch (e) {
      print(e);
      Fluttertoast.showToast(msg: '$e');
    }
  }

  Future<dynamic> getUrls({@required File file}) async {
    try {
      StorageReference storageReference =
          FirebaseStorage.instance.ref().child('food/${Uuid().v1()}');

      StorageUploadTask uploadTask = storageReference.putFile(file);

      await uploadTask.onComplete;
      print('File Uploaded');

      String url = await storageReference.getDownloadURL();

      return url;
    } catch (err) {
      print(err);
      Fluttertoast.showToast(msg: err);
    }
  }

  Future<void> saveData() async {
    if (formKey.currentState.validate() && _drinkImage != null) {
      formKey.currentState.save();

      if (!mounted) return;

      setState(() {
        isSending = true;
      });

      _drinkImageUrl = await getUrls(file: _drinkImage);

      if (_drinkImageUrl != null) {
        ItemDetails item = ItemDetails(
          itemName: _itemName,
          itemCategory: 'drinks',
          price: _itemPrice,
          imageUrl: _drinkImageUrl,
          shortDescription: _desc,
          itemFastFoodName: 'drinks',
        );

//        print(item.toMap());
        await FoodMethods().saveDrinkToServer(itemDetails: item);
//        Fluttertoast.showToast(msg: 'Done');
      }

      if (!mounted) return;
      setState(() {
        isSending = false;
//        formKey.currentState.reset();
////        _itemCategory = null;
//        _drinkImageUrl = null;
//        _drinkImage = null;
      });

      formKey.currentState.reset();
    } else {
      Fluttertoast.showToast(msg: 'Pls Fill All Inputs');
      if (!mounted) return;
      setState(() {
        isSending = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Drink Item'),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
      ),
      body: ListView(
        children: [
          Form(
            key: formKey,
            child: Column(
              children: [
                Container(
                  child: TextFormField(
                    validator: (value) {
                      if (value.trim().isEmpty) {
                        return 'Drink Name Can\'t Be Empty';
                      } else if (value.trim().length < 3) {
                        return 'Drink Name Must Be More Than 2 Characters';
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      labelText: 'Drink Name (e.g Fried rice)',
                    ),
                    onSaved: (value) => _itemName = value.trim(),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 15),
                ),
                Container(
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    validator: (value) {
                      if (value.trim().isEmpty) {
                        return 'Drink Price Can\'t Be Empty';
                      } else if (value.trim().length < 3) {
                        return 'Drink Price Must Be More Than 2 Characters';
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      labelText: 'Drink Price',
                    ),
                    onSaved: (value) => _itemPrice = int.parse(value.trim()),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 15),
                ),
                Container(
                  child: TextFormField(
                    maxLines: null,
                    validator: (value) {
                      if (value.trim().isEmpty) {
                        return 'desc Can\'t Be Empty';
                      } else if (value.trim().length < 3) {
                        return 'desc Must Be More Than 2 Characters';
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      labelText: 'short Description',
                    ),
                    onSaved: (value) => _desc = value.trim(),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 15),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.all(10.0),
                      child: FlatButton(
                        onPressed: () {
                          selectItemImage();
                        },
                        color: Colors.green,
                        child: Text(
                          'Select Item Image',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.grey,
                      ),
                      child: (_drinkImage == null)
                          ? Container(
                              height: 150,
                              width: 150,
                              child: Icon(
                                Icons.image,
                                color: Colors.black,
                              ),
                            )
                          : Container(
                              height: 200,
                              width: 250,
                              child: Image.file(
                                _drinkImage,
                                fit: BoxFit.fill,
                              ),
                            ),
                    )
                  ],
                ),
                SizedBox(height: 50),
                isSending
                    ? CircularProgressIndicator()
                    : FlatButton(
                        color: Colors.green,
                        onPressed: () {
                          saveData();
                        },
                        child: Text('Save'),
                      ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
