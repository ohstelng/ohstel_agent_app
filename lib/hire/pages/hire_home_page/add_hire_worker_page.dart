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
import 'package:ohostel_hostel_agent_app/widgets/styles.dart' as style;
import 'package:uuid/uuid.dart';

import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_smallButton.dart';
import '../../../widgets/custom_textfield.dart';
import '../../../widgets/styles.dart';

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
    // setState(() {
    //   imagesFile = null;
    // });

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
    return Form(
      key: formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //Worker Name
            CustomTextField(
              labelText: 'Worker Name',
              onSaved: (val) => workerName = val,
              validator: (value) {
                if (value.trim().isEmpty) {
                  return 'workerName Can\'t Be Empty';
                } else if (value.trim().length < 3) {
                  return 'workerName Must Be More Than 2 Characters';
                } else {
                  return null;
                }
              },
            ),

            //Username field
            CustomTextField(
              labelText: 'Username',
              onSaved: (val) => userName = val,
              validator: (value) {
                if (value.trim().isEmpty) {
                  return 'userName Can\'t Be Empty';
                } else if (value.trim().length < 3) {
                  return 'userName Must Be More Than 2 Characters';
                } else {
                  return null;
                }
              },
            ),

            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    labelText: 'Phone number',
                    onSaved: (val) => workerPhoneNumber = val,
                    validator: (value) {
                      if (value.trim().isEmpty) {
                        return 'workerPhoneNumber Can\'t Be Empty';
                      } else if (value.trim().length < 3) {
                        return 'workerPhoneNumber Must Be More Than 2 Characters';
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                Expanded(
                  child: CustomTextField(
                    labelText: 'Email',
                    onSaved: (val) => workerEmail = val,
                    validator: (value) {
                      if (value.trim().isEmpty) {
                        return 'workerEmail Can\'t Be Empty';
                      } else if (value.trim().length < 3) {
                        return 'workerEmail Must Be More Than 2 Characters';
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
              ],
            ),

            //About Field
            Container(
              margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color(0xffEBF1EF),
              ),
              child: TextFormField(
                maxLines: 10,
                minLines: 1,
                maxLength: 250,
                validator: (value) {
                  if (value.trim().isEmpty) {
                    return 'about Can\'t Be Empty';
                  } else if (value.trim().length < 3) {
                    return 'about Must Be More Than 2 Characters';
                  } else {
                    return null;
                  }
                },
                onSaved: (val) => about = val,
                style: style.body1TextStyle,
                decoration: InputDecoration(
                  hintText: 'Description',
                  border: InputBorder.none,
                ),
              ),
            ),

            //Open Period Field
            CustomTextField(
              labelText: 'Open period',
              onSaved: (val) => openTime = val,
              validator: (value) {
                if (value.trim().isEmpty) {
                  return 'openTime Can\'t Be Empty';
                } else if (value.trim().length < 3) {
                  return 'openTime Must Be More Than 2 Characters';
                } else {
                  return null;
                }
              },
            ),

            //Price Range Field
            CustomTextField(
              labelText: 'Price Range',
              onSaved: (val) => priceRange = val,
              validator: (value) {
                if (value.trim().isEmpty) {
                  return 'priceRange Can\'t Be Empty';
                } else if (value.trim().length < 3) {
                  return 'priceRange Must Be More Than 2 Characters';
                } else {
                  return null;
                }
              },
            ),

            //Work Type Field
            Container(
              margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color(0xffEBF1EF),
              ),
              height: 55,
              alignment: Alignment.centerLeft,
              child: DropdownButton(
                isExpanded: true,
                hint: Text("Select Work Type"),
                value: workType,
                onChanged: (value) {
                  setState(() {
                    workType = value;
                  });
                },
                items: type.map((element) {
                  return DropdownMenuItem(
                    value: element,
                    child: Text(
                      element,
                      style: style.body1TextStyle,
                    ),
                  );
                }).toList(),
                underline: Container(),
                isDense: true,
                elevation: 4,
              ),
            ),

            //Select Location field
            selectLocationWidget(),

            //Adding Image
            Padding(
              padding: const EdgeInsets.only(top: 16.0, bottom: 8, left: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text('Add Image', style: style.headingTextStyle),
                  Spacer(),
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
                              color: style.midnightBlue,
                            ),
                          )
                        : Container(),
                  )
                ],
              ),
            ),
            buildGridView(),

            SizedBox(height: 8),
            isSending
                ? Center(child: CircularProgressIndicator(strokeWidth: 4))
                : LongButton(
                    onPressed: saveData,
                    label: 'Save',
                  ),
          ],
        ),
      ),
    );
  }

  Widget buildGridView() {
    /* return  Container(
        height: 150,
        width: 150,
        alignment: Alignment.center,
        child:
            /* GridView.count(
//        scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          crossAxisCount: 1,
          children: List.generate(1, (index) {
            File asset = imagesFile;
 */
            Image.file(imagesFile),
      );
    else */
    return Container(
      margin: EdgeInsets.all(8.0),
      height: 150,
      width: 150,
      decoration: BoxDecoration(
        border: Border.all(color: style.midnightBlue),
        borderRadius: BorderRadius.circular(16),
        color: style.midnightBlue.withOpacity(0.5),
      ),
      alignment: Alignment.center,
      child: (imagesFile != null)
          ? Image.file(imagesFile, fit: BoxFit.fill)
          : IconButton(
              iconSize: 64,
              onPressed: loadAssets,
              icon: Icon(
                Icons.add_photo_alternate,
                color: style.background,
                // size: 64,
              ),
            ),
    );
  }

  Widget selectLocationWidget() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ShortButton(
            color: midnightBlue,
            onPressed: () {
              _showEditUniDailog();
            },
            label: 'Select Location',
          ),
          Container(
            padding: EdgeInsets.all(8.0),
            height: 45,
            decoration: BoxDecoration(
              // border: Border.all(color: style.midnightBlue, width: 0.7),
              borderRadius: BorderRadius.circular(3),
            ),
            child: StreamBuilder(
              stream: _uniNameController.stream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Text(
                    'No Loacation Selected',
                    style:
                        style.body1TextStyle.copyWith(color: Colors.blueGrey),
                  );
                } else {
                  uniName = snapshot.data;
//                  productOriginLocation = snapshot.data;
                  return Text(
                    '${snapshot.data}',
                    style: style.body1TextStyle,
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
