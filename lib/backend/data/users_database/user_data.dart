// Tento soubor obsahuje funkce pro manipulaci s daty aktuálního uživatele v databázi Firebase.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:words_app_3/backend/data/main_database/course_data.dart';
import 'package:words_app_3/backend/data/system_data.dart';
import 'package:words_app_3/backend/data/users_database/student_data.dart';
import 'package:words_app_3/backend/system/auth.dart';
import 'package:words_app_3/backend/system/models.dart';

class UserDataService {
  // Odkaz na databázi
  final FirebaseFirestore db = FirebaseFirestore.instance;

  // Odkazy na kolekce
  CollectionReference coursesCollection = FirebaseFirestore.instance.collection("courses");
  CollectionReference usersCollection = FirebaseFirestore.instance.collection("users");

  // Zápis uživatele do databáze "users"
  Future<UserModel> addUser(String userId, String firstName, String lastName, bool isTeacher, email) async {

    UserModel user = UserModel.withEmail(userId, firstName, lastName, isTeacher, email);
    DocumentReference document = usersCollection.doc(userId);

    await document.set(user.userToMap());
    
    return user;
  }

  // Aktualizace jména uživatele
  Future<void> updateUserName(String firstName, String lastName) async {
    User? user = AuthService().user;
    DocumentReference document = usersCollection.doc(user?.uid);
    await document.update({
      "firstName": firstName,
      "lastName": lastName
    });
  }
  
  // Získání statusu učitele
  Future<void> becomeTeacher() async {
    User? user = AuthService().user;
    DocumentReference document = usersCollection.doc(user?.uid);
    await document.update({
      "isTeacher": true
    });
  }

  // Kontrola statusu učitele
  Future<bool> isTeacher() async {
    User? user = AuthService().user;
    DocumentReference document = usersCollection.doc(user?.uid);
    DocumentSnapshot documentSnapshot = await document.get();
    Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
    return data["isTeacher"];
  }

  // Získání dat aktuálně přihlášeného uživatele
  Future<UserModel> getCurrentUserData() async {

    User? user = AuthService().user;
    
    DocumentReference document = usersCollection.doc(user?.uid);
    UserModel userData = UserModel(null, null, null, null);

    await document.get().then((DocumentSnapshot documentSnapshot) {
      Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
      userData = UserModel.withEmail(user?.uid, data["firstName"], data["lastName"], data["isTeacher"], user?.email);
    });

    return userData;
  }

  // Smazání dat uživatele z databáze "users"
  Future<void> deleteUserData() async {
    String? userId = AuthService().getUserId();
    DocumentReference documentReference = usersCollection.doc(userId);
    SystemDataService().deleteDocumentAndContents(documentReference, "users");

    List<CourseModel> courses = [];
    courses = await CourseDataService().getStudiedCourses();

    for(CourseModel course in courses) {
      StudentDataService().removeStudent(course.courseId!, userId!);
    }
  }

  // Kontrola existence uživatele
  Future<bool> checkUserExistence(String email) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection("users")
      .where("email", isEqualTo: email)
      .limit(1)
      .get();

    return querySnapshot.docs.isNotEmpty;
  }
}