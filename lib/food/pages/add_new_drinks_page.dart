import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ohostel_hostel_agent_app/food/food_methods.dart';
import 'package:ohostel_hostel_agent_app/food/models/food_details_model.dart';
import 'package:ohostel_hostel_agent_app/widgets/custom_button.dart';
import 'package:ohostel_hostel_agent_app/widgets/styles.dart';
import 'package:uuid/uuid.dart';

class AddNewDrinksPage extends StatefulWidget {
  @override
  _AddNewDrinksPageState createState() => _AddNewDrinksPageState();
}

class _AddNewDrinksPageState extends State<AddNewDrinksPage> {
  final formKey = GlobalKey<FormState>();
  String fastFoodName;
  String _itemName;
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

        print(item.toMap());
        await FoodMethods().saveDrinkToServer(itemDetails: item);
        Fluttertoast.showToast(msg: 'Done');
      }

      if (!mounted) return;
      setState(() {
        isSending = false;
        _drinkImageUrl = null;
        _drinkImage = null;
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
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 24, horizontal: 8),
        child: ListView(
          children: [
            Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Add New Drink Item',
                    style: subTitle1TextStyle,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    margin: EdgeInsets.symmetric(vertical: 8),
                    decoration: boxDec,
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
                        border: InputBorder.none,
                        hintText: 'Drink Name (e.g Fried rice)',
                      ),
                      onSaved: (value) => _itemName = value.trim(),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    margin: EdgeInsets.symmetric(vertical: 8),
                    decoration: boxDec,
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
                        border: InputBorder.none,
                        hintText: 'Drink Price',
                      ),
                      onSaved: (value) => _itemPrice = int.parse(value.trim()),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    margin: EdgeInsets.symmetric(vertical: 8),
                    decoration: boxDec,
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
                        border: InputBorder.none,
                        hintText: 'Short Description',
                      ),
                      onSaved: (value) => _desc = value.trim(),
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.all(10.0),
                          child:
                              Text("Select Item Image", style: titleTextStyle),
                        ),
                        InkWell(
                          onTap: () {
                            selectItemImage();
                          },
                          child: Container(
                            decoration: boxDec,
                            child: (_drinkImage == null)
                                ? Container(
                                    height: 150,
                                    width: 150,
                                    child: Icon(
                                      Icons.add_a_photo,
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
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 50),
                  isSending
                      ? CircularProgressIndicator()
                      : LongButton(
                          onPressed: () {
                            saveData();
                          },
                          label: "Save",
                        ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
