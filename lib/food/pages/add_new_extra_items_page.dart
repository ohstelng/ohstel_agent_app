import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ohostel_hostel_agent_app/food/food_methods.dart';
import 'package:ohostel_hostel_agent_app/food/models/extras_food_details.dart';
import 'package:ohostel_hostel_agent_app/widgets/custom_button.dart';
import 'package:ohostel_hostel_agent_app/widgets/styles.dart';
import 'package:uuid/uuid.dart';

class AddExtraItemPage extends StatefulWidget {
  @override
  _AddExtraItemPageState createState() => _AddExtraItemPageState();
}

class _AddExtraItemPageState extends State<AddExtraItemPage> {
  final formKey = GlobalKey<FormState>();
  String fastFoodName;
  String _extraItemName;
  String _extraItemCategory;
  int _value;
  int _extraItemPrice;
  String _desc;
  File _extraFoodImage;
  String _extraFoodImageUrl;
  bool isSending = false;

  Future<void> selectItemImage() async {
    if (!mounted) return;
    setState(() {
      _extraFoodImage = null;
    });

    try {
      FilePickerResult result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'png', 'jpg'],
      );

      if (result != null) {
        _extraFoodImage = File(result.files.single.path);
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
    if (formKey.currentState.validate() && _extraItemCategory != null) {
      formKey.currentState.save();

      if (!mounted) return;

      setState(() {
        isSending = true;
      });

      if (_extraFoodImage != null) {
        _extraFoodImageUrl = await getUrls(file: _extraFoodImage);
      }

      ExtraItemDetails item = ExtraItemDetails(
        extraItemName: _extraItemName,
        extraCategory: _extraItemCategory,
        price: _extraItemPrice,
        imageUrl: _extraFoodImageUrl,
        shortDescription: _desc,
        extraItemFastFoodName: fastFoodName,
      );

      print(item.toMap());
      await FoodMethods().saveExtraFoodItemToServer(extraFoodItems: item);
      Fluttertoast.showToast(msg: 'Done');

      if (!mounted) return;
      setState(() {
        isSending = false;
        formKey.currentState.reset();
        _extraItemCategory = null;
        _extraFoodImageUrl = null;
        _extraFoodImage = null;
      });
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
                    'Add Extra Food Item',
                    style: subTitle1TextStyle,
                  ),
                  Container(
                    child: TextFormField(
                      validator: (value) {
                        if (value.trim().isEmpty) {
                          return 'Fast Food Name Can\'t Be Empty';
                        } else if (value.trim().length < 3) {
                          return 'Fast Food Name Must Be More Than 2 Characters';
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Fast Food Name',
                      ),
                      onSaved: (value) => fastFoodName = value.trim(),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    margin: EdgeInsets.symmetric(vertical: 8),
                    decoration: boxDec,
                  ),
                  Container(
                    child: TextFormField(
                      validator: (value) {
                        if (value.trim().isEmpty) {
                          return 'Extra Item Name Can\'t Be Empty';
                        } else if (value.trim().length < 3) {
                          return 'Extra Item Name Must Be More Than 2 Characters';
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Extra Item Name (e.g meat)',
                      ),
                      onSaved: (value) => _extraItemName = value.trim(),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    margin: EdgeInsets.symmetric(vertical: 8),
                    decoration: boxDec,
                  ),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        margin: EdgeInsets.symmetric(vertical: 8),
                        decoration: boxDec,
                        child: DropdownButton(
                          underline: SizedBox(),
                          hint: Text('None Selected'),
                          value: _value,
                          items: [
                            DropdownMenuItem(
                              child: Text("Cooked Food"),
                              value: 1,
                            ),
                            DropdownMenuItem(
                              child: Text("Snacks"),
                              value: 2,
                            ),
                          ],
                          onChanged: (value) {
                            String val;
                            if (value == 1) {
                              val = 'cookedFood';
                            } else {
                              val = 'snacks';
                            }
                            setState(() {
                              _value = value;
                              _extraItemCategory = val;
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          margin: EdgeInsets.only(left: 8),
                          decoration: boxDec,
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.done,
                            validator: (value) {
                              if (value.trim().isEmpty) {
                                return 'Extra Item Price Can\'t Be Empty';
                              } else if (value.trim().length < 3) {
                                return 'Extra Item Price Must Be More Than 2 Characters';
                              } else {
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Extra Item Price',
                            ),
                            onSaved: (value) =>
                                _extraItemPrice = int.parse(value.trim()),
                          ),
                        ),
                      ),
                    ],
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
                          child: Text(
                            'Select Item Image',
                            style: titleTextStyle,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            selectItemImage();
                          },
                          child: Container(
                            decoration: boxDec,
                            child: (_extraFoodImage == null)
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
                                      _extraFoodImage,
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
                      ? Center(child: CircularProgressIndicator())
                      : LongButton(
                          onPressed: () {
                            saveData();
                          },
                          label: 'Save',
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
