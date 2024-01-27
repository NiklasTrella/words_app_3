import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:words_app_3/backend/auth.dart';
import 'package:words_app_3/backend/models.dart';

class UserDataService {
  // Odkaz na databázi
  final FirebaseFirestore db = FirebaseFirestore.instance;

  // Odkazy na kolekce
  CollectionReference coursesCollection = FirebaseFirestore.instance.collection("courses");
  CollectionReference usersCollection = FirebaseFirestore.instance.collection("users");

  // Zápis uživatele do databáze "users"
  Future<UserModel> addUser(String userId, String firstName, String lastName, bool isTeacher) async {

    UserModel user = UserModel(userId, firstName, lastName, isTeacher);
    DocumentReference document = usersCollection.doc(userId);

    await document.set(user.userToMap());

    // usersCollection.add(user.userToMap()).then((DocumentReference doc) {
    //   // ignore: avoid_print
    //   print('New user added.\nDocumentSnapshot added with ID: ${doc.id}');
    // });
    
    return user;
  }

  Future<void> updateUserName(String firstName, String lastName) async {
    User? user = AuthService().user;
    DocumentReference document = usersCollection.doc(user?.uid);
    await document.update({
      "firstName": firstName,
      "lastName": lastName
    });
  }

  Future<void> updatePassword(String newPassword) async {
    User? user = AuthService().user;
    user?.updatePassword(newPassword);
    print("Password updated!");
  }

  Future<String?> resetPassword(String email) async {
    FirebaseAuth instance = AuthService().instance;
    try {
      await instance.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      print(e);
      return e.message.toString();
    }
    return null;
  }
  
  Future<void> becomeTeacher() async {
    User? user = AuthService().user;
    DocumentReference document = usersCollection.doc(user?.uid);
    await document.update({
      "isTeacher": true
    });
  }

  Future<bool> isTeacher() async {
    User? user = AuthService().user;
    DocumentReference document = usersCollection.doc(user?.uid);
    DocumentSnapshot documentSnapshot = await document.get();
    Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
    return data["isTeacher"];
  }

  Future<UserModel> getUserData() async {

    User? user = AuthService().user;
    
    DocumentReference document = usersCollection.doc(user?.uid);
    UserModel userData = UserModel(null, null, null, null);

    await document.get().then((DocumentSnapshot documentSnapshot) {
      Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
      userData = UserModel.withEmail(user?.uid, data["firstName"], data["lastName"], data["isTeacher"], user?.email);
    });

    return userData;
  }
}