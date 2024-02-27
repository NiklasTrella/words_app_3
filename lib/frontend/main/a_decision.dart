// Tento soubor zkontroluje, je-li uživatel přihlášen. Po přihlášení uživatele odešle na stránku "MainScreen". V opačném případě jej odešlě na stránku "Authentication".

import 'package:flutter/material.dart';

import 'package:words_app_3/backend/system/auth.dart';

import 'package:words_app_3/frontend/main/main_screen.dart';
import 'package:words_app_3/frontend/authentication/authentication.dart';

// První stránka, na které proběhne rozhodnutí a odeslání uživatele na další stránku
class DecisionScreen extends StatelessWidget {
  const DecisionScreen({super.key});

  @override
  Widget build(BuildContext context) {

    // Následující stream ("proud") kontroluje, je-li aktuálně přihlášen nějaký uživatel
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
        
        // Jestliže se přihlášení podařilo → hlavní stránka
        } else if (snapshot.hasData) {
          return const MainScreen();
        
        // Není-li uživatel přihlášen → stránka autentizace
        } else {
          return AuthScreen();
        }
      },
    );
  }
}