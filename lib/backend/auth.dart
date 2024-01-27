// Import Firebase Auth
// ignore_for_file: avoid_print

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';

// Třída s metodami pro přihlašování
// https://firebase.google.com/docs/auth/flutter/start
class AuthService {
  // Stream změn v přihlášení
  final userStream = FirebaseAuth.instance.authStateChanges();

  // Some Firebase documentation recommendation
  StreamSubscription<User?> userStream2 = FirebaseAuth.instance
    .authStateChanges()
    .listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });

  final User? user = FirebaseAuth.instance.currentUser;
  final FirebaseAuth instance = FirebaseAuth.instance;

  // Připojení k Firebase
  final auth = FirebaseAuth.instance;

  // Vytvoření účtu pomocí emailu a hesla
  Future<String> signUp(email, password) async {
    UserCredential usercredential = await auth.createUserWithEmailAndPassword(email: email, password: password);
    print('A new user was created!');

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
}