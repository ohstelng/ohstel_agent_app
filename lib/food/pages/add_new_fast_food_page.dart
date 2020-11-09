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
import 'package:ohostel_hostel_agent_app/widgets/custom_button.dart';
import 'package:ohostel_hostel_agent_app/widgets/custom_smallButton.dart';
import 'package:ohostel_hostel_agent_app/widgets/done_popup.dart';
import 'package:ohostel_hostel_agent_app/widgets/styles.dart' as Styles;
import 'package:uuid/uuid.dart';

import '../../constant.dart';

class AddNewFastFood extends StatefulWidget {
  @override
  _AddNewFastFoodState createState() => _AddNewFastFoodState();
}

class _AddNewFastFoodState extends State<AddNewFastFood> {
  StreamController _stateLocationController = StreamController.broadcast();
  StreamController _mainAreaController = StreamController.broadcast();
  final formKey = GlobalKey<FormState>();
  bool hasBatchTimeList = false;
  TimeOfDay time = TimeOfDay.now();
  bool loading = false;
  String fastFoodName;
  String address;
  String openTime;
  String stateLocation;
  String mainArea;
  String foodFastLocation = 'Select Area Name';
  File fastFoodImages;
  String fastFoodImageUrl;
  ItemDetails itemDetailSold;
  ExtraItemDetails extraItemDetails;
  String _itemName;
  String _itemCategory;
  int _value = 1;
  String _itemPrice;
  String _desc;
  File _foodImage;
  String _foodImageUrl;
  bool isSending = false;

