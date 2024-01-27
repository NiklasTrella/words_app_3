import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:words_app_3/backend/auth.dart';
import 'package:words_app_3/backend/models.dart';

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
      addCourseProgress(doc.id, AuthService().user?.uid);
    });
    } else {
      coursesCollection.doc(courseId).update(course.courseToMap());
    }

    return course;
  }

  // Zápis progressu kurzu do databáze "courseProgress"
  Future<CourseModel> addCourseProgress(courseId, userId) async {
    CourseModel course = CourseModel(AuthService().user?.uid, courseId, null);
    CollectionReference courseProgress = FirebaseFirestore.instance
      .collection("users")
      .doc(userId)
      .collection("courseProgress");

      courseProgress.add(course.courseProgressToMap()).then((DocumentReference doc) {
      print('New courseProgress added.\nDocumentSnapshot added with ID: ${doc.id}');
    });
    return course;
  }

  // Výpis seznamu kurzů z databáze "courses"
  Future<List<CourseModel>> getCoursesListFuture() async {
    List<CourseModel> coursesList = [];
    String? userId = AuthService().user?.uid;

    await coursesCollection.get().then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if(doc["userId"] == userId) {
          // print(doc["title"]);
          coursesList.add(CourseModel(userId, doc.id, doc["title"]));
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
          // print(course?.courseToMap().toString());
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
    
    await courseDoc.delete();
  }

  // Smazání progressu kurzu z databáze "courseProgress"
  Future<void> deleteCourseProgress(courseId, userId) async {
    CourseModel course = CourseModel(AuthService().user?.uid, courseId, null);
    DocumentReference courseProgressDoc = FirebaseFirestore.instance
      .collection("users")
      .doc(userId)
      .collection("courseProgress")
      .doc(courseId);
    
    courseProgressDoc.delete();
  }
}