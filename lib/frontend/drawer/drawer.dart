// Tento soubor obsahuje "drawer" - hamburgerové menu, které se otevře po kliknutí na ikonu menu v levé horní části obrazovky.

import 'package:flutter/material.dart';

import 'package:words_app_3/backend/system/auth.dart';
import 'package:words_app_3/backend/data/users_database/user_data.dart';

import 'package:words_app_3/frontend/drawer/courses_list.dart';

// Drawer menu
class MainScreenDrawer extends StatefulWidget {
  final Function updateCurrentCourseId;
  
  const MainScreenDrawer(this.updateCurrentCourseId, {super.key});

  @override
  State<MainScreenDrawer> createState() => _MainScreenDrawerState();
}

class _MainScreenDrawerState extends State<MainScreenDrawer> {
  _MainScreenDrawerState();

  bool isTeacher = false;

  @override
  void initState() {
    
    // Identifikace, je-li uživatel učitelem
    UserDataService().isTeacher().then((value) {
      setState(() {
        isTeacher = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            scrollDirection: Axis.vertical,
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            // mainAxisAlignment: MainAxisAlignment.start,
            // mainAxisSize: MainAxisSize.min,
            children: [
              const DrawerHeader(
                child: Text('Menu')
              ),
                  
              // Seznam kurzů
              CoursesList(widget.updateCurrentCourseId),
              
              // Tlačítko na přidání kurzu
              Visibility(
                visible: isTeacher,
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text('Create a course'),
                  onPressed: () async {
                    await Navigator.pushNamed(context, '/create_course');
                  },
                ),
              ),
              const SizedBox(height: 10),
                  
              // Tlačítko na odhlášení z účtu
              ElevatedButton(
                child: const Text('Sign out'),
                onPressed: () {
                  AuthService().signOut();
                  setState(() {});
                },
              ),
            ],
          ),
        ),
      );
  }

  void parentSetState() {
    setState(() {});
  }
}