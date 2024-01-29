// Tento soubor zkontroluje, je-li uživatel přihlášen.
// V opačném případě jej odešlě na stránku
// "Authentication". Po přihlášení uživatele odešle na
// stránku "MainScreen".

// Import knihoven
// Import základní knihovny pro Flutter
import 'package:flutter/material.dart';

// Import souboru, který zprostředkovává authentikaci přes
// Firebase
import 'package:words_app_3/backend/system/auth.dart';

// Odkaz na stránku "MainScreen"
import 'main_screen.dart';

// Odkaz na stránku "AuthScreen"
import '../authentication/authentication.dart';

// První stránka
class DecisionScreen extends StatelessWidget {
  const DecisionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AuthService().userStream,
      builder: (context, snapshot) {

        // Načítání
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Column(
              children: [
                CircularProgressIndicator(),
                Text('Loading data.'),
              ],
            ),
          );

        // Error
        } else if (snapshot.hasError) {
          return const Center(
            child: Text('Error.')
          );
        
        // Jestliže se přihlášení podařilo
        } else if (snapshot.hasData) {
          // print("User sent to MainScreen.");
          return const MainScreen();
        
        // Není-li uživatel přihlášen
        } else {
          // print("User sent to AuthScreen.");
          return AuthScreen();
        }
      },
    );
  }
}