// Import Firebase Auth
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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

  final user = FirebaseAuth.instance.currentUser;

  // Připojení k Firebase
  final auth = FirebaseAuth.instance;

  // Vytvoření účtu pomocí emailu a hesla
  Future<void> signUp(email, password) async {
    auth.createUserWithEmailAndPassword(email: email, password: password);
    print('A new user was created!');
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