// Tento soubor

// import 'dart:convert';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:words_app_3/backend/auth.dart';
// import 'package:words_app_3/backend/data.dart';
// import 'package:words_app_3/backend/models.dart';

// Import knihoven
// Základní knihovna pro Flutter
import 'package:flutter/material.dart';

// Import widgetu Drawer (hamburgerové menu)
import 'package:words_app_3/frontend/shared/drawer.dart';
import 'package:words_app_3/frontend/main_pages/overview.dart';
import 'package:words_app_3/frontend/main_pages/profile.dart';
import 'package:words_app_3/frontend/main_pages/review.dart';

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
        OverviewScreen(updateCurrentCourseId, currentCourseId),
        const ReviewScreen(),
        const ProfileScreen()
      ][currentPageIndex],
      // Navigační menu dole
      bottomNavigationBar: NavigationBar(
        // Tlačítka na spodní navigačním panelu
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Overview',
          ),
          NavigationDestination(
            icon: Icon(Icons.collections),
            label: 'Review',
          ),
          NavigationDestination(
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

  void updateCurrentCourseId(String value) {
    print(value);
    setState(() {
      currentCourseId = value;
    });
    return;
  }
}