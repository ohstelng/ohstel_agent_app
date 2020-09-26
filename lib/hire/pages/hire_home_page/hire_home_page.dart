import 'package:flutter/material.dart';
import 'package:ohostel_hostel_agent_app/hire/pages/hire_home_page/add_hire_worker_page.dart';
import 'package:ohostel_hostel_agent_app/hire/pages/hire_home_page/add_laundry_worker.dart';
import 'package:ohostel_hostel_agent_app/hire/pages/hire_home_page/all_laundry_orders.dart';
import 'package:ohostel_hostel_agent_app/hire/pages/hire_home_page/shop_owner_orders.dart';
import 'package:ohostel_hostel_agent_app/hive_methods/hive_class.dart';

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
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => AddHireWorkerPage(),
                    ),
                  );
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
            Center(
              child: FlatButton(
                color: Colors.green,
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => AddNewClothesPage(),
                    ),
                  );
                },
                child: Text(
                  'Add Laundry Clothes',
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
                      builder: (context) => AllLaundryOrder(),
                    ),
                  );
                },
                child: Text(
                  'All Laundry Orders',
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
                onPressed: () async {
//                  Map data = await HiveMethods().getUserData();
//                  print(data);
//                },
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => LaundryShopOwnerOrders(),
                    ),
                  );
                },
                child: Text(
                  'All Shop Owner Orders',
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
