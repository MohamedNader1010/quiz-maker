import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../main.dart';
import '../widgets/app_bar.dart';
import '../models/question.dart';
import '../widgets/option_tile.dart';
import '../widgets/show_result.dart';
import '../services/database.dart';
import 'result.dart';
import '../services/auth.dart';
import '../helpers/helper_function.dart';

class PlayQuiz extends StatefulWidget {
  final String quizId;

  PlayQuiz({required this.quizId});
  @override
  _PlayQuizState createState() => _PlayQuizState();
}

int counter1 = 0;
int counter2 = 0;
int _total = 0;
int _correct = 0;
int _inCorrect = 0;
int _notAttempted = 0;

class _PlayQuizState extends State<PlayQuiz> {
  DataBaseServices _dataBaseServices = new DataBaseServices();
  QuerySnapshot? _quizQuerySnapshot;

  QuestionModel getQuestionModelFromDataSnapshot(
      DocumentSnapshot? questionSnapshot) {
    QuestionModel questionModel = new QuestionModel();
    if (questionSnapshot!.data() == null) {
      print('IS QUES SNAPSHOT IS EQUAL TO NULL ?');
      return QuestionModel();
    } else {
      questionModel.question = questionSnapshot.get('question');
      List<String> options = [
        questionSnapshot.get('option1'),
        questionSnapshot.get('option2'),
        questionSnapshot.get('option3'),
        questionSnapshot.get('option4'),
      ];
      questionModel.correctAnswer = options[0];
      options.shuffle();
      questionModel.option1 = options[0];
      questionModel.option2 = options[1];
      questionModel.option3 = options[2];
      questionModel.option4 = options[3];
      questionModel.answered = false;

      return questionModel;
    }
  }

  @override
  void initState() {
    _dataBaseServices.getQuizData(widget.quizId).then((value) {
      _quizQuerySnapshot = value;
      print('LLLength: ${_quizQuerySnapshot!.docs.length}}');
      _total = _quizQuerySnapshot!.docs.length;
      _correct = 0;
      _inCorrect = 0;
      _notAttempted = _total;

      setState(() {});
    });
    super.initState();
  }

  _pullRefresh() async {
    await Future.delayed(Duration.zero).then((value) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    print('Counter of playQuiz: ${counter2++}');
    return Scaffold(
      appBar: AppBar(
        title: appBar(context),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        brightness: Brightness.light,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.black54,
        ),
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
      body: RefreshIndicator(
        onRefresh: () => _pullRefresh(),
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                _quizQuerySnapshot == null
                    ? Container(
                        height: MediaQuery.of(context).size.height,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : ListView.builder(
                        scrollDirection: Axis.vertical,
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        itemCount: _quizQuerySnapshot!.docs.length,
                        itemBuilder: (ctx, i) {
                          return QuizplayTile(
                            questionModel: getQuestionModelFromDataSnapshot(
                              _quizQuerySnapshot!.docs[i],
                            ),
                            index: i,
                          );
                        },
                      ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (ctx) => Result(
                correct: _correct,
                inCorrect: _inCorrect,
                total: _total,
              ),
            ),
          );
        },
        child: Icon(Icons.check),
      ),
    );
  }
}

class QuizplayTile extends StatefulWidget {
  final QuestionModel questionModel;
  final int index;

  const QuizplayTile({required this.questionModel, required this.index});

  @override
  _QuizplayTileState createState() => _QuizplayTileState();
}

class _QuizplayTileState extends State<QuizplayTile> {
  String optionSelected = '';
  @override
  void didChangeDependencies() {
    setState(() {});
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    print('Counter of build QuizPlatTile: ${counter1++}');
    print('see what is print : ${_PlayQuizState().reassemble}');
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              child: widget.index > 0
                  ? Container()
                  : Row(
                      children: [
                        ShowResult(count: _total, label: "Total"),
                        SizedBox(width: 10),
                        ShowResult(count: _correct, label: "Correct"),
                        SizedBox(width: 10),
                        ShowResult(count: _inCorrect, label: "Incorrect"),
                        SizedBox(width: 10),
                        ShowResult(count: _notAttempted, label: "NotAttempted"),
                      ],
                    ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            'Q.${widget.index + 1} ${widget.questionModel.question}',
            style: TextStyle(
              fontSize: 17,
              color: Colors.black54,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 4,
          ),
          GestureDetector(
            onTap: () {
              if (!widget.questionModel.answered) {
                if (widget.questionModel.option1 ==
                    widget.questionModel.correctAnswer) {
                  optionSelected = widget.questionModel.option1;
                  widget.questionModel.answered = true;

                  _correct += 1;
                  _notAttempted -= 1;

                  setState(() {});
                } else {
                  optionSelected = widget.questionModel.option1;
                  widget.questionModel.answered = true;

                  _inCorrect += 1;
                  _notAttempted -= 1;

                  setState(() {});
                }
              }
            },
            child: OptionTile(
              option: "A",
              correctAnswer: widget.questionModel.correctAnswer,
              optSelected: optionSelected,
              desc: widget.questionModel.option1,
            ),
          ),
          SizedBox(
            height: 8,
          ),
          GestureDetector(
            onTap: () {
              if (!widget.questionModel.answered) {
                if (widget.questionModel.option2 ==
                    widget.questionModel.correctAnswer) {
                  optionSelected = widget.questionModel.option2;
                  widget.questionModel.answered = true;

                  _correct += 1;
                  _notAttempted -= 1;

                  setState(() {});
                } else {
                  optionSelected = widget.questionModel.option2;
                  widget.questionModel.answered = true;

                  _inCorrect += 1;
                  _notAttempted -= 1;

                  setState(() {});
                }
              }
            },
            child: OptionTile(
              option: "B",
              correctAnswer: widget.questionModel.correctAnswer,
              optSelected: optionSelected,
              desc: widget.questionModel.option2,
            ),
          ),
          SizedBox(
            height: 8,
          ),
          GestureDetector(
            onTap: () {
              if (!widget.questionModel.answered) {
                if (widget.questionModel.option3 ==
                    widget.questionModel.correctAnswer) {
                  optionSelected = widget.questionModel.option3;
                  widget.questionModel.answered = true;

                  _correct += 1;
                  _notAttempted -= 1;

                  setState(() {});
                } else {
                  optionSelected = widget.questionModel.option3;
                  widget.questionModel.answered = true;

                  _inCorrect += 1;
                  _notAttempted -= 1;

                  setState(() {});
                }
              }
            },
            child: OptionTile(
              option: "C",
              correctAnswer: widget.questionModel.correctAnswer,
              optSelected: optionSelected,
              desc: widget.questionModel.option3,
            ),
          ),
          SizedBox(
            height: 8,
          ),
          GestureDetector(
            onTap: () {
              if (!widget.questionModel.answered) {
                if (widget.questionModel.option4 ==
                    widget.questionModel.correctAnswer) {
                  optionSelected = widget.questionModel.option4;
                  widget.questionModel.answered = true;
                  _correct += 1;
                  _notAttempted -= 1;

                  setState(() {});
                } else {
                  optionSelected = widget.questionModel.option4;
                  widget.questionModel.answered = true;
                  _inCorrect += 1;
                  _notAttempted -= 1;

                  setState(() {});
                }
              }
            },
            child: OptionTile(
              option: "D",
              correctAnswer: widget.questionModel.correctAnswer,
              optSelected: optionSelected,
              desc: widget.questionModel.option4,
            ),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
