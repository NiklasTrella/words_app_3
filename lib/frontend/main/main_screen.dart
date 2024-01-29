// Import knihoven
// Základní knihovna pro Flutter
import 'package:flutter/material.dart';
import 'package:words_app_3/backend/data/users_database/user_data.dart';

// Import widgetu Drawer (hamburgerové menu)
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
  // Aktuální kurz
  String? currentCourseId;
  bool isAuthor = false;
  bool isTeacher = false;

  @override
  void initState() {
    UserDataService().isTeacher().then((value) => setState(() {
      isTeacher = value;
    },));
    super.initState();
  }

  // Hlavní stránka
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Hamburger menu
      drawer: MainScreenDrawer(updateCurrentCourseId),
      // Nadpis
      appBar: AppBar(
        title: const Text('WordsApp 3'),
      ),
      // Stránky
      body: [
        // Domovská stránka pro zobrazení kurzu
        OverviewScreen(currentCourseId, isAuthor),
        Visibility(
          visible: isTeacher,
          child: StudentManagerScreen(currentCourseId)
        ),
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
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
      ),
    );
  }

  void updateCurrentCourseId(String value, bool authorChange) {
    print(value);
    setState(() {
      currentCourseId = value;
      isAuthor = authorChange;
    });
    return;
  }
}