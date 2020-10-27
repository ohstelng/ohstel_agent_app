import 'package:flutter/material.dart';
import 'package:ohostel_hostel_agent_app/market_place/pages/add_new_product_page.dart';
import 'package:ohostel_hostel_agent_app/market_place/pages/add_partner_page.dart';
import 'package:ohostel_hostel_agent_app/market_place/pages/all_market_orders_page.dart';
import 'package:ohostel_hostel_agent_app/market_place/pages/register_new_market_owner_page.dart';
import 'package:ohostel_hostel_agent_app/market_place/pages/shop_owner_orders_page.dart';
import 'package:ohostel_hostel_agent_app/market_place/pages/shop_owner_product_page.dart';

class MarketHomePage extends StatefulWidget {
  @override
  _MarketHomePageState createState() => _MarketHomePageState();
}

class _MarketHomePageState extends State<MarketHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Market Home Page')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: FlatButton(
              color: Colors.green,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SignUpNewShopOwner(),
                  ),
                );
              },
              child: Text(
                'Add New Shop',
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
                    builder: (context) => AddPartnerPage(),
                  ),
                );
              },
              child: Text(
                'Add Partner Page',
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
                    builder: (context) => AddNewMarketProductPage(),
                  ),
                );
              },
              child: Text(
                'Add New Product',
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
//                setIt();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AllMarketOrderPage(),
                  ),
                );
              },
              child: Text(
                'View All Orders',
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
                    builder: (context) => ShopOwnerOrders(),
                  ),
                );
              },
              child: Text(
                'View Shop Owners Orders',
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
                    builder: (context) => ShopOwnerProductPage(),
                  ),
                );
              },
              child: Text(
                'View Shop Owners Product',
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
    );
  }
}
