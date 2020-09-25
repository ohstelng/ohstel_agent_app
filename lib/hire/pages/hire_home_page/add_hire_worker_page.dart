import 'package:flutter/material.dart';

class AddHireWorkerPage extends StatefulWidget {
  @override
  _AddHireWorkerPageState createState() => _AddHireWorkerPageState();
}

class _AddHireWorkerPageState extends State<AddHireWorkerPage> {
  String workerName;
  String userName;
  String priceRange;
  String workType;
  String workerPhoneNumber;
  String workerEmail;
  String uniName;
  String about;
  String openTime;
  String profileImageUrl;
  List laundryList;

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }

  Widget _formFeild({
    @required String title,
  }) {
    return Container(
      child: TextFormField(
        validator: (value) {
          if (value.trim().isEmpty) {
            return '$title Can\'t Be Empty';
          } else if (value.trim().length < 3) {
            return '$title Must Be More Than 2 Characters';
          } else {
            return null;
          }
        },
        decoration: InputDecoration(
          labelText: '$title',
        ),
//        onSaved: (value) => address = value.trim(),
      ),
      padding: EdgeInsets.symmetric(horizontal: 15),
    );
  }
}
