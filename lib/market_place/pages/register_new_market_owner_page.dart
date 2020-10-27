import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:ohostel_hostel_agent_app/auth/methods/auth_methods.dart';
import 'package:ohostel_hostel_agent_app/widgets/custom_button.dart';
import 'package:ohostel_hostel_agent_app/widgets/custom_textfield.dart';
import 'package:ohostel_hostel_agent_app/widgets/styles.dart' as Styles;

class SignUpNewShopOwner extends StatefulWidget {
  @override
  _SignUpNewShopOwnerState createState() => _SignUpNewShopOwnerState();
}

class _SignUpNewShopOwnerState extends State<SignUpNewShopOwner> {
  bool loading = false;
  final formKey = GlobalKey<FormState>();
  AuthService authService = AuthService();

  String firstName;
  String email;
  String lastName;
  String _password;
  String _passwordAgain;
  String uniName = 'Select Uni';
  String shopName;
  String phoneNumber;
  String address;
  Timestamp timeCreated;

  String fullName;
  String password;

  Future<void> validateAndSave() async {
    final form = formKey.currentState;
    if (form.validate() && uniName.trim() != 'Select Uni') {
      form.save();
      setState(() {
        password = _passwordAgain;
        fullName = '$firstName $lastName';
        loading = true;
      });
      print('From is vaild');
      print(email);
      print(password);
//      print(shopName);
      print(phoneNumber);
//      print(schoolLocation);
      await signUpUser();

      if (!mounted) return;

      setState(() {
        loading = false;
      });
    } else {
      Fluttertoast.showToast(msg: 'Invaild Inputs');
    }
  }

  Future<void> signUpUser() async {
    try {
      await authService.registerWithEmailAndPassword(
        email: email,
        password: password,
        fullName: fullName,
        shopName: shopName,
        address: address,
        phoneNumber: phoneNumber,
        uniName: uniName,
      );
    } catch (e, s) {
      print(e);
      print(s);
      Fluttertoast.showToast(msg: 'Invaild $e');
    }
  }

