import 'package:flutter/material.dart';
import 'package:ohostel_hostel_agent_app/hostel_booking/hostel_get_loctaion_page.dart';
import 'package:ohostel_hostel_agent_app/hostel_booking/inspection_request_page.dart';
import 'package:ohostel_hostel_agent_app/hostel_booking/model/hostel_search_page.dart';
import 'package:ohostel_hostel_agent_app/hostel_booking/upload_hostel_page.dart';
import 'package:ohostel_hostel_agent_app/hostel_booking/view_paid_hostel_page.dart';

class HostelHomePage extends StatefulWidget {
  @override
  _HostelHomePageState createState() => _HostelHomePageState();
}

class _HostelHomePageState extends State<HostelHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OHstel Agent App'),
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
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => GetLocationPage(),
                    ),
                  );
                },
                child: Text(
                  'Get Current Location',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: FlatButton(
                color: Colors.green,
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => UploadHostelPage(),
                    ),
                  );
                },
                child: Text(
                  'Upload Hostel',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Center(
              child: FlatButton(
                color: Colors.green,
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ViewInspectionRequestPage(),
                    ),
                  );
                },
                child: Text(
                  'View Inspection Request',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Center(
              child: FlatButton(
                color: Colors.green,
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ViewPaidHostel(),
                    ),
                  );
                },
                child: Text(
                  'View Paid Hostel',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Center(
              child: FlatButton(
                color: Colors.green,
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => HostelSearchPage(),
                    ),
                  );
                },
                child: Text(
                  'Edit Hostel',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
