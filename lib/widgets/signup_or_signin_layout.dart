import 'package:flutter/material.dart';

import '../screens/signin.dart';
import '../screens/signup.dart';

enum SignInOrSignOut { signin, signup }

class SignUpOrSignInLayout extends StatelessWidget {
  final String x;

  const SignUpOrSignInLayout(this.x);
  @override
  Widget build(BuildContext context) {
    if (x == SignInOrSignOut.signin.toString()) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Don\'t have an account?  ',
            style: TextStyle(
              fontSize: 14,
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (ctx) => SignUp(),
                ),
              );
            },
            child: Text(
              'Sign up',
              style: TextStyle(
                fontSize: 14,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      );
    } else {
      return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(
          'Already have an account ',
          style: TextStyle(
            fontSize: 14,
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (ctx) => Signin(),
              ),
            );
          },
          child: Text(
            'Sign in',
            style: TextStyle(
              fontSize: 14,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ]);
    }
  }
}
