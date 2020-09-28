import 'package:flutter/material.dart';
import 'package:ohostel_hostel_agent_app/auth/methods/auth_methods.dart';
import 'package:ohostel_hostel_agent_app/auth/models/login_user_model.dart';
import 'package:ohostel_hostel_agent_app/auth/wrapper.dart';
import 'package:ohostel_hostel_agent_app/hive_methods/hive_class.dart';
import 'package:provider/provider.dart';
import 'package:ohostel_hostel_agent_app/widgets/styles.dart' as Styles;

void main() {
  // init hive
  WidgetsFlutterBinding.ensureInitialized();
  InitHive().startHive(boxName: 'userDataBox');

  // run app
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // provider is being used here at the top most widget tree so we can notify
    // every other sub widget down the widget tree.
    return StreamProvider<LoginUserModel>.value(
      value: AuthService().userStream,
      child: MaterialApp(
        title: "O'Hstel Agent",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.deepOrange,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Wrapper(),
      ),
    );
  }
}
