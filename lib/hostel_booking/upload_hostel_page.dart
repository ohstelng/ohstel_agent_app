import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:ohostel_hostel_agent_app/hostel_booking/methods.dart';
import 'package:ohostel_hostel_agent_app/hostel_booking/model/hostel_model.dart';
import 'package:ohostel_hostel_agent_app/widgets/custom_button.dart';
import 'package:uuid/uuid.dart';
import 'package:ohostel_hostel_agent_app/widgets/styles.dart' as Styles;

class UploadHostelPage extends StatefulWidget {
  @override
  _UploadHostelPageState createState() => _UploadHostelPageState();
}

class _UploadHostelPageState extends State<UploadHostelPage> {
  final formKey = GlobalKey<FormState>();
  StreamController _uniNameController = StreamController.broadcast();
  TextEditingController distanceTextEditingController = TextEditingController();
  TextEditingController distanceTimeTextEditingController =
      TextEditingController();
  Location location = new Location();
  bool _serviceEnabled;
  bool isLoading = false;
  PermissionStatus _permissionGranted;
  LocationData _locationData;
  String apiKey = 'AIzaSyBHxUKxPLl8cAgGGq-Be9fjsV1ruV3W9iE';
  Map<String, double> destination = {'lat': 8.480339, 'long': 4.637326};

//  List<Asset> images = List<Asset>();
  List<File> imagesFiles = List<File>();
  String hostelName;
  String hostelLocation;
  String hostelAreaName;
  int price;
  int bedSpace;
  String distanceFromSchoolInKm;
  String distanceTime;
  bool isSchoolHostel = false;
  String description;
  String extraFeatures;
  String landMark;
  String dormType = 'Select Dorm Type';
  String uniName;
  String hostelAccommodationType = 'Accommodation Type';
  String type;
  bool isSending = false;

  Future getUniList() async {
    String url = "https://quiz-demo-de79d.appspot.com/hostel_api/searchKeys";
    var response = await http.get(url);
    var result = json.decode(response.body);
    print(result);
    return result;
  }

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

