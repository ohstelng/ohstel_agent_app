import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ohostel_hostel_agent_app/market_place/market_methods.dart';
import 'package:ohostel_hostel_agent_app/widgets/custom_textfield.dart';

class AddPartnerPage extends StatefulWidget {
  @override
  _AddPartnerPageState createState() => _AddPartnerPageState();
}

class _AddPartnerPageState extends State<AddPartnerPage> {
  final formKey = GlobalKey<FormState>();
  bool loading = false;
  String shopName = '';

  void setLoading(){
    setState(() {
      loading = true;
    });
  }

  void unsetLoading(){
    setState(() {
      loading = false;
    });
  }

  void resetForm(){
    formKey.currentState.reset();
  }

  void validateForm() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      print(shopName);
    } else {
      Fluttertoast.showToast(msg: 'Please Input Shop Name');
    }
  }

  Future<void> makePartneredShop() async {
    validateForm();
    setLoading();
    await MarketMethods().makePartneredShop(shopName: shopName);
    unsetLoading();
    resetForm();
  }

  Future<void> undoPartneredShop() async {
    validateForm();
    setLoading();
    await MarketMethods().undoPartneredShop(shopName: shopName);
    unsetLoading();
    resetForm();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.all(10.0),
              child: Text(
                'Enter Shop Name.',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            CustomTextField(
              onSaved: (value) =>
                  shopName = value.trim().toString().toLowerCase(),
              labelText: "Enter Shop Name",
              validator: (value) {
                if (value.trim().isEmpty) {
                  return 'Shop Name Can\'t Be Empty';
                } else {
                  return null;
                }
              },
            ),
            SizedBox(height: 50),
            loading
                ? Center(child: CircularProgressIndicator())
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: EdgeInsets.all(20.0),
                        padding: EdgeInsets.all(10.0),
                        child: FlatButton(
                          onPressed: () {
                            makePartneredShop();
                          },
                          child: Text(
                            'Make Partner Shop',
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Colors.green,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(20.0),
                        padding: EdgeInsets.all(10.0),
                        child: FlatButton(
                          onPressed: () {
                            undoPartneredShop();
                          },
                          child: Text(
                            'Undo Partner Shop',
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Colors.red,
                        ),
                      ),
                    ],
                  )
          ],
        ),
      ),
    );
  }
}