  Future<Map> getAllUniNamesFromApi() async {
    String url = "https://quiz-demo-de79d.appspot.com/hostel_api/searchKeys";
    var response = await http.get(url);
    Map data = json.decode(response.body);

    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        bottom: PreferredSize(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 8),
            width: MediaQuery.of(context).size.width * 0.9,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Create your Account",
                    style:
                        TextStyle(fontWeight: FontWeight.w800, fontSize: 24)),
                Text(
                  "Let's get to know you better",
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.normal),
                )
              ],
            ),
          ),
          preferredSize: Size.fromHeight(30),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          // height: MediaQuery.of(context).size.height,
          color: Colors.white,
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                // Spacer(flex:1),
                CustomTextField(
                  onSaved: (value) => firstName = value.trim(),
                  labelText: "First Name",
                  validator: (value) {
                    if (value.trim().isEmpty) {
                      return 'First Name Can\'t Be Empty';
                    } else if (value.trim().length < 3) {
                      return 'First Name Must Be More Than 2 Characters';
                    } else {
                      return null;
                    }
                  },
                ),
                CustomTextField(
                  onSaved: (value) => lastName = value.trim(),
                  labelText: "Last Name",
                  validator: (value) {
                    if (value.trim().isEmpty) {
                      return 'Last Name Can\'t Be Empty';
                    } else if (value.trim().length < 3) {
                      return 'Last Name Must Be More Than 2 Characters';
                    } else {
                      return null;
                    }
                  },
                ),
                CustomTextField(
                  onSaved: (value) =>
                      shopName = value.trim().toString().toLowerCase(),
                  labelText: "Shop Name",
                  validator: (value) {
                    if (value.trim().isEmpty) {
                      return 'Shop Name Can\'t Be Empty';
                    } else if (value.trim().length <= 1) {
                      return 'Shop Name Must Be More Than 1 Characters';
                    } else {
                      return null;
                    }
                  },
                ),
                CustomTextField(
                  textInputType: TextInputType.phone,
                  onSaved: (value) => phoneNumber = value.trim(),
                  labelText: "Phone Number",
                  validator: (value) {
                    if (value.trim().isEmpty) {
                      return 'Field Can\'t Be Empty';
                    } else {
                      return null;
                    }
                  },
                ),
                CustomTextField(
                  textInputType: TextInputType.emailAddress,
                  onSaved: (value) => email = value.trim(),
                  labelText: "Email",
                  validator: (value) {
                    if (value.trim().isEmpty) {
                      return 'Email Can\'t Be Empty';
                    } else if (!value.trim().endsWith('.com')) {
                      return 'Invalid Email';
                    } else {
                      return null;
                    }
                  },
                ),
                Container(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 15, right: 15, bottom: 10),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.info_outline,
                          size: 18,
                          color: Colors.blue,
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Container(
                            child: Text(
                              'Be sure to submit a vaild/correct email address as this email will be use if there is a case of forgotten paswword.',
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xffEBF1EF),
                  ),
                  child: TextFormField(
                    validator: (value) {
                      if (value.trim().isEmpty) {
                        return 'address Can\'t Be Empty';
                      } else if (value.trim().length < 6) {
                        return 'address Must Be More Than 6 Characters';
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: 'Input your address',
                    ),
                    onSaved: (value) {
                      address = value.trim();
                    },
//                    keyboardType: TextInputType.visiblePassword,
                  ),
                ),
                CustomTextField(
                  validator: (value) {
                    if (value.trim().isEmpty) {
                      return 'Password Can\'t Be Empty';
                    } else if (value.trim().length < 6) {
                      return 'Password Must Be More Than 6 Characters';
                    } else {
                      return null;
                    }
                  },
                  labelText: 'Password',
                  obscureText: true,
                  onSaved: (value) {
                    _password = value.trim();
                  },
                  textInputType: TextInputType.visiblePassword,
                ),
                CustomTextField(
                  validator: (value) {
                    if (value.trim().isEmpty) {
                      return 'Password Can\'t Be Empty';
                    } else if (value.trim().length < 6) {
                      return 'Password Must Be More Than 6 Characters';
                    } else {
                      return null;
                    }
                  },
                  labelText: 'Password',
                  obscureText: true,
                  onSaved: (value) {
                    _passwordAgain = value.trim();
                  },
                  textInputType: TextInputType.visiblePassword,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  decoration: BoxDecoration(
                      border: Border.all(color: Styles.themePrimary)),
                  child: ExpansionTile(
                    key: GlobalKey(),
                    title: Text('$uniName'),
                    leading: Icon(Icons.location_on),
                    children: <Widget>[
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .30,
                        child: FutureBuilder(
                          future: getAllUniNamesFromApi(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            } else {
                              Map uniNameMaps = snapshot.data;
                              List uniList = uniNameMaps.keys.toList();
                              return ListView.builder(
                                physics: BouncingScrollPhysics(),
                                itemCount: uniNameMaps.length,
                                itemBuilder: (context, index) {
                                  Map currentUniName =
                                      uniNameMaps[uniList[index]];
                                  return InkWell(
                                    onTap: () {
                                      if (mounted) {
                                        setState(() {
                                          uniName = currentUniName['abbr']
                                              .toString()
                                              .toLowerCase();
                                          print(uniName);
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
                                          Expanded(
                                            child: Text(
                                              '${currentUniName['name']}',
                                              style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.w400,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
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
                  ),
                ),
                Text("By clicking on 'Create Account', you agree to"),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('our '),
                    Text(
                      'Terms and Conditions',
                      style: Styles.underline,
                    ),
                    Text(' and '),
                    Text(
                      'Privacy policy',
                      style: Styles.underline,
                    )
                  ],
                ),
                signUpButton(),
                // Spacer(flex:1)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget signUpButton() {
    return loading == false
        ? LongButton(
            onPressed: () => validateAndSave(),
            label: "Create Account",
            color: Styles.themePrimary,
            labelColor: Colors.white,
          )
        : Container(
            height: 70,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
  }
}
