// Tento soubor obsahuje funkce pro manipulaci s daty setů v databázi Firebase

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:words_app_3/backend/data/users_database/progress_data.dart';
import 'package:words_app_3/backend/system/models.dart';
import 'package:words_app_3/backend/data/main_database/word_data.dart';

class SetDataService {
  // Odkaz na databázi
  final FirebaseFirestore db = FirebaseFirestore.instance;

  // Odkazy na kolekce
  CollectionReference coursesCollection = FirebaseFirestore.instance.collection("courses");
  CollectionReference usersCollection = FirebaseFirestore.instance.collection("users");

  // Zápis setu do databáze "sets"
  Future<SetModel> addSet(SetModel setModel, List<WordModel> words) async {
    
    CollectionReference setsCollection = FirebaseFirestore.instance
      .collection("courses")
      .doc(setModel.courseId)
      .collection("sets");

    // Přidání nového setu
    if(setModel.setId == null) {
      setsCollection.add(setModel.setToMap()).then((DocumentReference doc) {
        ProgressDataService().addStudentsSetProgress(doc.id, setModel.courseId, null);

        setModel.setId = doc.id;

        // Zápis všech slov v setu
        for(WordModel word in words) {
          WordDataService().addWord(setModel, word);
          ProgressDataService().addStudentsWordProgress(word.wordId!, setModel.setId, setModel.courseId, null);
        }
      });
    
    // Aktualizace existujícího setu
    } else {
      setsCollection.doc(setModel.setId).update(setModel.setToMap()).then((value) {
    
        // Zápis všech slov v setu
        updateWords(setModel, words);
      });
    }
    
    return setModel;
  }

  // Aktualizace slov
  Future<void> updateWords(SetModel setModel, List<WordModel> wordsToUpdate) async {
    if(setModel.setId == null) {
      return;
    }

    for(WordModel word in wordsToUpdate) {
      if(word == WordModel(null, null, null)) {
        wordsToUpdate.remove(word);
      }
    }

    List<WordModel> databaseWordsList = await WordDataService().getWordsList(setModel);

    for(WordModel word in databaseWordsList) {

      // Zkontrolovat, existuje-li slovo se stejným wordId
      // Pokud ne, spustí se následující if statement
      if(!wordsToUpdate.any((element) => element.wordId == word.wordId)) {
        WordDataService().deleteWord(setModel, word.wordId as String);
        ProgressDataService().deleteStudentsWordProgress(word.wordId, setModel.setId, setModel.courseId, null);

      } else {
        // Zkontrolovat, jsou-li data identická
        // Pokud ne, spustí se následující if statement
        WordModel wordToUpdate = wordsToUpdate.firstWhere((element) => element.wordId == word.wordId);
        if(!(word.original == wordToUpdate.original && word.translation == wordToUpdate.translation)) {
          WordDataService().addWord(setModel, wordToUpdate);
        }
        wordsToUpdate.remove(wordToUpdate);
      }
    }

    for(WordModel newWord in wordsToUpdate) {
      WordDataService().addWord(setModel, newWord);
      ProgressDataService().addStudentsWordProgress(newWord.wordId!, setModel.setId, setModel.courseId, null);
    }
  }

  // Výpis seznamu setů z databáze "sets"
  Future<List<SetModel>> getSetsList(courseId) async {
    List<SetModel> setsList = [];

    await coursesCollection
      .doc(courseId)
      .collection("sets")
      .get().then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
          setsList.add(SetModel(courseId, doc.id, doc["title"]));
      }
    });

    return setsList;
  }

  // Výpis názvu setu
  Future<String> getSetTitleFuture(SetModel? set) async {
    if (set == null) {
      return "Firstly choose a set.";
    }
    
    CollectionReference setsCollection = coursesCollection
      .doc(set.courseId)
      .collection("sets");

    await setsCollection.get().then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if(doc.id == set?.setId) {
          set = SetModel(set?.courseId, set?.setId, doc["title"]);
          // print(set?.setToMap().toString());
        }
      }

    });
    if (set?.title == null) {
      return "No title.";
    } else {
      return set!.title ?? "No text";
    }
  }

  // Výpis počtu slov v setu
  Future<int> getWordsNumberFuture(SetModel setModel) async {
    int numberOfWords = 0;

    CollectionReference wordsCollection = coursesCollection
      .doc(setModel.courseId)
      .collection("sets")
      .doc(setModel.setId)
      .collection("words");

    await wordsCollection.get().then((QuerySnapshot querySnapshot) {
      numberOfWords = querySnapshot.docs.length;
    });
    
    return numberOfWords;
  }

  // Smazání setu
  Future<void> deleteSet(SetModel set) async {
    DocumentReference setDoc = coursesCollection
      .doc(set.courseId)
      .collection('sets')
      .doc(set.setId);
    
    ProgressDataService().deleteStudentsSetProgress(set.setId, set.courseId, null);
    
    await setDoc.delete();
  }
}