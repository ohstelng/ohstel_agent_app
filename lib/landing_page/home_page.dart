import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ohostel_hostel_agent_app/auth/methods/auth_methods.dart';
import 'package:ohostel_hostel_agent_app/food/pages/food_home.dart';
import 'package:ohostel_hostel_agent_app/hire/pages/hire_home_page/hire_home_page.dart';
import 'package:ohostel_hostel_agent_app/hostel_booking/hoste_home_page.dart';
import 'package:ohostel_hostel_agent_app/market_place/pages/market_home_page.dart';
import 'package:ohostel_hostel_agent_app/widgets/custom_button.dart';
import 'package:ohostel_hostel_agent_app/widgets/styles.dart' as Styles;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        leading: Padding(
          padding: EdgeInsets.all(6),
          child: Image.asset("asset/ohstel.png"),
        ),
        elevation: 5,
        title: Text(
          'Management Console',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Spacer(
              flex: 1,
            ),
            RichText(
              text: TextSpan(
                  text: " Welcome, ",
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: " Ohstel Agent",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: (Styles.themePrimary)),
                    ),
                  ]),
            ),
            Spacer(
              flex: 1,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 8),
                  height: 135,
                  width: 162,
                  decoration: Styles.boxDec,
                  child: FlatButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => HostelHomePage(),
                        ),
                      );
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset("asset/chostel.svg"),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          'Hostel Agent ',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 8),
                  height: 135,
                  width: 162,
                  decoration: Styles.boxDec,
                  child: FlatButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => FoodHomePage(),
                        ),
                      );
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset("asset/cfood.svg"),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          'Food Agent',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Spacer(
              flex: 1,
            ),
            Center(
              child: FlatButton(
                color: Colors.green,
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => HireHomePage(),
                    ),
                  );
                },
                child: Text(
                  'Hire Agent App',
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
                      builder: (context) => MarketHomePage(),
                    ),
                  );
                },
                child: Text(
                  'Market Agent App',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Spacer(),
//            Center(
//              child: FlatButton(
//                color: Colors.green,
            LongButton(
                color: Styles.themePrimary,
                labelColor: Colors.white,
                label: "Log Out",
                onPressed: () async {
                  await AuthService().signOut();
                }),
            Spacer(
              flex: 3,
            )
          ],
        ),
      ),
    );
  }
}
