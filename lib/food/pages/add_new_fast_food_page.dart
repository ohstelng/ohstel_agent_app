import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:ohostel_hostel_agent_app/food/food_methods.dart';
import 'package:ohostel_hostel_agent_app/food/models/extras_food_details.dart';
import 'package:ohostel_hostel_agent_app/food/models/fast_food_details_model.dart';
import 'package:ohostel_hostel_agent_app/food/models/food_details_model.dart';
import 'package:ohostel_hostel_agent_app/hive_methods/hive_class.dart';
import 'package:uuid/uuid.dart';

class AddNewFastFood extends StatefulWidget {
  @override
  _AddNewFastFoodState createState() => _AddNewFastFoodState();
}

class _AddNewFastFoodState extends State<AddNewFastFood> {
  StreamController _uniNameController = StreamController.broadcast();
  final formKey = GlobalKey<FormState>();
  String fastFoodName;
  String address;
  String openTime;
  String uniName;
  String areaName = 'Select Area Name';
  File fastFoodImages;
  String fastFoodImageUrl;
  ItemDetails itemDetailSold;
  ExtraItemDetails extraItemDetails;
  String _itemName;
  String _itemCategory;
  int _value = 1;
  int _itemPrice;
  String _desc;
  File _foodImage;
  String _foodImageUrl;
  bool isSending = false;

