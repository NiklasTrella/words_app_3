// Tento soubor obsahuje funkce pro přihlašování a autentikaci uživatelů v databázi Firebase Authentication

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:words_app_3/backend/data/users_database/user_data.dart';

// Třída s metodami pro přihlašování
class AuthService {
  
  // Stream změn v přihlášení
  final userStream = FirebaseAuth.instance.authStateChanges();

  final User? user = FirebaseAuth.instance.currentUser;
  final FirebaseAuth instance = FirebaseAuth.instance;

  // Připojení k Firebase
  final auth = FirebaseAuth.instance;

  // Vytvoření účtu pomocí emailu a hesla
  Future<String> signUp(email, password) async {
    UserCredential usercredential = await auth.createUserWithEmailAndPassword(email: email, password: password);
    print('A new user was created!');

    // Ověřovací email "reset password"
    resetPassword(email);
    String userId = usercredential.user?.uid ?? "";
    return userId;
  }
  
  // Přihlášení pomocí emailu a hesla
  Future<void> logIn(email, password) async {
    auth.signInWithEmailAndPassword(email: email, password: password);
    print('The user logged in!');
  }

  // Odhlášení
  Future<void> signOut() async {
    await auth.signOut();
    print('The Function signOut was called.');
  }

  // Získání id právě přihlášeného uživatele
  String? getUserId() {
    return user?.uid;
  }

  // Změna hesla
  Future<void> updatePassword(String newPassword) async {
    user?.updatePassword(newPassword);
    print("Password updated!");
  }

  // Resetování hesla
  Future<String?> resetPassword(String email) async {
    try {
      await instance.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      print(e);
      return e.message.toString();
    }
    return null;
  }

  // Smazání uživatele
  Future<void> deleteUser() async {
    await UserDataService().deleteUserData();
    await user?.delete();
  }
}