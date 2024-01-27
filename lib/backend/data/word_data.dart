import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:words_app_3/backend/auth.dart';
import 'package:words_app_3/backend/models.dart';

class WordDataService {
  // Odkaz na databázi
  final FirebaseFirestore db = FirebaseFirestore.instance;

  // Odkazy na kolekce
  CollectionReference coursesCollection = FirebaseFirestore.instance.collection("courses");
  CollectionReference usersCollection = FirebaseFirestore.instance.collection("users");

  // Zápis slova do databáze "words"
  Future<WordModel> addWord(SetModel setModel, WordModel word) async {
    CollectionReference wordsCollection = FirebaseFirestore.instance
      .collection("courses")
      .doc(setModel.courseId)
      .collection("sets")
      .doc(setModel.setId)
      .collection("words");

    if(word.wordId == null) {
      wordsCollection.add(word.wordToMap()).then((DocumentReference doc) {
        addWordProgress(doc.id, setModel.setId, setModel.courseId, AuthService().user?.uid);
        print('New word added.\tDocumentSnapshot added with ID: ${doc.id}');
      });
    } else {
      wordsCollection.doc(word.wordId).update(word.wordToMap());
    }
    
    return word;
  }

  // Zápis progressu slova do databáze "wordProgress", která je součástí
  // databáze "setProress", která je součástí databáze "courseProgress"
  Future<WordModel> addWordProgress(wordId, setId, courseId, userId) async {
    WordModel word = WordModel(wordId, null, null);
    CollectionReference wordProgressCollection = FirebaseFirestore.instance
      .collection("users")
      .doc(userId)
      .collection("courseProgress")
      .doc(courseId)
      .collection("setProgress")
      .doc(setId)
      .collection("wordProgress");
    
    Map<String, dynamic> wordProgressMap = {
      "wordId": wordId,
      "memory": 0
    };

    wordProgressCollection.add(wordProgressMap).then((DocumentReference doc) {
      print('New wordProgress added\tDocumentSnapshot added with ID: ${doc.id}');
    });
    return word;
  }

  // Výpis seznamu slov z databáze "words" v setu, který
  // je v databázi "sets"
  Future<List<WordModel>> getWordsListFuture(SetModel setModel) async {
    List<WordModel> wordList = [];

    CollectionReference wordsCollection = coursesCollection
      .doc(setModel.courseId)
      .collection("sets")
      .doc(setModel.setId)
      .collection("words");

    await wordsCollection.get().then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
          // print("Doc: ${doc.id}");
          // print("Original: ${doc["original"]}\tTranslation: ${doc["translation"]}\n");
          wordList.add(WordModel(doc.id, doc["original"], doc["translation"]));
      }
    });

    return wordList;
  }

  // Smazání slova
  Future<void> deleteWord(SetModel set, String wordId) async {
    DocumentReference wordDoc = coursesCollection
      .doc(set.courseId)
      .collection('sets')
      .doc(set.setId)
      .collection('words')
      .doc(wordId);
    
    await wordDoc.delete();
    await deleteWordProgress(wordId, set.setId, set.courseId, AuthService().user?.uid);
  }

  Future<void> deleteWordProgress(wordId, setId, courseId, userId) async {
    DocumentReference wordProgressDoc = FirebaseFirestore.instance
      .collection("users")
      .doc(userId)
      .collection("courseProgress")
      .doc(courseId)
      .collection("setProgress")
      .doc(setId)
      .collection("wordProgress")
      .doc(wordId);

    await wordProgressDoc.delete();
  }
}