import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:ohostel_hostel_agent_app/auth/methods/auth_database_methods.dart';
import 'package:ohostel_hostel_agent_app/auth/models/login_user_model.dart';
import 'package:ohostel_hostel_agent_app/hive_methods/hive_class.dart';

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;

  final CollectionReference shopOwnerDataCollectionRef =
      Firestore.instance.collection('shopOwnersData');

  // create login user object
  LoginUserModel userFromFirebase(FirebaseUser user) {
    return user != null ? LoginUserModel(uid: user.uid) : null;
  }

  //auth change user stream
  Stream<LoginUserModel> get userStream {
    /// emit a stream of user current state(e.g emit an event when the user
    /// log out so the UI can be notify and update as needed or emit a event when
    /// a user log in so the UI can also be updated

    return auth.onAuthStateChanged.map(userFromFirebase);
  }

  // log in with email an pass
  Future loginWithEmailAndPassword(
      {@required String email, @required String password}) async {
    try {
      AuthResult result = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      FirebaseUser user = result.user;

      await getUserDetails(uid: user.uid);

      return userFromFirebase(user);
    } catch (e) {

      Fluttertoast.showToast(msg: e.message, toastLength: Toast.LENGTH_LONG);
      return null;
    }
  }

  // register with email an pass
  Future registerWithEmailAndPassword({
    @required String email,
    @required String password,
    @required String fullName,
    @required String shopName,
    @required String phoneNumber,
    @required String uniName,
    @required String address,
  }) async {

    try {
      AuthResult result = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      FirebaseUser user = result.user;


      await shopOwnerDataCollectionRef
          .where('shopName', isEqualTo: shopName)
          .getDocuments()
          .then((shop) {


        if (shop.documents.length > 1) {

          throw Exception('User Name Already Taken!!');
        }
      });

      if (user.uid != null) {

        // add user details to  shop firestore database
        await AuthDatabaseMethods().createShopOwnerDataInFirestore(
          uid: user.uid,
          email: email,
          fullName: fullName,
          address: address,
          shopName: shopName,
          phoneNumber: phoneNumber,
          uniName: uniName,
        );


        // save user info to local database using hive
        await saveUserDataToDb(userData: {
          'uid': user.uid,
          'email': email,
          'fullName': fullName,
          'shopName': shopName,
          'address': address,
          'phoneNumber': phoneNumber,
          'uniName': uniName,
        });
      }


      return userFromFirebase(user);
    } catch (e, s) {


      Fluttertoast.showToast(msg: e.message, toastLength: Toast.LENGTH_LONG);

      return null;
    }
  }

  // signing out method
  Future signOut() async {
    try {
      deleteUserDataToDb();
      return await auth.signOut();
    } catch (e) {

      Fluttertoast.showToast(msg: '${e.message}');
    }
  }

  Future getUserDetails({@required String uid}) async {
    try {
      DocumentSnapshot document = await shopOwnerDataCollectionRef.document(uid).get();

      saveUserDataToDb(userData: document.data);
    } catch (e) {
      Fluttertoast.showToast(msg: '${e.message}');
    }
  }

  Future<void> saveUserDataToDb({@required Map userData}) async {
    Box<Map> userDataBox = await HiveMethods().getOpenBox('agentData');
    final key = 0;
    final value = userData;
    userData.remove('dateJoined');

    userDataBox.put(key, value);

  }

  void deleteUserDataToDb() {
    Box<Map> userDataBox = Hive.box<Map>('userDataBox');
    final key = 0;
    userDataBox.delete(key);
  }
}
