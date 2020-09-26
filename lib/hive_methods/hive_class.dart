import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:ohostel_hostel_agent_app/hire/hire_methods.dart';
import 'package:path_provider/path_provider.dart';

class InitHive {
  void startHive({@required String boxName}) async {
    Directory documentDir = await getApplicationSupportDirectory();
    Hive.init(documentDir.path);
    await Hive.openBox<Map>(boxName);
  }
}

class HiveMethods {
  Future<Box<Map>> getOpenBox(String boxName) async {
    if (!Hive.isBoxOpen(boxName)) {
      return await Hive.openBox(boxName);
    }
    return Hive.box(boxName);
  }

  Future<String> getUniName() async {
    Box<Map> userDataBox = await getOpenBox('agentData');

    String uniName = userDataBox.get(0)['uniName'];
    return uniName;
  }

  Future<Map> getUserData() async {
    Box<Map> userDataBox = await getOpenBox('agentData');

    Map userData = userDataBox.getAt(0);
    return userData;
  }

  Future saveLaundryUserData({@required Map data}) async {
    Box<Map> userDataBox = await getOpenBox('agentData');

    await userDataBox.put(1, data);
//    Map userData = userDataBox.getAt(0);
//    return userData;
  }

  Future<Map> getLaundryUserData() async {
    Box<Map> userDataBox = await getOpenBox('agentData');

    if (!userDataBox.containsKey(1)) {
      await HireMethods().getLaundryUserData();
      print('fetch data');
      await Future.delayed(Duration(milliseconds: 500));
      print(userDataBox.toMap());
    }

    Map userData = userDataBox.getAt(1);

    return userData;
  }
}
