// Tento soubor obsahuje funkce pro manipulaci s daty kurzů v databázi Firebase

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:words_app_3/backend/data/system_data.dart';
import 'package:words_app_3/backend/system/auth.dart';
import 'package:words_app_3/backend/data/users_database/progress_data.dart';
import 'package:words_app_3/backend/data/users_database/student_data.dart';
import 'package:words_app_3/backend/system/models.dart';

class CourseDataService {
  // Odkaz na databázi
  final FirebaseFirestore db = FirebaseFirestore.instance;

  // Odkazy na kolekce
  CollectionReference coursesCollection = FirebaseFirestore.instance.collection("courses");
  CollectionReference usersCollection = FirebaseFirestore.instance.collection("users");

  // Zápis kurzu do databáze "courses"
  Future<CourseModel> addCourse(title, courseId) async {
    CourseModel course = CourseModel(AuthService().user?.uid, null, title);

    if(courseId == null) {
      coursesCollection.add(course.courseToMap()).then((DocumentReference doc) {
      // ignore: avoid_print
      print('New course added.\nDocumentSnapshot added with ID: ${doc.id}');
    });
    } else {
      coursesCollection.doc(courseId).update(course.courseToMap());
    }

    return course;
  }

  // Výpis seznamu vlastních kurzů z databáze "courses"
  Future<List<CourseModel>> getOwnCourses() async {
    List<CourseModel> coursesList = [];
    String? userId = AuthService().user?.uid;

    await coursesCollection.get().then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if(doc["userId"] == userId) {
          // print(doc["title"]);
          coursesList.add(CourseModel.withAutorship(userId, doc.id, doc["title"], true));
        }
      }
    });

    return coursesList;
  }

  // Výpis seznamu studovaných kurzů z databáze "courses"
  Future<List<CourseModel>> getStudiedCourses() async {
    List<CourseModel> coursesList = [];
    String? userId = AuthService().getUserId();

    await coursesCollection.get().then((QuerySnapshot querySnapshot) async {
      // Projít každý kurz, uložit studované
      for(QueryDocumentSnapshot doc in querySnapshot.docs) {
        CollectionReference studentsCollection = coursesCollection
          .doc(doc.id)
          .collection("students");
        
        QuerySnapshot studentQuerySnapshot = await studentsCollection.where(FieldPath.documentId, isEqualTo: userId).get();
        if(studentQuerySnapshot.docs.isNotEmpty) {
          coursesList.add(CourseModel.withAutorship(userId, doc.id, doc["title"], false));
        }
      }
    });

    return coursesList;
  }

  // Výpis názvu kurzu
  Future<String> getCourseTitleFuture(courseId) async {
    CourseModel? course;

    await coursesCollection.get().then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if(doc.id == courseId) {
          course = CourseModel(doc["userId"], doc.id, doc["title"]);
        }
      }
    });

    if (course == null) {
      return "Firstly choose a course.";
    } else if (course?.title == null) {
      return "No title.";
    } else {
      return course!.title ?? "No text";
    }
  }

  // Výpis počtu setů v kurzu
  Future<int> getSetsNumberFuture(courseId) async {
    int numberOfSets = 0;
    CollectionReference setsCollection = coursesCollection.doc(courseId).collection("sets");

    await setsCollection.get().then((QuerySnapshot querySnapshot) {
      numberOfSets = querySnapshot.docs.length;
    });

    return numberOfSets;
  }

  // Smazání kurzu
  Future<void> deleteCourse(String courseId) async {
    DocumentReference courseDoc = coursesCollection
      .doc(courseId);
    
    ProgressDataService().deleteStudentsCourseProgress(courseId, null);
    SystemDataService().deleteDocumentAndContents(courseDoc, "courses");
  }

  // Získání seznamu studentů
  Future<List<UserModel>> getStudentsList(String? courseId) async {
    List<UserModel> listOfStudents = [];
    CollectionReference studentsCollection = FirebaseFirestore.instance
      .collection("courses")
      .doc(courseId)
      .collection("students");

    List<String> listOfStudentIds = [];
    await studentsCollection.get().then((QuerySnapshot querySnapshot) {
      for(var doc in querySnapshot.docs) {
        listOfStudentIds.add(doc.id);
      }
    });

    for(String studentId in listOfStudentIds) {
      UserModel studentData = await StudentDataService().getUserData(studentId.toString());
      listOfStudents.add(studentData);
    }

    return listOfStudents;
  }

  // Přidání studentů
  Future<void> addStudents(String? courseId, List<UserModel> nonStudentsToAdd) async {
    CollectionReference studentsCollection = coursesCollection
      .doc(courseId)
      .collection("students");
    for(UserModel nonStudent in nonStudentsToAdd) {
      DocumentReference studentDoc = studentsCollection.doc(nonStudent.userId);
      await studentDoc.set(Map<String, dynamic>());
    }
  }

  // Kontrola, je-li uživatel autorem kurzu
  Future<bool> isAuthor(String? courseId) async {
    DocumentReference docRef = coursesCollection
      .doc(courseId);
    
    DocumentSnapshot docSnapshot = await docRef.get();
    Map<String, dynamic> docData = docSnapshot.data() as Map<String, dynamic>;

    String authorId = docData["userId"];
    String? currentUserId = AuthService().getUserId();

    return authorId == currentUserId;
  }
}