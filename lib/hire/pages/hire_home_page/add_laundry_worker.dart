import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ohostel_hostel_agent_app/hire/hire_methods.dart';
import 'package:uuid/uuid.dart';

class AddNewClothesPage extends StatefulWidget {
  @override
  _AddNewClothesPageState createState() => _AddNewClothesPageState();
}

class _AddNewClothesPageState extends State<AddNewClothesPage> {
  StreamController _uniNameController = StreamController.broadcast();
  final formKey = GlobalKey<FormState>();
  String clothTypes;
  String userName;
  String profileImageUrl;
  List laundryList;
  List type = ['Laundry', 'Painter', 'Electrician', 'Carpenter'];
  File imagesFile;
  bool isSending = false;
  bool loading = true;
  int dryCleanPrice;
  int washOnlyPrice;
  int washAndIronPrice;
  int ironOnlyPrice;

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

      Map data = {
        'clothTypes': clothTypes,
        'imageUrl': profileImageUrl,
        'laundryModeAndPrice': {
          'Dry Clean': dryCleanPrice,
          'Wash Only': washOnlyPrice,
          'Wash And Iron': washAndIronPrice,
          'Iron Only': ironOnlyPrice,
        }
      };

      print(data);
      await HireMethods().saveLaundryClothesTypesAndPrice(data: data);
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
    if (formKey.currentState.validate() && imagesFile != null) {
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
      Fluttertoast.showToast(msg: 'Upload Done!!');
    }
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
                SizedBox(height: 20),
                laundryModeAndPriceWidget(),
                SizedBox(height: 20),
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

  Widget laundryModeAndPriceWidget() {
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(child: Text('Dry Clean')),
              Expanded(
                child: TextFormField(
                  validator: (value) {
                    if (value.trim().isEmpty) {
                      return 'Dry Clean Price Can\'t Be Empty';
                    } else {
                      return null;
                    }
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Dry Clean Price',
                  ),
                  onSaved: (val) => dryCleanPrice = int.parse(val),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(child: Text('Wash And Iron')),
              Expanded(
                child: TextFormField(
                  validator: (value) {
                    if (value.trim().isEmpty) {
                      return 'Wash And Iron Price Can\'t Be Empty';
                    } else {
                      return null;
                    }
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Wash And Iron Price',
                  ),
                  onSaved: (val) => washAndIronPrice = int.parse(val),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(child: Text('Wash Only')),
              Expanded(
                child: TextFormField(
                  validator: (value) {
                    if (value.trim().isEmpty) {
                      return 'Wash Only Price Can\'t Be Empty';
                    } else {
                      return null;
                    }
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Wash Only Price',
                  ),
                  onSaved: (val) => washOnlyPrice = int.parse(val),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(child: Text('Iron Only')),
              Expanded(
                child: TextFormField(
                  validator: (value) {
                    if (value.trim().isEmpty) {
                      return 'Iron Only Price Can\'t Be Empty';
                    } else {
                      return null;
                    }
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Iron Only Price',
                  ),
                  onSaved: (val) => ironOnlyPrice = int.parse(val),
                ),
              ),
            ],
          ),
        ],
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
            return 'Clothes Type Can\'t Be Empty';
          } else if (value.trim().length < 3) {
            return 'Clothes Type Must Be More Than 2 Characters';
          } else {
            return null;
          }
        },
//        keyboardType: keyBordType,
        decoration: InputDecoration(
          labelText: 'Clothes Type',
        ),
        onSaved: (val) => clothTypes = val,
      ),
      padding: EdgeInsets.symmetric(horizontal: 15),
    );
  }
}
