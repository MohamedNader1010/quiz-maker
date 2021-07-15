import 'package:flutter/material.dart';

import '../widgets/app_bar.dart';
import '../widgets/signup_form.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: appBar(context),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        brightness: Brightness.light,
        actions: [
          Icon(Icons.logout),
        ],
      ),
      body: SignupForm(),
    );
  }
}
