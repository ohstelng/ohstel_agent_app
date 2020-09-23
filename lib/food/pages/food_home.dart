import 'package:flutter/material.dart';
import 'package:ohostel_hostel_agent_app/food/pages/add_new_drinks_page.dart';
import 'package:ohostel_hostel_agent_app/food/pages/add_new_extra_items_page.dart';
import 'package:ohostel_hostel_agent_app/food/pages/add_new_fast_food_page.dart';
import 'package:ohostel_hostel_agent_app/food/pages/add_new_food_item_page.dart';
import 'package:ohostel_hostel_agent_app/food/pages/food_list.dart';

class FoodHomePage extends StatefulWidget {
  @override
  _FoodHomePageState createState() => _FoodHomePageState();
}

class _FoodHomePageState extends State<FoodHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Food Home Page')),
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
                    builder: (context) => AddNewFastFood(),
                  ),
                );
              },
              child: Text(
                'Add New Fast Food',
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
                    builder: (context) => AddNewFoodItemPage(),
                  ),
                );
              },
              child: Text(
                'Add New Food Item',
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
                    builder: (context) => AddExtraItemPage(),
                  ),
                );
              },
              child: Text(
                'Add New Extra Item',
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
                    builder: (context) => AddNewDrinksPage(),
                  ),
                );
              },
              child: Text(
                'Add New Drinks Item',
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
                    builder: (context) => FastFoodListPage(),
                  ),
                );
              },
              child: Text(
                'Edit Food',
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
