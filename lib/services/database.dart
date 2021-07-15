import 'package:cloud_firestore/cloud_firestore.dart';

class DataBaseServices {
  Future<void> addQuizData(Map<String, dynamic> quizData, String quizId) {
    final fireStore = FirebaseFirestore.instance;

    return fireStore.collection('Quiz').doc(quizId).set(quizData).catchError(
      (onError) {
        print(
          onError.toString(),
        );
      },
    );
  }

  Future<void> addQuestionData(
    Map<String, dynamic> questionData,
    String quizId,
  ) {
    final fireStore = FirebaseFirestore.instance;
    return fireStore
        .collection('Quiz')
        .doc(quizId)
        .collection('QNA')
        .doc()
        .set(questionData)
        .catchError((onError) {
      print(
        onError.toString(),
      );
    });
  }

  getQuizData(String quizId) async {
    return await FirebaseFirestore.instance
        .collection('Quiz')
        .doc(quizId)
        .collection('QNA')
        .get();
  }
}
