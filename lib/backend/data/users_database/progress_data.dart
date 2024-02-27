// Tento soubor obsahuje funkce pro manipulaci s daty postupu v databázi Firebase

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:words_app_3/backend/data/main_database/course_data.dart';
import 'package:words_app_3/backend/data/main_database/set_data.dart';
import 'package:words_app_3/backend/data/main_database/word_data.dart';
import 'package:words_app_3/backend/data/system_data.dart';
import 'package:words_app_3/backend/system/auth.dart';
import 'package:words_app_3/backend/system/models.dart';

class ProgressDataService {
  
  // Zápis postupu v kurzu
  Future<CourseModel> addCourseProgress(String? courseId, String? userId) async {
    CourseModel course = CourseModel(AuthService().user?.uid, courseId, null);
    CollectionReference courseProgress = FirebaseFirestore.instance
      .collection("users")
      .doc(userId)
      .collection("courseProgress");

    courseProgress.doc(courseId).set(Map<String, dynamic>()).then((value) {
    });

    return course;
  }

  // Zápis postupu v setu
  Future<SetModel> addSetProgress(String? setId, String? courseId, String? userId) async {
    SetModel set = SetModel(courseId, setId, null);
    CollectionReference setProgress = FirebaseFirestore.instance
      .collection("users")
      .doc(userId)
      .collection("courseProgress")
      .doc(courseId)
      .collection("setProgress");

    setProgress.doc(setId).set(Map<String, dynamic>()).then((value) {
    });

    return set;
  }

  // Zápis postupu ve slově
  Future<WordModel> addWordProgress(int? memory, String wordId, String? setId, String? courseId, String? userId) async {
    WordModel word = WordModel(wordId, null, null);
    CollectionReference wordProgress = FirebaseFirestore.instance
      .collection("users")
      .doc(userId)
      .collection("courseProgress")
      .doc(courseId)
      .collection("setProgress")
      .doc(setId)
      .collection("wordProgress");

    wordProgress.doc(wordId).set(word.wordProgressToMap());
    
    return word;
  }

  // Zápis několika postupů
  Future<void> addStudentsProgress(String? courseId, List<UserModel> students) async {
    addStudentsCourseProgress(courseId, students);
    List<SetModel> setsInCourse = await SetDataService().getSetsList(courseId);
    for(SetModel set in setsInCourse) {
      addStudentsSetProgress(set.setId, courseId, students);
      List<WordModel> wordsInSet = await WordDataService().getWordsList(set);
      for(WordModel word in wordsInSet) {
        if(word.wordId != null) {
          addStudentsWordProgress(word.wordId!, set.setId, courseId, students);
        }
      }
    }
  }

  // Zápis několika postupů v kurzu
  Future<void> addStudentsCourseProgress(String? courseId, List<UserModel> students) async {
    for(UserModel student in students) {
      addCourseProgress(courseId, student.userId);
    }
  }

  // Zápis několika postupů v setu
  Future<void> addStudentsSetProgress(String? setId, String? courseId, List<UserModel>? students) async {
    students ??= await CourseDataService().getStudentsList(courseId);
    for(UserModel student in students) {
      addSetProgress(setId, courseId, student.userId);
    }  
  }

  // Zápis několika postupů ve slově
  Future<void> addStudentsWordProgress(String wordId, String? setId, String? courseId, List<UserModel>? students) async {
    int memory = 0;
    students ??= await CourseDataService().getStudentsList(courseId);
    for(UserModel student in students) {
      addWordProgress(memory, wordId, setId, courseId, student.userId);
    }
  }

  // Mazání postupu v kurzu
  Future<void> deleteCourseProgress(String? courseId, String? userId) async {
    DocumentReference courseProgressDoc = FirebaseFirestore.instance
      .collection("users")
      .doc(userId)
      .collection("courseProgress")
      .doc(courseId);
    
    SystemDataService().deleteDocumentAndContents(courseProgressDoc, "courseProgress");
  }

