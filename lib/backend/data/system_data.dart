// Tento soubor obsahuje 2 typy funkcí:
// 1. Pro kontoroly bezpečnostních kódů v databázi Firebase
// 2. Pro mazání dokumentu a veškerého obsahu pod tímto souborem

import 'package:cloud_firestore/cloud_firestore.dart';

// Třída s funkcemi pro kontrolu bezpečnostních kódů
class SystemDataService {
  CollectionReference system = FirebaseFirestore.instance.collection("system");

  // Kontrola kódu pro získání statusu učitele
  Future<bool> checkTeacherCode(String codeToCheck) async {
    DocumentReference teacherCodeReference = system.doc("teacher_code");
    String correctCode;

    DocumentSnapshot documentSnapshot = await teacherCodeReference.get();
    Map<String, dynamic> documentData = documentSnapshot.data() as Map<String, dynamic>;
    correctCode = documentData["code"];

    return codeToCheck == correctCode;
  }
  
  // Kontrola kódu pro smazání účtu
  Future<bool> checkDeleteCode(String codeToCheck) async {
    DocumentReference deleteCodeReference = system.doc("delete_code");
    String correctCode;

    DocumentSnapshot documentSnapshot = await deleteCodeReference.get();
    Map<String, dynamic> documentData = documentSnapshot.data() as Map<String, dynamic>;
    correctCode = documentData["code"];

    return codeToCheck == correctCode;
  }

  // Smazání dokumentu a celého jeho obsahu v databázi Firebase
  Future<void> deleteDocumentAndContents(DocumentReference documentReference, String parentCollection) async {    
    
    // Mazání progressu
    if(parentCollection == "wordProgress") {
      documentReference.delete();
    } else if (parentCollection == "setProgress") {
      CollectionReference collectionReference = documentReference.collection("wordProgress");
      QuerySnapshot querySnapshot = await collectionReference.get();
      querySnapshot.docs.forEach((element) {
        deleteDocumentAndContents(collectionReference.doc(element.id), "wordProgress");
      });
    } else if (parentCollection == "courseProgress") {
      CollectionReference collectionReference = documentReference.collection("setProgress");
      QuerySnapshot querySnapshot= await collectionReference.get();
      querySnapshot.docs.forEach((element) {
        deleteDocumentAndContents(collectionReference.doc(element.id), "setProgress");
      });
    } else if (parentCollection == "users") {
      CollectionReference collectionReference = documentReference.collection("courseProgress");
      QuerySnapshot querySnapshot = await collectionReference.get();
      querySnapshot.docs.forEach((element) {
        deleteDocumentAndContents(collectionReference.doc(element.id), "courseProgress");
      });
      documentReference.delete();
    }

    // Mazání kurzů, setů a slov
    else if (parentCollection == "words") {
      documentReference.delete();
    } else if (parentCollection == "sets") {
      CollectionReference collectionReference = documentReference.collection("words");
      QuerySnapshot querySnapshot = await collectionReference.get();
      querySnapshot.docs.forEach((element) {
        deleteDocumentAndContents(collectionReference.doc(element.id), "words");
      });
    } else if (parentCollection == "courses") {
      CollectionReference collectionReference = documentReference.collection("sets");
      QuerySnapshot querySnapshot = await collectionReference.get();
      querySnapshot.docs.forEach((element) {
        deleteDocumentAndContents(collectionReference.doc(element.id), "sets");
      });
    }
  }
}