import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ohostel_hostel_agent_app/auth/methods/auth_methods.dart';
import 'package:ohostel_hostel_agent_app/auth/pages/sigup_page.dart';

class ToggleBetweenLoginAndSignUpPage extends StatefulWidget {
  @override
  _ToggleBetweenLoginAndSignUpPageState createState() =>
      _ToggleBetweenLoginAndSignUpPageState();
}

class _ToggleBetweenLoginAndSignUpPageState
    extends State<ToggleBetweenLoginAndSignUpPage> {
  bool showLogInPage = true;

  void toggleView() {
    setState(() {
      showLogInPage = !showLogInPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLogInPage) {
      return LogInPage(toggleView: toggleView);
    } else {
      return SignUpPage(toggleView: toggleView);
    }
  }
}

class LogInPage extends StatefulWidget {
  final Function toggleView;

  LogInPage({this.toggleView});

  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  String email;
  String password;
  final formKey = GlobalKey<FormState>();
  bool loading = false;

  AuthService authService = AuthService();

  Future<void> validateAndSave() async {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      setState(() {
        loading = true;
        print(loading);
      });
      print('From is vaild');
      print(email);
      print(password);
      await logInUser();
      if(mounted) {
        setState(() {
          loading = false;
        });
      }
    } else {
      Fluttertoast.showToast(msg: 'Invaild Inputs');
      setState(() {
        loading = false;
      });
    }
    print(loading);
  }

  Future<void> logInUser() async {
    await authService.loginWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading != true
          ? SingleChildScrollView(
              child: Container(
              child: Form(
                key: formKey,
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 100,
                      child: Center(
                        child: Text(
                          'LogIn',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20.0),
                        ),
                      ),
                    ),
                    emailInputFieldBox(),
                    passwordInputFieldBox(),
                    logInButton(),
                    forgotPassword(),
                    signUpButton(),
                  ],
                ),
              ),
            ))
          : Center(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(),
                    Text('Loading......')
                  ],
                ),
              ),
            ),
    );
  }

  Widget emailInputFieldBox() {
    return Container(
      child: TextFormField(
        validator: (value) {
          if (value.trim().isEmpty) {
            return 'Email Can\'t Be Empty';
          } else {
            return null;
          }
        },
        decoration: InputDecoration(
          labelText: 'Email',
        ),
        onSaved: (value) => email = value.trim(),
        keyboardType: TextInputType.emailAddress,
      ),
      padding: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey[200]),
        ),
      ),
    );
  }

  Widget passwordInputFieldBox() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
        child: TextFormField(
          validator: (value) {
            if (value.trim().isEmpty) {
              return 'Password Can\'t Be Empty';
            } else {
              return null;
            }
          },
          decoration: InputDecoration(
            labelText: 'Password',
          ),
          obscureText: true,
          onSaved: (value) => password = value.trim(),
        ),
      ),
    );
  }

  Widget logInButton() {
    return Container(
      margin: EdgeInsets.all(20),
      height: 60,
      width: MediaQuery.of(context).size.width * 0.80,
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(15),
      ),
      child: RaisedButton(
        onPressed: () {
          validateAndSave();
        },
        child: Center(
          child: Text(
            'LogIn',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget signUpButton() {
    return InkWell(
      onTap: () {
        widget.toggleView();
      },
      child: Container(
        margin: EdgeInsets.all(20),
        height: 60,
        width: MediaQuery.of(context).size.width * 0.80,
        decoration: BoxDecoration(
            color: Colors.green, borderRadius: BorderRadius.circular(15)),
        child: Center(
          child: Text(
            'SignUp',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget forgotPassword() {
    return Container(
      padding: EdgeInsets.all(10),
      child: InkWell(
        onTap: () {
          widget.toggleView();
        },
        child: Text(
          'Forgot Password ??',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
        ),
      ),
    );
  }
}
