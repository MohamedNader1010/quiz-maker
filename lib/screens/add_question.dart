import 'package:flutter/material.dart';
import 'package:quizmaker/widgets/my_custom_button.dart';

import '../main.dart';
import '../widgets/app_bar.dart';
import '../services/database.dart';
import '../services/auth.dart';
import '../helpers/helper_function.dart';

class AddQuestion extends StatefulWidget {
  final quizId;
  AddQuestion({required this.quizId});

  @override
  _AddQuestionState createState() => _AddQuestionState();
}

class _AddQuestionState extends State<AddQuestion> {
  String _question = '';
  String _opt1 = '';
  String _opt2 = '';
  String _opt3 = '';
  String _opt4 = '';
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  submit() {
    if (_formKey.currentState!.validate()) {
      uploadQuestionData();
      Navigator.of(context).pop();
    } else {
      Navigator.of(context).pop();
    }
  }

  uploadQuestionData() async {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      setState(() {
        _isLoading = true;
      });
      Map<String, String> questionData = {
        "option1": _opt1,
        "option2": _opt2,
        "option3": _opt3,
        "option4": _opt4,
        "quizId": widget.quizId,
        "question": _question,
      };
      await DataBaseServices()
          .addQuestionData(questionData, widget.quizId)
          .catchError(
        (onError) {
          print(
            onError.toString(),
          );
        },
      ).then((_) {
        setState(() {
          _isLoading = false;
          _formKey.currentState!.reset();
        });
        print('Succeeded!');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: appBar(context),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
        brightness: Brightness.light,
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
            margin: EdgeInsets.symmetric(horizontal: 20),
            padding: EdgeInsets.symmetric(vertical: 10),
            height: MediaQuery.of(context).size.height - 100,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Expanded(
                  child: TextFormField(
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return "Please enter a Question.";
                      } else
                        return null;
                    },
                    decoration: InputDecoration(
                      hintText: "Question",
                    ),
                    onChanged: (val) {
                      _question = val;
                    },
                  ),
                ),
                SizedBox(height: 6),
                Expanded(
                  child: TextFormField(
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return 'Please enter Option1.';
                      } else
                        return null;
                    },
                    decoration: InputDecoration(
                      hintText: "Option1 (Correct Answer)",
                    ),
                    onChanged: (val) {
                      _opt1 = val;
                    },
                  ),
                ),
                SizedBox(height: 6),
                Expanded(
                  child: TextFormField(
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return 'Please enter Option2.';
                      } else
                        return null;
                    },
                    decoration: InputDecoration(
                      hintText: "Option2",
                    ),
                    onChanged: (val) {
                      _opt2 = val;
                    },
                  ),
                ),
                SizedBox(
                  height: 6,
                ),
                Expanded(
                  child: TextFormField(
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return 'Please enter Option3.';
                      } else
                        return null;
                    },
                    decoration: InputDecoration(
                      hintText: "Option3",
                    ),
                    onChanged: (val) {
                      _opt3 = val;
                    },
                  ),
                ),
                SizedBox(
                  height: 6,
                ),
                Expanded(
                  child: TextFormField(
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return 'Please enter Option4.';
                      } else
                        return null;
                    },
                    decoration: InputDecoration(
                      hintText: "Option4",
                    ),
                    onChanged: (val) {
                      _opt4 = val;
                    },
                  ),
                ),
                Spacer(),
                _isLoading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            MyCustomButton(submit, 'Submit',
                                (MediaQuery.of(context).size.width / 2) - 40),
                            MyCustomButton(uploadQuestionData, 'Add Question',
                                (MediaQuery.of(context).size.width / 2) - 40),
                          ],
                        ),
                      ),
                SizedBox(
                  height: 40,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
