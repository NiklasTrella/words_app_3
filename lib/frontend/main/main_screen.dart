// Toto je hlavní stránka, která se uživateli zobrazí, je-li přihlášen
import 'package:flutter/material.dart';

import 'package:words_app_3/backend/data/users_database/user_data.dart';

import 'package:words_app_3/frontend/drawer/drawer.dart';
import 'package:words_app_3/frontend/main_pages/overview/overview.dart';
import 'package:words_app_3/frontend/main_pages/profile.dart';
import 'package:words_app_3/frontend/main_pages/student_manager/student_manager.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // Aktuální stránka
  int currentPageIndex = 0;

  // Id aktuálního kurzu
  String? currentCourseId;

  bool isAuthor = false;
  bool isTeacher = false;

  // Základní nastavení
  @override
  void initState() {

    // Kontrola, je-li uživatel učitelem
    UserDataService().isTeacher().then(
      (value) => setState(() {
        isTeacher = value;
      }
    ));

    super.initState();
  }

  // Hlavní stránka
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      // Hamburgerové rozbalovací menu
      drawer: MainScreenDrawer(updateCurrentCourseId),
      
      // Nadpis
      appBar: AppBar(
        title: const Text('WordsApp 3'),
      ),
      
      // Stránky
      body: [
        
        // Domovská stránka pro zobrazení kurzu
        OverviewScreen(currentCourseId, isAuthor),
        
        // Stránka, na které učitel přidává do kurzu další uživatele. Zobrazí se pouze v případě, že je uživatel učitelem
        Visibility(
          visible: isTeacher,
          child: StudentManagerScreen(currentCourseId)
        ),

        // Stránka s osobními údaji a nastavením profilu
        const ProfileScreen()


      ][currentPageIndex],
      
      // Navigační menu dole
      bottomNavigationBar: NavigationBar(

        // Tlačítka na spodní navigačním panelu
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Overview',
          ),
          Visibility(
            visible: isTeacher,
            child: const NavigationDestination(
              icon: Icon(Icons.groups),
              label: 'Students',
            ),
          ),
          const NavigationDestination(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],

        // Aktuálně zvolená stránka
        selectedIndex: currentPageIndex,

        // Změna při výběru stránky
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
      ),
    );
  }

  // Následující funkce aktualizuje id aktuálního kurzu
  void updateCurrentCourseId(String value, bool authorChange) {
    setState(() {
      currentCourseId = value;
      isAuthor = authorChange;
    });
    return;
  }
}