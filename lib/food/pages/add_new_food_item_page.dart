import 'dart:io';
import 'package:flutter/rendering.dart';
import 'package:ohostel_hostel_agent_app/widgets/custom_button.dart';
import 'package:ohostel_hostel_agent_app/widgets/custom_smallButton.dart';
import 'package:ohostel_hostel_agent_app/widgets/styles.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ohostel_hostel_agent_app/food/food_methods.dart';
import 'package:ohostel_hostel_agent_app/food/models/food_details_model.dart';
import 'package:uuid/uuid.dart';

class AddNewFoodItemPage extends StatefulWidget {
  @override
  _AddNewFoodItemPageState createState() => _AddNewFoodItemPageState();
}

class _AddNewFoodItemPageState extends State<AddNewFoodItemPage> {
  final formKey = GlobalKey<FormState>();
  String fastFoodName;
  String _itemName;
  String _itemCategory;
  int _value;
  int _itemPrice;
  String _desc;
  File _foodImage;
  String _foodImageUrl;
  bool isSending = false;

  Future<void> selectItemImage() async {
    if (!mounted) return;
    setState(() {
      _foodImage = null;
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
        _foodImage = File(result.files.single.path);
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
    if (formKey.currentState.validate() &&
        _foodImage != null &&
        _itemCategory != null) {
      formKey.currentState.save();

      if (!mounted) return;

      setState(() {
        isSending = true;
      });

      _foodImageUrl = await getUrls(file: _foodImage);

      if (_foodImageUrl != null) {
        ItemDetails item = ItemDetails(
          itemName: _itemName,
          itemCategory: _itemCategory,
          price: _itemPrice,
          imageUrl: _foodImageUrl,
          shortDescription: _desc,
          itemFastFoodName: fastFoodName,
        );

//        print(item.toMap());
        await FoodMethods().saveFoodItemToServer(foodItems: item);
//        Fluttertoast.showToast(msg: 'Done');
      }

      if (!mounted) return;
      setState(() {
        isSending = false;
        formKey.currentState.reset();
        _itemCategory = null;
        _foodImageUrl = null;
        _foodImage = null;
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
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: ListView(
          children: [
            Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Add New Food Item', style: subTitle1TextStyle),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    margin: EdgeInsets.symmetric(vertical: 8),
                    decoration: boxDec,
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
                  ),
                  Container(
                    child: TextFormField(
                      validator: (value) {
                        if (value.trim().isEmpty) {
                          return 'item Name Can\'t Be Empty';
                        } else if (value.trim().length < 3) {
                          return 'item Name Must Be More Than 2 Characters';
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Item Name (e.g Fried rice)',
                      ),
                      onSaved: (value) => _itemName = value.trim(),
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
                              _itemCategory = val;
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: Container(
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.done,
                            validator: (value) {
                              if (value.trim().isEmpty) {
                                return 'Item Price Can\'t Be Empty';
                              } else if (value.trim().length < 3) {
                                return 'Item Price Must Be More Than 2 Characters';
                              } else {
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Item Price',
                            ),
                            onSaved: (value) =>
                                _itemPrice = int.parse(value.trim()),
                          ),
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            margin: EdgeInsets.only(top: 8,bottom: 8,left: 8),
                            decoration: boxDec,
                        ),
                      ),
                    ],
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
                        border: InputBorder.none,
                        hintText: 'Short Description',
                      ),
                      onSaved: (value) => _desc = value.trim(),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    margin: EdgeInsets.symmetric(vertical: 8),
                    decoration: boxDec,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.all(10.0),
                        child: Text("Item Image",style: titleTextStyle,),
                      ),
                      InkWell(
                        onTap: () {
                          selectItemImage();
                        },
                        child: Container(
                          decoration: boxDec,
                          child: (_foodImage == null)
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
                                    _foodImage,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 50),
                  isSending
                      ? CircularProgressIndicator()
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
