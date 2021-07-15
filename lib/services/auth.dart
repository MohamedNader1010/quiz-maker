import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/user.dart';

class Auth {
  UserUID? _userFromFirebase(User? user) {
    return user != null ? UserUID(uid: user.uid) : null;
  }

  Future signInWithEmailAndPassword(
      BuildContext context, String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password)
          .catchError((onError) {
        print('onError: $onError');
      });
      print('Is there any something wrong!!');
      User? _user = userCredential.user;
      print('after siging in function');
      return _userFromFirebase(_user!);
    } on FirebaseAuthException catch (error) {
      var message = 'An error occured. Please check your credentials.';

      if (error.code == 'weak-password') {
        message = error.code;
        print('--------------------------------------------------');
      } else if (error.code == 'email-already-in-use') {
        message = error.code;
      } else if (error.code == 'user-not-found') {
        message = error.code;
      } else if (error.code == 'wrong-password') {
        message = error.code;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message.toString(),
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
      print(e.toString());
    }
  }

  Future signUpWithEmailAndPassword(
      BuildContext context, String email, String password) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final _user = userCredential.user;
      return _userFromFirebase(_user!);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
      print(e);
    }
  }

  Future signOut() async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
