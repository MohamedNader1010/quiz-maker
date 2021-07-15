import 'package:flutter/material.dart';

import '../main.dart';
import '../widgets/app_bar.dart';
import '../services/auth.dart';
import '../helpers/helper_function.dart';

class Result extends StatelessWidget {
  final correct, inCorrect, total;

  const Result({
    required this.correct,
    required this.inCorrect,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: appBar(context),
        elevation: 0.0,
        brightness: Brightness.light,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              HelperFunction.deleteUserLoggedInDetails();
              Auth().signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (ctx) => MyApp(),
                ),
              );
            },
            icon: Icon(Icons.logout),
            color: Colors.black54,
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 10,
        ),
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${correct}/${total}',
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'You answered $correct answers correctly, and $inCorrect answers incorrectly.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[400],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
