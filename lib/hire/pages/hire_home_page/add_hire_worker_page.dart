import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:ohostel_hostel_agent_app/hire/hire_methods.dart';
import 'package:ohostel_hostel_agent_app/hire/model/hire_agent_model.dart';
import 'package:ohostel_hostel_agent_app/hive_methods/hive_class.dart';
import 'package:uuid/uuid.dart';

class AddHireWorkerPage extends StatefulWidget {
  @override
  _AddHireWorkerPageState createState() => _AddHireWorkerPageState();
}

class _AddHireWorkerPageState extends State<AddHireWorkerPage> {
  StreamController _uniNameController = StreamController.broadcast();
  final formKey = GlobalKey<FormState>();
  Map userData;
  String workerName;
  String userName;
  String workerPhoneNumber;
  String workerEmail;
  String about;
  String openTime;
  String priceRange;
  String workType;
  String uniName;
  String profileImageUrl;
//  List laundryList;
  List type = ['Laundry', 'Painter', 'Electrician', 'Carpenter'];
  File imagesFile;
  bool isSending = false;
  bool loading = true;

  Future<void> getUserData() async {
    userData = await HiveMethods().getUserData();
    print(userData);
    setState(() {
      loading = false;
    });
  }

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

  Future<void> loadAssets() async {
    setState(() {
      imagesFile = null;
    });

    try {
      File files;

      FilePickerResult result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['jpg', 'png', 'jpg'],
      );

      if (result != null) {
//        files = result.paths.map((path) => File(path)).toList();
        files = File(result.paths.first);
      }

//      List<File> files = await FilePicker.getMultiFile();
      setState(() {
        imagesFile = files;
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
//    print(images);

    profileImageUrl = await postImage(imagesFile);
    print(profileImageUrl);
//      imageUrl.add(url.toString());
//      print(imageUrl);

    if (profileImageUrl != null) {
      print('got here');

      HireWorkerModel hireWorker = HireWorkerModel(
        workerName: workerName,
        userName: userName,
        workType: workType,
        priceRange: priceRange,
        workerPhoneNumber: workerPhoneNumber,
        workerEmail: workerEmail,
        uniName: uniName,
        profileImageUrl: profileImageUrl,
        about: about,
        openTime: openTime,
        workerUid: userData['uid'],
      );

      print(hireWorker.toMap());
      await HireMethods().saveHireWorker(worker: hireWorker);
    }
  }

  Future<dynamic> postImage(File imageFile) async {
    try {
      StorageReference storageReference =
          FirebaseStorage.instance.ref().child('hireImage/${Uuid().v1()}');

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
        workType != null &&
        imagesFile != null) {
      formKey.currentState.save();
      print('pass');
      setState(() {
        isSending = true;
      });
      print('one');
//      await Future.delayed(Duration(seconds: 10));
      await getUrls();
//      print('two');
      setState(() {
        isSending = false;
      });
//      Fluttertoast.showToast(msg: 'Upload Done!!');
    }
  }

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _workerNameFormField(),
                _userNameFormField(),
                Row(
                  children: [
                    Expanded(child: _workPhoneNumberFormField()),
                    Expanded(child: _workerEmailNumberFormField()),
                  ],
                ),
                _aboutFormField(),
                _openTimeFormField(),
                _priceRangeFormField(),
                _dropDown(),
                selectLocationWidget(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Add Image',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      child: imagesFile != null
                          ? IconButton(
                              onPressed: () {
                                setState(() {
                                  imagesFile = null;
                                  isSending = false;
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
                SizedBox(height: 30),
                isSending
                    ? Center(child: CircularProgressIndicator())
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
        ),
      ),
    );
  }

  Widget buildGridView() {
    if (imagesFile != null)
      return Container(
        height: 150,
        width: 150,
        child: GridView.count(
//        scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          crossAxisCount: 1,
          children: List.generate(1, (index) {
            File asset = imagesFile;

            return Container(
              constraints: BoxConstraints(
                maxHeight: 100,
              ),
              margin: EdgeInsets.all(5.0),
              child: Image.file(
                asset,
              ),
            );
          }),
        ),
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

  Widget _workerNameFormField() {
    return Container(
      child: TextFormField(
        validator: (value) {
          if (value.trim().isEmpty) {
            return 'workerName Can\'t Be Empty';
          } else if (value.trim().length < 3) {
            return 'workerName Must Be More Than 2 Characters';
          } else {
            return null;
          }
        },
//        keyboardType: keyBordType,
        decoration: InputDecoration(
          labelText: 'workerName',
        ),
        onSaved: (val) => workerName = val,
      ),
      padding: EdgeInsets.symmetric(horizontal: 15),
    );
  }

  Widget _userNameFormField() {
    return Container(
      child: TextFormField(
        validator: (value) {
          if (value.trim().isEmpty) {
            return 'userName Can\'t Be Empty';
          } else if (value.trim().length < 3) {
            return 'userName Must Be More Than 2 Characters';
          } else {
            return null;
          }
        },
//        keyboardType: keyBordType,
        decoration: InputDecoration(
          labelText: 'userName',
        ),
        onSaved: (val) => userName = val,
      ),
      padding: EdgeInsets.symmetric(horizontal: 15),
    );
  }

  Widget _workPhoneNumberFormField() {
    return Container(
      child: TextFormField(
        validator: (value) {
          if (value.trim().isEmpty) {
            return 'workerPhoneNumber Can\'t Be Empty';
          } else if (value.trim().length < 3) {
            return 'workerPhoneNumber Must Be More Than 2 Characters';
          } else {
            return null;
          }
        },
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: 'workPhoneNumber',
        ),
        onSaved: (val) => workerPhoneNumber = val,
      ),
      padding: EdgeInsets.symmetric(horizontal: 15),
    );
  }

  Widget _workerEmailNumberFormField() {
    return Container(
      child: TextFormField(
        validator: (value) {
          if (value.trim().isEmpty) {
            return 'workerEmail Can\'t Be Empty';
          } else if (value.trim().length < 3) {
            return 'workerEmail Must Be More Than 2 Characters';
          } else {
            return null;
          }
        },
//        keyboardType: keyBordType,
        decoration: InputDecoration(
          labelText: 'workerEmail',
        ),
        onSaved: (val) => workerEmail = val,
      ),
      padding: EdgeInsets.symmetric(horizontal: 15),
    );
  }

  Widget _aboutFormField() {
    return Container(
      child: TextFormField(
        validator: (value) {
          if (value.trim().isEmpty) {
            return 'about Can\'t Be Empty';
          } else if (value.trim().length < 3) {
            return 'about Must Be More Than 2 Characters';
          } else {
            return null;
          }
        },
//        keyboardType: keyBordType,
        decoration: InputDecoration(
          labelText: 'about/dec',
        ),
        onSaved: (val) => about = val,
      ),
      padding: EdgeInsets.symmetric(horizontal: 15),
    );
  }

  Widget _openTimeFormField() {
    return Container(
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
//        keyboardType: keyBordType,
        decoration: InputDecoration(
          labelText: 'openTime',
        ),
        onSaved: (val) => openTime = val,
      ),
      padding: EdgeInsets.symmetric(horizontal: 15),
    );
  }

  Widget _priceRangeFormField() {
    return Container(
      child: TextFormField(
        validator: (value) {
          if (value.trim().isEmpty) {
            return 'priceRange Can\'t Be Empty';
          } else if (value.trim().length < 3) {
            return 'priceRange Must Be More Than 2 Characters';
          } else {
            return null;
          }
        },
//        keyboardType: keyBordType,
        decoration: InputDecoration(
          labelText: 'priceRange',
        ),
        onSaved: (val) => priceRange = val,
      ),
      padding: EdgeInsets.symmetric(horizontal: 15),
    );
  }

  Widget _dropDown() {
    return DropdownButton(
      // select Category
      hint: Text("Select Work Type"),
      value: workType,
      onChanged: (value) {
        setState(() {
//          subCategory = categoryMap['$value'];
//          print(categoryMap['$value']);
          workType = value;
        });
      },
      items: type.map((element) {
        return DropdownMenuItem(
          value: element,
          child: Text(
            element,
            style: TextStyle(color: Colors.black),
          ),
        );
      }).toList(),
    );
  }

  Widget selectLocationWidget() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          FlatButton(
            color: Colors.green,
            onPressed: () {
              _showEditUniDailog();
            },
            child: Text('Select Location'),
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
                  return Text('No Loacation Selected');
                } else {
                  uniName = snapshot.data;
//                  productOriginLocation = snapshot.data;
                  return Text('${snapshot.data}');
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
