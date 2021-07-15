import 'package:flutter/material.dart';
import 'package:quizmaker/screens/add_question.dart';
import 'package:random_string/random_string.dart';

import '../main.dart';
import '../widgets/my_custom_button.dart';
import '../widgets/app_bar.dart';
import '../services/database.dart';
import '../screens/add_question.dart';
import '../services/auth.dart';
import '../helpers/helper_function.dart';

class CreateQuiz extends StatefulWidget {
  const CreateQuiz({Key? key}) : super(key: key);

  @override
  _CreateQuizState createState() => _CreateQuizState();
}

class _CreateQuizState extends State<CreateQuiz> {
  final _formKey = GlobalKey<FormState>();
  String _quizImageUrl = '', _quizTitle = '', _quizDescription = '';
  bool _isLoading = false;
  uploadQuizData() async {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();

      setState(() {
        _isLoading = true;
      });
      String? quizId = randomAlphaNumeric(16);

      Map<String, String> quizData = {
        "quizId": quizId,
        "quizImageUrl": _quizImageUrl,
        "quizTitle": _quizTitle,
        "quizDescription": _quizDescription,
      };
      await DataBaseServices().addQuizData(quizData, quizId).then((_) {
        setState(() {
          _isLoading = false;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (ctx) => AddQuestion(quizId: quizId),
            ),
          );
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: appBar(context),
        brightness: Brightness.light,
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
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
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height - 100,
            margin: EdgeInsets.symmetric(horizontal: 20),
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Column(
              children: [
                TextFormField(
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return "Please enter Image Url.";
                    } else
                      return null;
                  },
                  decoration: InputDecoration(
                    hintText: "Quiz Image Url",
                  ),
                  onChanged: (val) {
                    _quizImageUrl = val;
                  },
                ),
                SizedBox(height: 6),
                TextFormField(
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Please enter Quiz Title.';
                    } else
                      return null;
                  },
                  decoration: InputDecoration(
                    hintText: "Quiz Title",
                  ),
                  onChanged: (val) {
                    _quizTitle = val;
                  },
                ),
                SizedBox(height: 6),
                TextFormField(
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Please enter Quiz Description.';
                    } else
                      return null;
                  },
                  decoration: InputDecoration(
                    hintText: "Quiz Description",
                  ),
                  onChanged: (val) {
                    _quizDescription = val;
                  },
                ),
                Spacer(),
                _isLoading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : MyCustomButton(uploadQuizData, 'Create Quiz'),
                SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
