import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:words_app_3/backend/auth.dart';
import 'package:words_app_3/backend/models.dart';

// Odkazy na ostatní datové třídy
import 'package:words_app_3/backend/data/word_data.dart';

class SetDataService {
  // Odkaz na databázi
  final FirebaseFirestore db = FirebaseFirestore.instance;

  // Odkazy na kolekce
  CollectionReference coursesCollection = FirebaseFirestore.instance.collection("courses");
  CollectionReference usersCollection = FirebaseFirestore.instance.collection("users");

  // Zápis setu do databáze "sets" jednoho kurzu, který je
  // součástí databáze "courses"
  Future<SetModel> addSet(SetModel setModel, List<WordModel> words) async {
    
    CollectionReference setsCollection = FirebaseFirestore.instance
      .collection("courses")
      .doc(setModel.courseId)
      .collection("sets");

    // Přidání nového setu
    if(setModel.setId == null) {
      setsCollection.add(setModel.setToMap()).then((DocumentReference doc) {
        print('New set added.\tDocumentSnapshot added with ID: ${doc.id}');
        addSetProgress(doc.id, setModel.courseId, AuthService().user?.uid);

        // Zápis všech slov v setu
        for(WordModel word in words) {
          WordDataService().addWord(setModel, word);
        }
      });
    // Aktualizace existujícího setu
    } else {
      setsCollection.doc(setModel.setId).update(setModel.setToMap()).then((value) {
      print("An old set updated.\tSetId: ${setModel.setId}");
        // Zápis všech slov v setu
        updateWords(setModel, words);
      });
    }
    
    return setModel;
  }

  // Zápis progressu setu do databáze "setProgress",
  Future<SetModel> addSetProgress(setId, courseId, userId) async {
    SetModel set = SetModel(courseId, setId, null);
    CollectionReference setsCollection = FirebaseFirestore.instance
      .collection("users")
      .doc(userId)
      .collection("courseProgress")
      .doc(courseId)
      .collection("setProgress");

    setsCollection.add(set.setProgressToMap()).then((DocumentReference doc) {
      print('New setProgress added.\nDocumentSnapshot added with ID: ${doc.id}');
    });
    return set;
  }

  Future<void> updateWords(SetModel setModel, List<WordModel> wordsToUpdate) async {
    if(setModel.setId == null) {
      print("SetId is null. That's wrong.");
      return;
    }

    for(WordModel word in wordsToUpdate) {
      if(word == WordModel(null, null, null)) {
        wordsToUpdate.remove(word);
      }
    }

    /* Postup:
      1. Získat seznam slov z databáze
      2. Zkontrolovat všechna slova v databázi se seznamem "words" → vždy po kontrole slovo smazat ze seznamu "words"
        2.1. Smazat všechna slova, která nejsou v seznamu "words" (podle id)
        2.2. Updatovat slova, která jsou odlišná od těch v seznamu "words"
      3. Projít ostatní slova v seznamu "words" a přidat je
    */

    List<WordModel> databaseWordsList = await WordDataService().getWordsListFuture(setModel);

    for(WordModel word in databaseWordsList) {
      // Zkontrolovat, existuje-li slovo se stejným wordId
      // Pokud ne, spustí se následující if statement
      if(!wordsToUpdate.any((element) => element.wordId == word.wordId)) {
        if(word.wordId == null) {
          print("Something went wrong. A word in a database cannot have a wordId null.");
        }
        WordDataService().deleteWord(setModel, word.wordId as String);

      } else {
        WordModel wordToUpdate = wordsToUpdate.firstWhere((element) => element.wordId == word.wordId);
        // Zkontrolovat, jsou-li data identická
        // Pokud ne, spustí se následující if statement
        if(word != wordToUpdate) {
          WordDataService().addWord(setModel, word);
        }
        wordsToUpdate.remove(wordToUpdate);
      }
    }

    for(WordModel newWord in wordsToUpdate) {
      WordDataService().addWord(setModel, newWord);
    }
  }

  // Výpis seznamu setů z databáze "sets" v kurzu, který
  // je v databázi "courses"
  Future<List<SetModel>> getSetsListFuture(courseId) async {
    List<SetModel> setsList = [];

    // print("Function getSetsListFuture() has started.");

    await coursesCollection
      .doc(courseId)
      .collection("sets")
      .get().then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {

          // print("Doc: ${doc.id}");
          // print(doc["title"]);
          
          setsList.add(SetModel(courseId, doc.id, doc["title"]));
      }
    });

    // print("Function getSetsListFuture() ended.");

    return setsList;
  }

  // Výpis názvu setu
  Future<String> getSetTitleFuture(SetModel? set) async {
    // print("SetId is: $setId");

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
    // print("CourseId: ${setModel.courseId}\tSetId: ${setModel.setId}");

    // print("Function getSetsListFuture() has started.");
    CollectionReference wordsCollection = coursesCollection
      .doc(setModel.courseId)
      .collection("sets")
      .doc(setModel.setId)
      .collection("words");

    await wordsCollection.get().then((QuerySnapshot querySnapshot) {
      numberOfWords = querySnapshot.docs.length;
      // print("Number of words in set ${setModel.title}: $numberOfWords");
    });
    
    return numberOfWords;
  }

  // Smazání setu
  Future<void> deleteSet(SetModel set) async {
    DocumentReference setDoc = coursesCollection
      .doc(set.courseId)
      .collection('sets')
      .doc(set.setId);
    
    await setDoc.delete();
  }

  // Smazání progressu setu z databáze "setProgress",
  Future<void> deleteSetProgress(setId, courseId, userId) async {
    SetModel set = SetModel(courseId, setId, null);
    DocumentReference setProgressDoc = FirebaseFirestore.instance
      .collection("users")
      .doc(userId)
      .collection("courseProgress")
      .doc(courseId)
      .collection("setProgress")
      .doc(setId);

    await setProgressDoc.delete();
  }
}