import 'package:cloud_firestore/cloud_firestore.dart';

class SystemDataService {
  CollectionReference system = FirebaseFirestore.instance.collection("system");

  Future<bool> checkTeacherCode(String codeToCheck) async {
    DocumentReference teacherCodeReference = system.doc("teacher_code");
    String correctCode;

    DocumentSnapshot documentSnapshot = await teacherCodeReference.get();
    Map<String, dynamic> documentData = documentSnapshot.data() as Map<String, dynamic>;
    correctCode = documentData["code"];

    return codeToCheck == correctCode;
  }
  
  Future<bool> checkDeleteCode(String codeToCheck) async {
    DocumentReference deleteCodeReference = system.doc("delete_code");
    String correctCode;

    DocumentSnapshot documentSnapshot = await deleteCodeReference.get();
    Map<String, dynamic> documentData = documentSnapshot.data() as Map<String, dynamic>;
    correctCode = documentData["code"];

    return codeToCheck == correctCode;
  }
}