import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:words_app_3/backend/system/auth.dart';
import 'package:words_app_3/backend/system/models.dart';

class StudentDataService {
  // Odkaz na databázi
  final FirebaseFirestore db = FirebaseFirestore.instance;

  // Odkazy na kolekce
  CollectionReference coursesCollection = FirebaseFirestore.instance.collection("courses");
  CollectionReference usersCollection = FirebaseFirestore.instance.collection("users");

  Future<UserModel> getUserData(String userId) async {
    print("GetUserData() function started");
    print("UserId: $userId");
    DocumentReference ref = usersCollection
      .doc(userId);
    DocumentSnapshot snap = await ref.get();
    Map<String, dynamic> data = snap.data() as Map<String, dynamic>;

    UserModel userData = UserModel.withEmail(userId, data["firstName"], data["lastName"], data["isTeacher"], data["email"]);
    print("User ${userData.firstName} ${userData.lastName}");
    return userData;
  }

  Future<List<UserModel>> getAllNonStudents(String? courseId) async {
    // Odkaz na kurz
    CollectionReference studentsCollection = FirebaseFirestore.instance
      .collection("courses")
      .doc(courseId)
      .collection("students");
    
    // Seznam id studentů
    List<dynamic> listOfStudentIds = [];
    
    await studentsCollection.get().then((QuerySnapshot querySnapshot) {
      for(var doc in querySnapshot.docs) {
        listOfStudentIds.add(doc.id);
      }
    });

    // Seznam uživatelů, kteří nejsou studenty kurzu
    List<String> listOfNonStudentIds = [];
    // Získání všech uživatelů
    await usersCollection.get().then((QuerySnapshot querySnapshot) {
      // Není-li uživatel studentem kurzu → přidání do seznamu
      for(var doc in querySnapshot.docs) {
        if(!listOfStudentIds.contains(doc.id)) {
          listOfNonStudentIds.add(doc.id);
          print(listOfNonStudentIds);
        }
      }
    });

    listOfNonStudentIds.remove(AuthService().user?.uid);

    List<UserModel> listOfNonStudents = [];

    for(String nonStudentId in listOfNonStudentIds) {
      UserModel studentData = await StudentDataService().getUserData(nonStudentId.toString());
      listOfNonStudents.add(studentData);
    }
    return listOfNonStudents;
  }

  Future<void> removeStudent(String courseId, String userId) async {
    DocumentReference userToDelete = coursesCollection
      .doc(courseId)
      .collection("students")
      .doc(userId);
    
    await userToDelete.delete();
  }
}