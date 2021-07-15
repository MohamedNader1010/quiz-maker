import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HelperFunction {
  static String userLoggedInKey = 'USERLOGGEDINKEY';

  static saveUserLoggedInDetails(bool _isLoggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(userLoggedInKey, _isLoggedIn);
  }

  static deleteUserLoggedInDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(userLoggedInKey);
  }

  static getUserLoggedInDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(userLoggedInKey);
  }

  static getQuizData() {
    FirebaseFirestore fireStore = FirebaseFirestore.instance;
    return fireStore.collection('Quiz').snapshots();
  }
}