  Future<void> getUserLatAndLong() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    try {
      _locationData = await location.getLocation();
      print(_locationData);

      getRouteCoordinates(
        originLat: _locationData.latitude,
        originLong: _locationData.longitude,
      );
    } catch (e) {
      print(e);
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> getRouteCoordinates({
    @required double originLat,
    @required double originLong,
  }) async {
    String url = "https://maps.googleapis.com/maps/api/directions/json?origin"
        "=$originLat,$originLong&destination=${destination['lat']},"
        "${destination['long']}&key=$apiKey";

    http.Response response = await http.get(url);
    Map values = jsonDecode(response.body);

    print(values['routes'][0]['legs'][0]['distance']);
    print(values['routes'][0]['legs'][0]['duration']);
    if (mounted) {
      setState(() {
        distanceTextEditingController.text =
            values['routes'][0]['legs'][0]['distance']['text'];
        distanceTimeTextEditingController.text =
            values['routes'][0]['legs'][0]['duration']['text'];
        isLoading = false;
      });
    }
  }

  Future<void> loadAssets() async {
    setState(() {
      imagesFiles = List<File>();
    });

    try {
      List<File> files;

      FilePickerResult result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['jpg', 'png', 'jpg'],
      );

      if(result != null) {
         files = result.paths.map((path) => File(path)).toList();
      }

//      List<File> files = await FilePicker.getMultiFile();
      setState(() {
        imagesFiles = files;
      });
    } on Exception catch (e) {
      print(e);
      Fluttertoast.showToast(msg: '$e');
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }

  Future getUrls() async {
    List<dynamic> imageUrl = [];

//    print(images);
    for (var imageFile in imagesFiles) {
      String url = await postImage(imageFile);
      print(url);
      imageUrl.add(url.toString());
      print(imageUrl);
    }

    if (imageUrl.length == imagesFiles.length) {
      print('got here');

      HostelModel hostel = HostelModel(
        hostelName: hostelName,
        hostelLocation: hostelLocation,
        price: price,
        distanceFromSchoolInKm: distanceFromSchoolInKm,
        bedSpace: bedSpace,
        isSchoolHostel: isSchoolHostel,
        description: description,
        extraFeatures: extraFeatures,
        imageUrl: imageUrl,
        dormType: dormType,
        landMark: landMark,
        hostelAccommodationType: hostelAccommodationType,
        uniName: uniName,
        distanceTime: distanceTime,
      );
      print(hostel.toMap());
      await HostelBookingMethods().saveHostelToServer(hostelModel: hostel);
    }
  }

  Future<dynamic> postImage(File imageFile) async {
    try {
      StorageReference storageReference =
          FirebaseStorage.instance.ref().child('hostelImage/${Uuid().v1()}');

      StorageUploadTask uploadTask = storageReference.putFile(imageFile);

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
        dormType != 'Select Dorm Type' &&
        hostelAccommodationType != 'Accommodation Type' &&
        imagesFiles.isNotEmpty &&
        uniName != null) {
      formKey.currentState.save();
      print('pass');
      print('$hostelName');
      print('$hostelAccommodationType');

      setState(() {
        isSending = true;
      });
      print('one');
//      await Future.delayed(Duration(seconds: 10));
      await getUrls();
      print('two');
      setState(() {
        isSending = false;
      });
      Fluttertoast.showToast(msg: 'Upload Done!!');
    }
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
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 8,vertical: 16),
        color: Colors.white,
        child: ListView(
          children: <Widget>[
            Text('Upload Hostel',style: Styles.subTitle1TextStyle,),
            form(),
          ],
        ),
      )
    );
  }

  Widget form() {
    return Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            decoration:Styles.boxDec,
            child: TextFormField(
              validator: (value) {
                if (value.trim().isEmpty) {
                  return 'Hotel Name Can\'t Be Empty';
                } else if (value.trim().length < 3) {
                  return 'Hotel Name Must Be More Than 2 Characters';
                } else {
                  return null;
                }
              },
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Hotel Name',
              ),
              onSaved: (value) => hostelName = value.trim(),
            ),
            padding: EdgeInsets.symmetric(horizontal: 8,),
            margin: EdgeInsets.symmetric(vertical: 8),
          ),
          Container(
            decoration: Styles.boxDec,
            child: TextFormField(
              validator: (value) {
                if (value.trim().isEmpty) {
                  return 'Hotel Location Can\'t Be Empty';
                } else {
                  return null;
                }
              },
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Hotel Location',
              ),
              onSaved: (value) => hostelLocation = value.trim(),
            ),
            padding: EdgeInsets.symmetric(horizontal: 8,),
            margin: EdgeInsets.symmetric(vertical: 8),

          ),
          Container(
            decoration: Styles.boxDec,
            child: TextFormField(
              validator: (value) {
                if (value.trim().isEmpty) {
                  return 'Hotel Area Name Can\'t Be Empty';
                } else {
                  return null;
                }
              },
              decoration: InputDecoration(
                border: InputBorder.none,
                labelText: 'Hotel Area Name',
              ),
              onSaved: (value) => hostelAreaName = value.trim(),
            ),padding: EdgeInsets.symmetric(horizontal: 8,),
            margin: EdgeInsets.symmetric(vertical: 8),
          ),
          Container(
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Container(
                    decoration: Styles.boxDec,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value.trim().isEmpty) {
                          return 'Price Can\'t Be Empty';
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Price',
                      ),
                      onSaved: (value) => price = int.parse(value.trim()),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    margin: EdgeInsets.symmetric(vertical: 8),
                  ),
                ),
                SizedBox(width: 8,),
                Expanded(
                  flex: 1,
                  child: Container(
                    decoration: Styles.boxDec,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value.trim().isEmpty) {
                          return 'bed Space Can\'t Be Empty';
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Bed Space',
                      ),
                      onSaved: (value) => bedSpace = int.parse(value.trim()),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 8,),
                    margin: EdgeInsets.symmetric(vertical: 8),
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    decoration: Styles.boxDec,
                    child: TextFormField(
                      controller: distanceTextEditingController,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value.trim().isEmpty) {
                          return 'distance Can\'t Be Empty';
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Distance In KM',
                      ),
                      onSaved: (value) => distanceFromSchoolInKm = value.trim(),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 8,),
                    margin: EdgeInsets.symmetric(vertical: 8),
                  ),
                ),
                SizedBox(width: 8,),
                Expanded(
                  child: Container(
                    decoration: Styles.boxDec,
                    child: TextFormField(
                      controller: distanceTimeTextEditingController,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value.trim().isEmpty) {
                          return 'time distance Can\'t Be Empty';
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Distance time',
                      ),
                      onSaved: (value) => distanceTime = value.trim(),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 8,),
                    margin: EdgeInsets.symmetric(vertical: 8),
                  ),
                ),
               Container(
                 height: 45,
                 padding: EdgeInsets.symmetric(horizontal: 5),
                  child: FlatButton(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    color: Styles.themePrimary,
                    onPressed: () {
                      getUserLatAndLong();
                    },
                    child: isLoading
                        ? CircularProgressIndicator()
                        : Text('Get Distance',style: TextStyle(color: Colors.white),),
                  ),
                ),
              ],
            ),
          ),
          checkbox(title: 'On-Campus?', boolValue: isSchoolHostel),
          Container(
            decoration: Styles.boxDec,
            child: TextFormField(
              maxLines: null,
              keyboardType: TextInputType.multiline,
              validator: (value) {
                if (value.trim().isEmpty) {
                  return 'Hotel Description Can\'t Be Empty';
                } else {
                  return null;
                }
              },
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Hotel Description',
              ),
              onSaved: (value) => description = value.trim(),
            ),
            padding: EdgeInsets.symmetric(horizontal: 8),
            margin: EdgeInsets.symmetric(vertical: 8),
          ),
          Container(
            decoration: Styles.boxDec,
            child: TextFormField(
              validator: (value) {
                if (value.trim().isEmpty) {
                  return 'Hotel Features Can\'t Be Empty';
                } else {
                  return null;
                }
              },
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Hotel Features',
              ),
              onSaved: (value) => extraFeatures = value.trim(),
            ),
              padding: EdgeInsets.symmetric(horizontal: 8),
              margin: EdgeInsets.symmetric(vertical: 8)
          ),
          Container(
            decoration: Styles.boxDec,
            child: TextFormField(
              validator: (value) {
                if (value.trim().isEmpty) {
                  return 'Hotel Features Can\'t Be Empty';
                } else {
                  return null;
                }
              },
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Any Land Mark Close By?',
              ),
              onSaved: (value) => landMark = value.trim(),
            ),
              padding: EdgeInsets.symmetric(horizontal: 8),
              margin: EdgeInsets.symmetric(vertical: 8)),
          Container(
            margin: EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  height: 45,
                  child: FlatButton(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    color: Styles.themePrimary,
                    onPressed: () {
                      _showEditUniDailog();
                    },
                    child: Text('Select Institution',style: TextStyle(color: Colors.white),),
                  ),
                ),
                Container(
                  height: 45,
                  padding: EdgeInsets.symmetric(horizontal:8.0,vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Styles.themePrimary),
                  ),
                  child: Center(
                    child: StreamBuilder(
                      stream: _uniNameController.stream,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Text('No Institution Selected');
                        } else {
                          uniName = snapshot.data;
                          return Text('${snapshot.data}');
                        }
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            child: Row(
              children: <Widget>[
                Expanded(child: dormTypeDropDown()),
                Expanded(child: accommodationTypeDropDown()),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                'Add Image',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                child: (imagesFiles != null && imagesFiles.isNotEmpty)
                    ? IconButton(
                        onPressed: () {
                          setState(() {
                            imagesFiles = List<File>();
                          });
                        },
                        icon: Icon(
                          Icons.refresh,
                          color: Colors.black,
                        ),
                      )
                    : Container(),
              )
            ],
          ),
          buildGridView(),
          isSending
              ? Center(child: CircularProgressIndicator())
              : LongButton(
                  color: Styles.themePrimary,
                  onPressed: () {
                    saveData();
                  },
                  label: 'Save',
                  labelColor: Colors.white,
                ),
        ],
      ),
    );
  }

  Widget checkbox({String title, bool boolValue}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text(title),
        Checkbox(
          value: boolValue,
          onChanged: (bool value) {
            print(value);
            setState(() {
              switch (title) {
                case "Need RoomMate?":
//                  isRoomMateNeeded = value;
                  break;
                case "InSide Campus?":
                  isSchoolHostel = value;
                  break;
              }
            });
          },
        )
      ],
    );
  }

  Widget dormTypeDropDown() {
    return Container(

      padding: EdgeInsets.all(20.0),
      child: DropdownButton(
          hint: Text('$dormType'),
          items: [
            DropdownMenuItem(
              child: Text("Boys Only"),
              value: 'Boys Only',
            ),
            DropdownMenuItem(
              child: Text("Girls Only"),
              value: 'Girls Only',
            ),
            DropdownMenuItem(
              child: Text("Mixed"),
              value: 'Mixed',
            ),
          ],
          onChanged: (value) {
            setState(() {
              dormType = value;
            });
          }),
    );
  }

  Widget accommodationTypeDropDown() {
    return Container(
      padding: EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        child: DropdownButton(
            hint: Text('Accommodation'),
            items: [
              DropdownMenuItem(
                child: Text("Self Contain"),
                value: 'Self Contain',
              ),
              DropdownMenuItem(
                child: Text("Single Room"),
                value: 'Single Room',
              ),
              DropdownMenuItem(
                child: Text("2 Bedroom Flat"),
                value: '2 Bedroom Flat',
              ),
              DropdownMenuItem(
                child: Text("1 Bedroom Flat"),
                value: '1 Bedroom Flat',
              ),
              DropdownMenuItem(
                child: Text("2 In A Room"),
                value: '2 In A Room',
              ),
              DropdownMenuItem(
                child: Text("3 In A Room"),
                value: '3 In A Room',
              ),
              DropdownMenuItem(
                child: Text("4 In A Room"),
                value: '4 In A Room',
              ),
            ],
            onChanged: (value) {
              setState(() {
                hostelAccommodationType = value;
                type = value;
              });
            }),
      ),
    );
  }

  Widget buildGridView() {
    if (imagesFiles != null && imagesFiles.isNotEmpty)
      return GridView.count(
//        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        crossAxisCount: imagesFiles.length,
        children: List.generate(imagesFiles.length, (index) {
          File asset = imagesFiles[index];

          return Container(
            margin: EdgeInsets.all(5.0),
            child: Image.file(
              asset,
            ),
          );
        }),
      );
    else
      return Container(
        margin: EdgeInsets.all(20.0),
        height: 150,
        width: 150,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(25),
          color: Colors.grey,
        ),
        child: IconButton(
          onPressed: () {
            loadAssets();
          },
          icon: Icon(
            Icons.add_photo_alternate,
            color: Colors.white,
            size: 50,
          ),
        ),
      );
  }
}
