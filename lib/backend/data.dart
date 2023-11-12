// Import Firebase Auth
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:words_app_3/backend/auth.dart';
import 'package:words_app_3/backend/models.dart';

class DataService {
  Stream<QuerySnapshot> collectionStream = FirebaseFirestore.instance.collection("courses").snapshots();

  final FirebaseFirestore db = FirebaseFirestore.instance;

  CollectionReference coursesCollection = FirebaseFirestore.instance.collection("courses");
  CollectionReference usersCollection = FirebaseFirestore.instance.collection("users");

  // Future<List<Course>> getCourses() async {
  //   var ref = db.collection('courses');
  //   var snapshot = await ref.get();
  //   var data = snapshot.docs.map((s) => s.data());
  //   var courses = data.map((s) => Course.fromJson(s));
  //   return courses.toList();
  // }

  Future<UserModel> addUser(userId, firstName, lastName) async {

    UserModel user = UserModel(userId, firstName, lastName);

    usersCollection.add(user.userToMap()).then((DocumentReference doc) =>
      print('New user added.\nDocumentSnapshot added with ID: ${doc.id}'));
    
    return user;
  }

  // Future<CourseModel> addCourse(title) async {
  //   Future<CourseModel> course = (await CourseModel(AuthService().user?.uid, title)) as Future<CourseModel>;

  //   course.then((course) {
  //     db.collection("courses").add(course.courseToMap()).then((DocumentReference doc) =>
  //     print('New course added.\nDocumentSnapshot added with ID: ${doc.id}'));
  //   });
  //   return course;
  // }
  
  Future<CourseModel> addCourse(title) async {
    CourseModel course = CourseModel(AuthService().user?.uid, null, title);

    coursesCollection.add(course.courseToMap()).then((DocumentReference doc) =>
    print('New course added.\nDocumentSnapshot added with ID: ${doc.id}'));
    return course;
  }

  Future<SetModel> addSet(title, courseId) async {
    CollectionReference setsCollection = FirebaseFirestore.instance
      .collection("courses")
      .doc(courseId)
      .collection("sets");

    SetModel set = SetModel(null, title);

    setsCollection.add(set.setToMap()).then((DocumentReference doc) =>
    print('New set added.\nDocumentSnapshot added with ID: ${doc.id}'));
    return set;
  }

  Future<List<CourseModel>> getCoursesListFuture() async {
    List<CourseModel> coursesList = [];
    String? userId = AuthService().user?.uid;

    await coursesCollection.get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        if(doc["userId"] == userId) {
          print(doc["title"]);
          coursesList.add(CourseModel(userId, doc.id, doc["title"]));
        }
      });
    });

    return coursesList;
  }

  // Asi nebude potřeba
  // Smazat, až bude projekt dokončen
  List<CourseModel> getCoursesList() {
    List<CourseModel> coursesList = [];
    String? userId = AuthService().user?.uid;

    coursesCollection.get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        if(doc["userId"] == userId) {
          print(doc["title"]);
          coursesList.add(CourseModel(userId, doc.id, doc["title"]));
        }
      });
    });

    return coursesList;
  }

  // Future<List<CourseModel>> getCoursesList2() async {
    

  //   List<CourseModel> coursesList = [];
  //   String? userId = AuthService().user?.uid;

  //   coursesCollection.get().then((QuerySnapshot querySnapshot) {
  //     querySnapshot.docs.forEach((doc) {
  //       print(doc["title"]);
  //       if(doc["userId"] == userId) {
  //         coursesList.add(CourseModel(userId, doc["title"]));
  //       }
  //     });
  //   });

  //   return coursesList;
  // }
}