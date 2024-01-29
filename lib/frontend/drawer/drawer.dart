import 'package:flutter/material.dart';
import 'package:words_app_3/backend/system/auth.dart';
import 'package:words_app_3/backend/data/users_database/user_data.dart';
import 'package:words_app_3/frontend/drawer/courses_list.dart';

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
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const DrawerHeader(
                  child: Text('Menu')
                ),
                CoursesList(widget.updateCurrentCourseId),
                Visibility(
                  visible: isTeacher,
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('Create a course'),
                    onPressed: () async {
                      // DataService().addCourse()
                      await Navigator.pushNamed(context, '/create_course');
                      // setState(() async {
                      //   // future = await DataService().getCoursesList() as List<CourseModel>;
                      // });
                    },
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  child: const Text('Sign out'),
                  onPressed: () {
                    AuthService().signOut();
                    print("Sign out button pressed.");
                    setState(() {});
                  },
                ),
              ],
            ),
          ),
        ),
      );
  }

  void parentSetState() {
    setState(() {});
  }
}