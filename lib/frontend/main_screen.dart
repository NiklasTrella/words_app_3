import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:words_app_3/backend/auth.dart';
import 'package:words_app_3/backend/data.dart';
import 'package:words_app_3/backend/models.dart';
import 'package:words_app_3/frontend/drawer/drawer.dart';
import 'package:words_app_3/frontend/overview/overview.dart';
import 'package:words_app_3/frontend/profile/profile.dart';
import 'package:words_app_3/frontend/review/review.dart';

class MainScreen extends StatefulWidget {
  MainScreen({super.key});

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
        title: Text('HomeScreen'),
      ),
      // Stránky
      body: [
        // Domovská stránka pro zobrazení kurzu
        OverviewScreen(currentCourseId),
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