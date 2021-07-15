import 'package:flutter/material.dart';

import '../helpers/helper_function.dart';
import '../services/auth.dart';
import 'signup_or_signin_layout.dart';
import '../widgets/my_custom_button.dart';
import '../screens/home.dart';

enum SignInOrSignOut { signin, signup }

class SignupForm extends StatefulWidget {
  @override
  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  Auth _auth = new Auth();

  String email = '', pwd = '', name = '';
  signUp() async {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      setState(() {
        _isLoading = true;
      });
      _auth.signUpWithEmailAndPassword(context, email, pwd).catchError((e) {
        print(e);
      }).then((val) {
        if (val != null) {
          setState(() {
            _isLoading = false;
          });
          HelperFunction.saveUserLoggedInDetails(true);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (ctx) => Home(),
            ),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: Column(
          children: [
            Spacer(),
            Container(
              height: 280,
              width: double.infinity,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextFormField(
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return 'Please enter a Name';
                        } else if (val.length < 7) {
                          return 'Name should be at least 7 characters.';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: 'Name',
                      ),
                      onChanged: (val) {
                        name = val;
                      },
                    ),
                    SizedBox(height: 6),
                    TextFormField(
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return 'Please enter an Email';
                        } else if (!val.contains('@')) {
                          return 'Invalid E-mail.';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: 'E-mail',
                      ),
                      onChanged: (val) {
                        email = val;
                      },
                    ),
                    SizedBox(height: 6),
                    TextFormField(
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return 'Please enter a Password';
                        } else if (val.length < 7) {
                          return 'password should be at least 7 characters.';
                        }
                        return null;
                      },
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Password',
                      ),
                      onChanged: (val) {
                        pwd = val;
                      },
                    ),
                    SizedBox(height: 14),
                    _isLoading
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : MyCustomButton(signUp, 'Sign Up'),
                    SizedBox(
                      height: 10,
                    ),
                    SignUpOrSignInLayout(
                      SignInOrSignOut.signup.toString(),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
