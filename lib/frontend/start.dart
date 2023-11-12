import 'package:flutter/material.dart';
import 'package:words_app_3/backend/auth.dart';
import 'package:words_app_3/frontend/main_screen.dart';
import 'authentication/authentication.dart';

// První stránka
class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AuthService().userStream,
      builder: (context, snapshot) {
        // Načítání
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Text('Start Loading.'),
          );

        // Error
        } else if (snapshot.hasError) {
          return const Center(
            child: Text('Error.')
          );
        
        // Jestliže se přihlášení podařilo
        } else if (snapshot.hasData) {
          print("User sent to MainScreen.");
          return MainScreen();
        
        // Není-li uživatel přihlášen
        } else {
          print("User sent to AuthScreen.");
          return AuthScreen();
        }
      },
    );
  }
}