  // Mazání postupu v setu
  Future<void> deleteSetProgress(String? setId, String? courseId, String? userId) async {
    DocumentReference setProgressDoc = FirebaseFirestore.instance
      .collection("users")
      .doc(userId)
      .collection("courseProgress")
      .doc(courseId)
      .collection("setProgress")
      .doc(setId);

    SystemDataService().deleteDocumentAndContents(setProgressDoc, "setProgress");
  }

  // Mazání postupu ve slově
  Future<WordModel> deleteWordProgress(String? wordId, String? setId, String? courseId, String? userId) async {
    WordModel word = WordModel(wordId, null, null);
    DocumentReference wordProgressDoc = FirebaseFirestore.instance
      .collection("users")
      .doc(userId)
      .collection("courseProgress")
      .doc(courseId)
      .collection("setProgress")
      .doc(setId)
      .collection("wordProgress")
      .doc(wordId);

    SystemDataService().deleteDocumentAndContents(wordProgressDoc, "wordProgress");
    
    return word;
  }

  // Mazání několika postupů v kurzu
  Future<void> deleteStudentsCourseProgress(String? courseId, List<UserModel>? students) async {
    students ??= await CourseDataService().getStudentsList(courseId);
    for(UserModel student in students) {
      deleteCourseProgress(courseId, student.userId);
    }
  }

  // Mazání několika postupů v setu
  Future<void> deleteStudentsSetProgress(String? setId, String? courseId, List<UserModel>? students) async {
    students ??= await CourseDataService().getStudentsList(courseId);
    for(UserModel student in students) {
      deleteSetProgress(setId, courseId, student.userId);
    }
  }

  // Mazání několika postupů ve slově
  Future<void> deleteStudentsWordProgress(String? wordId, String? setId, String? courseId, List<UserModel>? students) async {
    students ??= await CourseDataService().getStudentsList(courseId);
    for(UserModel student in students) {
      deleteWordProgress(wordId, setId, courseId, student.userId);
    }
  }

  // Změna jednoho progressu
  Future<void> updateSelfWordsProgress(Map<String, List<int>> wordProgressData, String? setId, String? courseId) async {
    String? selfUserId = AuthService().getUserId();
    
    CollectionReference wordProgress = FirebaseFirestore.instance
      .collection("users")
      .doc(selfUserId)
      .collection("courseProgress")
      .doc(courseId)
      .collection("setProgress")
      .doc(setId)
      .collection("wordProgress");
    
    wordProgressData.forEach((key, value) async {
      WordModel word = WordModel.withMemory(key, null, null, value[0], value[1]);
      DocumentSnapshot wordProgressDoc = await wordProgress.doc(key).get();

      if(wordProgressDoc["memory1"] > word.memory1) {
        word.memory1 = wordProgressDoc["memory1"];
      }
      if(wordProgressDoc["memory2"] > word.memory2) {
        word.memory2 = wordProgressDoc["memory2"];
      }
      wordProgress.doc(key).set(word.wordProgressToMap());
    });
  }

  // Výpis postupu studenta v setu
  Future<List<WordModel>> getProgress(UserModel student, SetModel set) async {
    CollectionReference wordProgressCollection = FirebaseFirestore.instance
      .collection("users")
      .doc(student.userId)
      .collection("courseProgress")
      .doc(set.courseId)
      .collection("setProgress")
      .doc(set.setId)
      .collection("wordProgress");
    
    List<WordModel> words = [];
    
    await wordProgressCollection.get().then((QuerySnapshot querySnapshot) {
      for(QueryDocumentSnapshot doc in querySnapshot.docs) {
        words.add(WordModel.withMemory(doc.id, null, null, doc["memory1"] ?? 0, doc["memory2"] ?? 0));
      }
    });

    return words;
  }

  // Výpis progressů studentů v setu
  Future<Map<UserModel, List<WordModel>>> getStudentProgress(List<UserModel> students, SetModel set) async {
    Map<UserModel, List<WordModel>> result = {};

    for(UserModel student in students) {
      result.addAll({
        student: await getProgress(student, set)
      });
    }
    
    return result;
  }
}