  void _showEditUniDailog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Select Uni'),
          content: SizedBox(
            height: MediaQuery.of(context).size.height * 0.55,
            child: FutureBuilder(
              future: getUniList(),
              builder: (context, snapshot) {
                print(snapshot.data);
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                print(snapshot.data);
                Map data = snapshot.data;
                return Container(
                  width: double.maxFinite,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      List<String> uniList = data.keys.toList();
                      uniList.sort();
                      Map currentUniDetails = data[uniList[index]];

                      return Column(
                        children: <Widget>[
                          Container(
                              margin: EdgeInsets.only(left: 10.0, right: 10.0),
                              child: ListTile(
                                onTap: () {
//                                  print(currentUniDetails);
                                  _uniNameController
                                      .add(currentUniDetails['abbr']);
                                  Navigator.pop(context);
//                                  updateUni(uniDetails: currentUniDetails);
                                },
                                title: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.location_on,
                                      color: Colors.grey,
                                    ),
                                    Expanded(
                                      child: Text(
                                        '${currentUniDetails['name']}',
                                        maxLines: 1,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                subtitle: Text(
                                  '${currentUniDetails['abbr']}',
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.grey,
                                  ),
                                ),
                              )),
                          Divider(),
                        ],
                      );
                    },
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Future getUniList() async {
    String url = "https://quiz-demo-de79d.appspot.com/hostel_api/searchKeys";
    var response = await http.get(url);
    var result = json.decode(response.body);
    print(result);
    return result;
  }

  Future<void> selectImage() async {
    if (!mounted) return;
    setState(() {
      fastFoodImages = null;
    });

    try {
      FilePickerResult result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'png', 'jpg'],
      );

      if (result != null) {
        fastFoodImages = File(result.files.single.path);
      }

//      fastFoodImages = await FilePicker.getFile(
//        type: FileType.custom,
//        allowedExtensions: ['jpg', 'png', 'jpg'],
//      );
      setState(() {});
    } on Exception catch (e) {
      print(e);
      Fluttertoast.showToast(msg: '$e');
    }
  }

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
            uniName != null &&
            _itemCategory != null &&
            fastFoodImages != null &&
            _foodImage != null &&
            areaName != 'Select Area Name' ||
        null) {
      formKey.currentState.save();
      print('pass');

      setState(() {
        isSending = true;
      });

      fastFoodImageUrl = await getUrls(file: fastFoodImages);
      _foodImageUrl = await getUrls(file: _foodImage);

      if (fastFoodImageUrl != null && _foodImageUrl != null) {
        print('pass2');

        Map itemDetails = ItemDetails(
          itemName: _itemName,
          itemCategory: _itemCategory,
          price: _itemPrice,
          imageUrl: _foodImageUrl,
          shortDescription: _desc,
          itemFastFoodName: fastFoodName,
        ).toMap();

        FastFoodModel fastFood = FastFoodModel(
          fastFoodName: fastFoodName,
          address: address,
          openTime: openTime,
          logoImageUrl: fastFoodImageUrl,
          itemDetails: [itemDetails],
          extraItems: [],
          itemCategoriesList: [],
          haveExtras: false,
          uniName: uniName.toLowerCase(),
          locationName: areaName,
          display: true,
        );

        print(fastFood.toMap());
        await FoodMethods().saveFoodToServer(foodModel: fastFood);

        setState(() {
          isSending = false;
        });

        formKey.currentState.reset();
        fastFoodImages = null;
        _foodImage = null;
        uniName = null;
        _uniNameController.add(null);
      }
    } else {
      Fluttertoast.showToast(msg: 'Pls fill All Input');
    }
  }

  Future<Map> getAreaNamesFromApi() async {
    String uniName = await HiveMethods().getUniName();
    String url = 'https://quiz-demo-de79d.appspot.com/food_api/$uniName';
    var response = await http.get(url);
    Map data = json.decode(response.body);

    return data;
  }

  @override
  void initState() {
    _uniNameController.add('none selected');
    super.initState();
  }

  @override
  void dispose() {
    _uniNameController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Fast Food'),
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
                        return 'Fast Food Name Can\'t Be Empty';
                      } else if (value.trim().length < 3) {
                        return 'Fast Food Name Must Be More Than 2 Characters';
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      labelText: 'Fast Food Name',
                    ),
                    onSaved: (value) => fastFoodName = value.trim(),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 15),
                ),
                Container(
                  child: TextFormField(
                    validator: (value) {
                      if (value.trim().isEmpty) {
                        return 'Address Can\'t Be Empty';
                      } else if (value.trim().length < 3) {
                        return 'Address Must Be More Than 2 Characters';
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      labelText: 'Address',
                    ),
                    onSaved: (value) => address = value.trim(),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 15),
                ),
                Container(
                  child: TextFormField(
                    validator: (value) {
                      if (value.trim().isEmpty) {
                        return 'openTime Can\'t Be Empty';
                      } else if (value.trim().length < 3) {
                        return 'openTime Must Be More Than 2 Characters';
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      labelText: 'openTime (e.g, 8:00am - 10:00pm )',
                    ),
                    onSaved: (value) => openTime = value.trim(),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 15),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      FlatButton(
                        color: Colors.green,
                        onPressed: () {
                          _showEditUniDailog();
                        },
                        child: Text('Select Uni'),
                      ),
                      Container(
                        padding: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                        ),
                        child: StreamBuilder(
                          stream: _uniNameController.stream,
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Text('No Uni Selected');
                            } else {
                              uniName = snapshot.data;
                              return Text('${snapshot.data}');
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.all(10.0),
                      child: FlatButton(
                        onPressed: () {
                          selectImage();
                        },
                        color: Colors.green,
                        child: Text(
                          'Select Image',
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
                      child: (fastFoodImages == null)
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
                                fastFoodImages,
                                fit: BoxFit.fill,
                              ),
                            ),
                    )
                  ],
                ),
                ExpansionTile(
                  key: GlobalKey(),
                  title: Text('$areaName'),
                  leading: Icon(Icons.location_on),
                  children: <Widget>[
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .30,
                      child: FutureBuilder(
                        future: getAreaNamesFromApi(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          } else {
                            List areaNameList = snapshot.data['areaNames'];
                            return ListView.builder(
                              physics: BouncingScrollPhysics(),
                              itemCount: areaNameList.length,
                              itemBuilder: (context, index) {
                                String currentAreaName = areaNameList[index];
                                return InkWell(
                                  onTap: () {
                                    if (mounted) {
                                      setState(() {
                                        areaName = currentAreaName;
                                      });
                                    }
                                  },
                                  child: Container(
                                    margin: EdgeInsets.all(5.0),
                                    child: Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.add_location,
                                          color: Colors.grey,
                                        ),
                                        Text(
                                          '$currentAreaName',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w400),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
                //
                SizedBox(height: 40),
                Divider(thickness: 2, color: Colors.black),
                Text('Items Section'),
                Divider(thickness: 2, color: Colors.black),
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
                      labelText: 'Item Name (e.g Fried rice)',
                    ),
                    onSaved: (value) => _itemName = value.trim(),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 15),
                ),
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20.0),
                      child: DropdownButton(
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
                            labelText: 'Item Price',
                          ),
                          onSaved: (value) =>
                              _itemPrice = int.parse(value.trim()),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 15),
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
                      child: (_foodImage == null)
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
                                _foodImage,
                                fit: BoxFit.fill,
                              ),
                            ),
                    )
                  ],
                ),

                //
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
          ),
        ],
      ),
    );
  }
}
