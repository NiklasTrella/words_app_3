import 'package:flutter/material.dart';
import 'package:words_app_3/backend/auth.dart';
import 'package:words_app_3/backend/data/course_data.dart';
import 'package:words_app_3/backend/data/user_data.dart';
import 'package:words_app_3/frontend/editors/course_editor.dart';

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
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const DrawerHeader(
                child: Text('Menu')
              ),

              // Seznam kurzů
              SingleChildScrollView(
                child: FutureBuilder(
                  future: CourseDataService().getCoursesListFuture(), // _future,
                  builder: (context, snapshot) {
                    if(snapshot.connectionState == ConnectionState.done) {
                      if(snapshot.hasError) {
                        print("Error: ${snapshot.error}");
                        print("Stacktrace: ${snapshot.stackTrace}");
                        return const Text('Error loading data');
                      }
                      else if(snapshot.hasData) {
                        if(snapshot.data != null) {
                          List<ListTile> result = [];
                          for (var element in snapshot.data!.toList()) {
                            result.add(ListTile(
                              title: Text(element.title ?? "No title."),
                              subtitle: FutureBuilder(
                                future: CourseDataService().getSetsNumberFuture(element.courseId),
                                builder: (context, snapshot) {
                                  if(snapshot.connectionState == ConnectionState.done) {
                                    if(snapshot.hasError) {
                                      print("Error: ${snapshot.error}");
                                      print("Stacktrace: ${snapshot.stackTrace}");
                                      return const Text('Error loading data');
                                    } else if(snapshot.hasData) {
                                      if(snapshot.data != null) {
                                        return Text("Number of sets: ${snapshot.data}");
                                      }
                                    }
                                    else {
                                    return const CircularProgressIndicator();
                                    }
                                  }
                                  return const Text('Unknown condition.');
                                }
                              ),
                              onTap: () {
                                widget.updateCurrentCourseId(element.courseId);
                                Navigator.of(context).pop();
                              },
                              // onLongPress: () async {
                              //   await Navigator.push(context, MaterialPageRoute(
                              //     builder: (context) => CourseEditorScreen(element, parentSetState)
                              //   ));
                              //   setState(() {print("Drawer updated.");});
                              // },
                              trailing: IconButton(
                                onPressed: () async {
                                  await Navigator.push(context, MaterialPageRoute(
                                    builder: (context) => CourseEditorScreen(element, parentSetState)
                                  ));
                                  setState(() {
                                    print("Drawer updated.");
                                  });
                                },
                                icon: const Icon(Icons.more_vert)
                              ),
                            ));
                          }
                          // print(result);
                          return ListView(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            children: result
                          );
                        }
                      }
                      // return Text(snapshot.data.toString());
                    } else {
                      return const CircularProgressIndicator();
                    }
                    return const Text('Unknown condition.');
                  },
                ),
              ),
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
      );
  }

  void parentSetState() {
    setState(() {});
  }
}