import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../main.dart';
import '../screens/play_quiz.dart';
import '../helpers/helper_function.dart';
import '../widgets/app_bar.dart';
import 'create_quiz.dart';
import '../services/auth.dart';
import '../helpers/helper_function.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final firestore = FirebaseFirestore.instance;
  Stream? quizData;
  Widget QuizList() {
    return Container(
      width: double.infinity,
      child: StreamBuilder(
          stream: HelperFunction.getQuizData(),
          builder: (ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: Text('No Data...'),
              );
            } else {
              final items = snapshot.data;
              print('ItemsLength : $items');
              return items == null
                  ? Center(
                      child: Text('NO DATA ...'),
                    )
                  : ListView.builder(
                      itemCount: items.docs.length,
                      itemBuilder: (ctx, i) {
                        return QuizTile(
                          desc: items.docs[i].get('quizDescription'),
                          title: items.docs[i].get('quizTitle'),
                          imageUrl: items.docs[i].get('quizImageUrl'),
                          quizId: items.docs[i].get('quizId'),
                        );
                      });
            }
          }),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: appBar(context),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        brightness: Brightness.light,
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
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (ctx) => CreateQuiz(),
            ),
          );
        },
      ),
      body: QuizList(),
    );
  }
}

class QuizTile extends StatelessWidget {
  final imageUrl, title, desc, quizId;

  const QuizTile({this.imageUrl, this.title, this.desc, this.quizId});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (ctx) => PlayQuiz(
              quizId: quizId,
            ),
          ),
        );
      },
      child: Container(
        height: 150,
        margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
        ),
        child: ClipRRect(
          child: Stack(
            fit: StackFit.expand,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.fill,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    desc,
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
