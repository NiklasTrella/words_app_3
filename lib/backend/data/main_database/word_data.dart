// Tento soubor obsahuje funkce pro manipulaci s daty slov v databázi Firebase

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:words_app_3/backend/data/users_database/progress_data.dart';
import 'package:words_app_3/backend/system/models.dart';

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
        ProgressDataService().addStudentsWordProgress(doc.id, setModel.setId, setModel.courseId, null);
      });
    } else {
      wordsCollection.doc(word.wordId).update(word.wordToMap());
    }
    
    return word;
  }

  // Výpis seznamu slov z databáze "words"
  Future<List<WordModel>> getWordsList(SetModel setModel) async {
    List<WordModel> wordList = [];

    CollectionReference wordsCollection = coursesCollection
      .doc(setModel.courseId)
      .collection("sets")
      .doc(setModel.setId)
      .collection("words");

    await wordsCollection.get().then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
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
    await ProgressDataService().deleteStudentsWordProgress(wordId, set.setId, set.courseId, null);
  }
}