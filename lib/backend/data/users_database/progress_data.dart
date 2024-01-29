import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:words_app_3/backend/data/main_database/course_data.dart';
import 'package:words_app_3/backend/data/main_database/set_data.dart';
import 'package:words_app_3/backend/data/main_database/word_data.dart';
import 'package:words_app_3/backend/system/auth.dart';
import 'package:words_app_3/backend/system/models.dart';

class ProgressDataService {
  // Zápis jednoho progressu
  Future<CourseModel> addCourseProgress(String? courseId, String? userId) async {
    CourseModel course = CourseModel(AuthService().user?.uid, courseId, null);
    CollectionReference courseProgress = FirebaseFirestore.instance
      .collection("users")
      .doc(userId)
      .collection("courseProgress");

    courseProgress.doc(courseId).set(Map<String, dynamic>()).then((value) {
      print("Successfully added courseProgress.");
    });

    return course;
  }

  Future<SetModel> addSetProgress(String? setId, String? courseId, String? userId) async {
    SetModel set = SetModel(courseId, setId, null);
    CollectionReference setProgress = FirebaseFirestore.instance
      .collection("users")
      .doc(userId)
      .collection("courseProgress")
      .doc(courseId)
      .collection("setProgress");

    setProgress.doc(setId).set(Map<String, dynamic>()).then((value) {
      print("Successfully added setProgress.");
    });

    return set;
  }

  Future<WordModel> addWordProgress(int? memory, String? wordId, String? setId, String? courseId, String? userId) async {
    WordModel word = WordModel(wordId, null, null);
    CollectionReference wordProgress = FirebaseFirestore.instance
      .collection("users")
      .doc(userId)
      .collection("courseProgress")
      .doc(courseId)
      .collection("setProgress")
      .doc(setId)
      .collection("wordProgress");

    wordProgress.doc(wordId).set(word.wordProgressToMap()).then((value) {
      print('Successfully added wordProgress');
    });
    
    return word;
  }

  // Zápis několika progressů
  Future<void> addStudentsProgress(String? courseId, List<UserModel> students) async {
    addStudentsCourseProgress(courseId, students);
    List<SetModel> setsInCourse = await SetDataService().getSetsList(courseId);
    for(SetModel set in setsInCourse) {
      addStudentsSetProgress(set.setId, courseId, students);
      List<WordModel> wordsInSet = await WordDataService().getWordsList(set);
      for(WordModel word in wordsInSet) {
        addStudentsWordProgress(word.wordId, set.setId, courseId, students);
      }
    }
  }

  Future<void> addStudentsCourseProgress(String? courseId, List<UserModel> students) async {
    for(UserModel student in students) {
      addCourseProgress(courseId, student.userId);
    }
  }

  Future<void> addStudentsSetProgress(String? setId, String? courseId, List<UserModel>? students) async {
    students ??= await CourseDataService().getStudentsList(courseId);
    for(UserModel student in students) {
      addSetProgress(setId, courseId, student.userId);
    }  
  }

  Future<void> addStudentsWordProgress(String? wordId, String? setId, String? courseId, List<UserModel>? students) async {
    int memory = 0;
    students ??= await CourseDataService().getStudentsList(courseId);
    for(UserModel student in students) {
      addWordProgress(memory, wordId, setId, courseId, student.userId);
    }
  }

  // Mazání jednoho progressu
  Future<void> deleteCourseProgress(String? courseId, String? userId) async {
    DocumentReference courseProgressDoc = FirebaseFirestore.instance
      .collection("users")
      .doc(userId)
      .collection("courseProgress")
      .doc(courseId);
    
    courseProgressDoc.delete();
  }

  Future<void> deleteSetProgress(String? setId, String? courseId, String? userId) async {
    DocumentReference setProgressDoc = FirebaseFirestore.instance
      .collection("users")
      .doc(userId)
      .collection("courseProgress")
      .doc(courseId)
      .collection("setProgress")
      .doc(setId);

    setProgressDoc.delete();
  }

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

    wordProgressDoc.delete();
    
    return word;
  }

  // Mazání několika progressů
  Future<void> deleteStudentsCourseProgress(String? courseId, List<UserModel>? students) async {
    students ??= await CourseDataService().getStudentsList(courseId);
    for(UserModel student in students) {
      deleteCourseProgress(courseId, student.userId);
    }
  }

  Future<void> deleteStudentsSetProgress(String? setId, String? courseId, List<UserModel>? students) async {
    students ??= await CourseDataService().getStudentsList(courseId);
    for(UserModel student in students) {
      deleteSetProgress(setId, courseId, student.userId);
    }
  }

  Future<void> deleteStudentsWordProgress(String? wordId, String? setId, String? courseId, List<UserModel>? students) async {
    students ??= await CourseDataService().getStudentsList(courseId);
    for(UserModel student in students) {
      deleteWordProgress(wordId, setId, courseId, student.userId);
    }
  }

  // Změna jednoho progressu
  Future<void> updateSelfWordsProgress(Map<String, int> wordProgressData, String? setId, String? courseId) async {
    String? selfUserId = AuthService().getUserId();
    
    CollectionReference wordProgress = FirebaseFirestore.instance
      .collection("users")
      .doc(selfUserId)
      .collection("courseProgress")
      .doc(courseId)
      .collection("setProgress")
      .doc(setId)
      .collection("wordProgress");
    
    wordProgressData.forEach((key, value) {
      WordModel word = WordModel.withMemory(key, null, null, value);
      wordProgress.doc(key).set(word.wordProgressToMap());
    });
  }

  // Výpis progressu studenta
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
        words.add(WordModel.withMemory(doc.id, null, null, doc["memory"] ?? 0));
        print("Doc.id: ${doc.id}\tmemory:${doc['memory'] ?? 0}");
      }
    });

    return words;
  }

  // Výpis progressů studentů
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