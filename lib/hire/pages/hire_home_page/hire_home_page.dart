import 'package:flutter/material.dart';

import '../../../widgets/styles.dart' as style;
import 'add_hire_worker_page.dart';
import 'add_laundry_worker.dart';
import 'all_laundry_orders.dart';
import 'shop_owner_orders.dart';

class HireHomePage extends StatefulWidget {
  @override
  _HireHomePageState createState() => _HireHomePageState();
}

class _HireHomePageState extends State<HireHomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 4,
        child: Scaffold(
          backgroundColor: style.themeGrey,
          appBar: AppBar(
            elevation: 0,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
                size: 20,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            backgroundColor: style.background,
            title: Text(
              'Hire Agent Console',
              style: TextStyle(color: Colors.black),
            ),
            centerTitle: true,
            bottom: TabBar(
              indicatorColor: style.themePrimary,
              indicatorWeight: 4,
              labelStyle: style.captionTextStyle,
              unselectedLabelStyle: style.captionTextStyle,
              labelColor: style.themePrimary,
              unselectedLabelColor: style.textBlack,
              tabs: [
                Tab(
                    child: Text(
                      "Add Worker Profile",
                      textAlign: TextAlign.center,
                    ),
                    icon: Icon(
                      Icons.add,
                      color: style.themePrimary,
                      size: 20,
                    )),
                Tab(
                    child: Text(
                      "Orders",
                      textAlign: TextAlign.center,
                    ),
                    icon: Icon(
                      Icons.play_for_work,
                      color: style.themePrimary,
                      size: 20,
                    )),
                Tab(
                    child: Text(
                      "Laundry Orders",
                      textAlign: TextAlign.center,
                    ),
                    icon: Icon(
                      Icons.local_laundry_service,
                      color: style.themePrimary,
                      size: 20,
                    )),
                Tab(
                    child: Text(
                      "Add Laundry Services",
                      textAlign: TextAlign.center,
                    ),
                    icon: Icon(
                      Icons.edit,
                      color: style.themePrimary,
                      size: 20,
                    )),
              ],
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TabBarView(
              children: [
                AddHireWorkerPage(),
                LaundryShopOwnerOrders(),
                AllLaundryOrder(),
                AddNewClothesPage(),
              ],
            ),
          ),
        )

//          Container(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Center(
//               child: FlatButton(
//                 color: Colors.green,
//                 onPressed: () {
//                   Navigator.of(context).push(
//                     MaterialPageRoute(
//                       builder: (context) => AddHireWorkerPage(),
//                     ),
//                   );
//                 },
//                 child: Text(
//                   'Add Hire Worker',
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ),
//             Center(
//               child: FlatButton(
//                 color: Colors.green,
//                 onPressed: () {
//                   Navigator.of(context).push(
//                     MaterialPageRoute(
//                       builder: (context) => AddNewClothesPage(),
//                     ),
//                   );
//                 },
//                 child: Text(
//                   'Add Laundry Clothes',
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ),
//             Center(
//               child: FlatButton(
//                 color: Colors.green,
//                 onPressed: () {
//                   Navigator.of(context).push(
//                     MaterialPageRoute(
//                       builder: (context) => AllLaundryOrder(),
//                     ),
//                   );
//                 },
//                 child: Text(
//                   'All Laundry Orders',
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ),
//             Center(
//               child: FlatButton(
//                 color: Colors.green,
//                 onPressed: () async {
// //                  Map data = await HiveMethods().getUserData();
// //                  print(data);
// //                },
//                   Navigator.of(context).push(
//                     MaterialPageRoute(
//                       builder: (context) => LaundryShopOwnerOrders(),
//                     ),
//                   );
//                 },
//                 child: Text(
//                   'All Shop Owner Orders',
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(height: 10),
//           ],
//         ),
//       ),
        );
  }
}
