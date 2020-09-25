import 'package:flutter/material.dart';

class HireHomePage extends StatefulWidget {
  @override
  _HireHomePageState createState() => _HireHomePageState();
}

class _HireHomePageState extends State<HireHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hire Agent App'),
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: FlatButton(
                color: Colors.green,
                onPressed: () {
//                  Navigator.of(context).push(
//                    MaterialPageRoute(
//                      builder: (context) => GetLocationPage(),
//                    ),
//                  );
                },
                child: Text(
                  'Add Hire Worker',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