  Future<void> selectStatePopUp() async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Select State'),
          content: SizedBox(
            height: MediaQuery.of(context).size.height * 0.55,
            child: FutureBuilder(
              future: getAllFoodLocation(),
              builder: (context, snapshot) {
                print(snapshot.data);
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Text('Error!');
                }

                print(snapshot.data);
                List data = snapshot.data;
                return Container(
                  width: double.maxFinite,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      String currentState = data[index];
                      return Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(left: 10.0, right: 10.0),
                            child: InkWell(
                              onTap: () async {
                                _stateLocationController.add(currentState);
                                Navigator.pop(context);
                              },
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.location_on,
                                    color: Colors.grey,
                                  ),
                                  Text(
                                    '$currentState',
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
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
    setState(() {});
  }

  Future<void> selectMainAreaPopUp() async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Select Main Area'),
          content: SizedBox(
            height: MediaQuery.of(context).size.height * 0.55,
            child: FutureBuilder(
              future: getAllFoodMainAreaLocation(),
              builder: (context, snapshot) {
                print(snapshot.data);
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Text('Error!');
                }

                print(snapshot.data);
                List data = snapshot.data;
                return Container(
                  width: double.maxFinite,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      String currentState = data[index];
                      return Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(left: 10.0, right: 10.0),
                            child: InkWell(
                              onTap: () async {
                                _mainAreaController.add(currentState);
                                Navigator.pop(context);
                              },
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.location_on,
                                    color: Colors.grey,
                                  ),
                                  Text(
                                    '$currentState',
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
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
    setState(() {});
  }

  Future getAllFoodLocation() async {
    String url = baseApiUrl + "/food_api/all_food_location";

    try {
      var response = await http.get(url);
      var result = json.decode(response.body);
      print(result);
      return result;
    } on FormatException catch (e) {
      return [];
    } catch (e, s) {
      print(e);
      print(s);
      return ['None Found!'];
    }
  }

  Future getAllFoodMainAreaLocation() async {
    String url = baseApiUrl + "/food_api/main_areas/?state=${stateLocation.toLowerCase()}";
    print(url);

    try {
      var response = await http.get(url);
      var result = json.decode(response.body);
      print(result);
      return result;
    } on FormatException catch (e) {
      return [];
    } catch (e, s) {
      print(e);
      print(s);
      return ['None Found!'];
    }
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
            _itemCategory != null &&
            fastFoodImages != null &&
            _foodImage != null &&
            mainArea != null &&
            stateLocation != null &&
            foodFastLocation != 'Select Area Name' ||
        foodFastLocation != null) {
      formKey.currentState.save();
      print('pass');

      print(fastFoodName);
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
          price: int.parse(_itemPrice),
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
//          locationName: areaName,
          display: true,
          hasBatchTime: hasBatchTimeList,
          stateLocation: stateLocation.toLowerCase(),
          foodFastLocation: foodFastLocation.toLowerCase(),
          mainArea: mainArea.toLowerCase(),
        );

        print(fastFood.toMap());
        await FoodMethods().saveFoodToServer(foodModel: fastFood);
        showDonePopUp(context: context, message: 'Done');

        setState(() {
          isSending = false;
        });

        formKey.currentState.reset();
        fastFoodImages = null;
        _foodImage = null;
        _value = null;
        _itemCategory = null;
        stateLocation = null;
        foodFastLocation = null;
        mainArea = null;
        _stateLocationController.add(null);
        _mainAreaController.add(null);
      }
    } else {
      Fluttertoast.showToast(msg: 'Pls fill All Input');
    }
  }

  Future<List> getAreaNamesFromApi() async {
    if (stateLocation != null) {
      String url = baseApiUrl +
          '/location_api/places?location=${stateLocation.toLowerCase()}';
      var response = await http.get(url);
      List data = json.decode(response.body);
      return data;
    } else {
      return [];
    }
  }

  Future<void> refreshPage() async {
    setState(() {
      loading = true;
    });
    await Future.delayed(Duration(milliseconds: 1));
    setState(() {
      loading = false;
    });
  }

  @override
  void dispose() {
    _stateLocationController.close();
    _mainAreaController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 24, horizontal: 8),
        child: loading
            ? Center(child: CircularProgressIndicator())
            : ListView(
                children: [
                  Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Add New Fast Food',
                            style: Styles.subTitle1TextStyle),
                        Container(
                          decoration: Styles.boxDec,
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
                        ),
                        Container(
                          decoration: Styles.boxDec,
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
                              border: InputBorder.none,
                              hintText: 'Address',
                            ),
                            onSaved: (value) => address = value.trim(),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          margin: EdgeInsets.symmetric(vertical: 8),
                        ),
                        Container(
                          decoration: Styles.boxDec,
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
                              border: InputBorder.none,
                              hintText: 'Open Time (e.g, 8:00am - 10:00pm )',
                            ),
                            onSaved: (value) => openTime = value.trim(),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          margin: EdgeInsets.symmetric(vertical: 8),
                        ),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ShortButton(
                                onPressed: () {
                                  selectStatePopUp();
                                  print('State: $stateLocation');
                                },
                                label: 'Select State',
                              ),
                              Container(
                                height: 45,
                                padding: EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border:
                                      Border.all(color: Styles.themePrimary),
                                ),
                                child: Center(
                                  child: StreamBuilder(
                                    stream: _stateLocationController.stream,
                                    builder: (context, snapshot) {
                                      if (!snapshot.hasData) {
                                        return Text('No State Selected');
                                      } else {
                                        stateLocation = snapshot.data;
                                        return Text('${snapshot.data}');
                                      }
                                    },
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        mainAreaNameWidget(),
                        SizedBox(height: 20),
                        areaNameWidget(),
                        Divider(),
                        showHasBatchWidget(),
                        Divider(),
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Store Image",
                                style: Styles.titleTextStyle,
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              FlatButton(
                                onPressed: () {
                                  selectImage();
                                },
                                child: Container(
                                  decoration: Styles.boxDec,
                                  child: (fastFoodImages == null)
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
                                            fastFoodImages,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                ),
                              ),
                              SizedBox(height: 8)
                            ],
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Add Item',
                          style: Styles.body1TextStyle,
                        ),
                        Divider(thickness: 2, color: Styles.themePrimary),
                        Container(
                          decoration: Styles.boxDec,
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
                        ),
                        Row(
                          children: [
                            Container(
                              decoration: Styles.boxDec,
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              margin: EdgeInsets.symmetric(vertical: 8),
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
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                margin: EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 8),
                                decoration: Styles.boxDec,
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
                                  onSaved: (value) => _itemPrice = value.trim(),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          margin: EdgeInsets.symmetric(vertical: 8),
                          decoration: Styles.boxDec,
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
                              Text(
                                "Item Image",
                                style: Styles.titleTextStyle,
                              ),
                              InkWell(
                                onTap: () {
                                  selectItemImage();
                                },
                                child: Container(
                                  margin: EdgeInsets.symmetric(vertical: 8),
                                  decoration: Styles.boxDec,
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
                        ),

                        //
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
                  ),
                ],
              ),
      ),
    );
  }

  Widget mainAreaNameWidget() {
    return Center(
      child: StreamBuilder(
          stream: _stateLocationController.stream,
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.orange[700],
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Center(
                  child: Row(
                    children: [
                      SizedBox(width: 20),
                      Icon(Icons.keyboard_arrow_down, color: Colors.white),
                      SizedBox(width: 20),
                      Text(
                        'Select State Location First To Select Main Area',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ShortButton(
                      onPressed: () {
                        selectMainAreaPopUp();
                        print('State: $stateLocation');
                      },
                      label: 'Select Main Area',
                    ),
                    Container(
                      height: 45,
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Styles.themePrimary),
                      ),
                      child: Center(
                        child: StreamBuilder(
                          stream: _mainAreaController.stream,
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Text('No State Selected');
                            } else {
                              mainArea = snapshot.data;
                              return Text('${snapshot.data}');
                            }
                          },
                        ),
                      ),
                    )
                  ],
                ),
              );
            }
          }),
    );
  }

  Widget areaNameWidget() {
    return Center(
      child: StreamBuilder(
          stream: _stateLocationController.stream,
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.orange[700],
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Center(
                  child: Row(
                    children: [
                      SizedBox(width: 20),
                      Icon(Icons.keyboard_arrow_down, color: Colors.white),
                      SizedBox(width: 20),
                      Text(
                        'Select State Location First To Select Area',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return ExpansionTile(
                key: GlobalKey(),
                title: Text('$foodFastLocation'),
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
                          List areaNameList = snapshot.data;
                          return ListView.builder(
                            physics: BouncingScrollPhysics(),
                            itemCount: areaNameList.length,
                            itemBuilder: (context, index) {
                              String currentAreaName = areaNameList[index];
                              return InkWell(
                                onTap: () {
                                  if (mounted) {
                                    setState(() {
                                      foodFastLocation = currentAreaName;
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
                                          fontWeight: FontWeight.w400,
                                        ),
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
              );
            }
          }),
    );
  }

  Widget showHasBatchWidget() {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Checkbox(
            value: hasBatchTimeList,
            activeColor: Colors.green,
            onChanged: (bool newValue) {
              setState(() {
                hasBatchTimeList = newValue;
              });
              print(hasBatchTimeList);
            },
          ),
          Text(
            'Has Batch Delivery',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}
// '7FA1D908DE22E1CFOA2486578B23AA52695C71'
