import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:words_app_3/backend/auth.dart';
import 'package:words_app_3/backend/data.dart';
import 'package:words_app_3/backend/models.dart';

class MainScreenDrawer extends StatefulWidget {
  Function updateCurrentCourseId;
  
  MainScreenDrawer(this.updateCurrentCourseId, {super.key});

  @override
  State<MainScreenDrawer> createState() => _MainScreenDrawerState(updateCurrentCourseId);
}

class _MainScreenDrawerState extends State<MainScreenDrawer> {
  // Future<List<Widget>> future = listViewData();

  Function updateCurrentCourseId;

  _MainScreenDrawerState(this.updateCurrentCourseId);

  // @override
  // void initState() async {
  //   List<CourseModel> _future = await DataService().getCoursesListFuture();
  //   // TODO: implement initState
  //   super.initState();
  // }

  late Future<List<CourseModel>> _future;

  @override
  void initState() {
    _future = DataService().getCoursesListFuture();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Container(
          padding: EdgeInsets.all(20),
          child: ListView(
            children: [
              DrawerHeader(child: Text('Menu')),
              ListTile(title: Text('Express Spanish')),
              // FutureBuilder<List<CourseModel>> (
              //   future: DataService().getCoursesListFuture(),
              //   builder: (context, snapshot) {
              //     if (snapshot.connectionState == ConnectionState.waiting) {
              //       return CircularProgressIndicator(); // Display a loading indicator while fetching data
              //     } else if (snapshot.hasError) {
              //       return Text('Error: ${snapshot.error}');
              //     } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              //       return Text('No courses available.');
              //     } else {
              //       return ListView.builder(
              //         itemCount: snapshot.data?.length,
              //         itemBuilder: (context, index) {
              //           CourseModel course = snapshot.data![index];
              //           print('LisView.builder: ${course.title}');
              //           return ListTile(
              //             // ignore: unrelated_type_equality_checks
              //             title: Text(course.title ?? "- course title not provided -"), // Replace with the appropriate course field
              //           );
              //         },
              //       );
              //     }
              //   }
              // ),
              //       return ListView(
              //         children: snapshot.data!.map((course) {
              //           print('Drawer column built.');
              //           return TextButton(
              //             child: Text(course.title ?? 'N/A'),
              //             onPressed: () {

              //             },
              //             // Add more widgets to display additional course information
              //           );
              //         }).toList(),
              //       );
              //     }
              //   }
              // ),
              // ListView.builder (
              //   // scrollDirection: Axis.vertical,
              //   shrinkWrap: true,
              //   itemBuilder: (context, index) {
              //     var ListViewData = DataService().getCoursesList();
              //     if(ListViewData.length == 0) {
              //       return const Text('No courses in the database.');
              //     } else {
              //       return TextButton(
              //         child: Text(ListViewData[index].title ?? 'N/A'),
              //         onPressed: () {

              //         },
              //       );
              //     }
              //   },
              // ),

              // StreamBuilder<QuerySnapshot>(
              //   stream: DataService().collectionStream,
              //   builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              //     if (snapshot.connectionState == ConnectionState.waiting) {
              //       return CircularProgressIndicator();
              //     }
              //     if (snapshot.hasError) {
              //       return Text('Error: ${snapshot.error}');
              //     }
              //     if (snapshot.hasData) {
              //       var documents = snapshot.data!.docs;
              //       if (documents.isNotEmpty) {
              //         // Display the list
              //         return Column(
              //           children: snapshot.data!.docs.map((course) {
              //             var wantedData = course.data();
              //             print(wantedData.runtimeType);
              //             print(wantedData);

              //             return TextButton(
              //               child: Text('x ' + course.data().toString() ?? 'N/A'),
              //               onPressed: () {

              //               },
              //             );
              //           }).toList(),
              //         );
              //         // print(snapshot.data!.docs);
              //         // return Column(
              //         //   children: [
              //         //     TextButton(
              //         //       child: Text('x' + snapshot.data!.docs.toString() ?? 'N/A'),
              //         //       onPressed: () {}
              //         //     ),
              //         //   ],
              //         // );
              //       } else {
              //         return Text('Collection is empty.');
              //       }
              //     }
              //     return Text('No data available.');
              //   },
              // ),
              // StreamBuilder(
              //   stream: DataService().collectionStream, // Replace with your Firebase reference
              //   builder: (context, snapshot) {
              //     if (snapshot.connectionState == ConnectionState.waiting) {
              //       return CircularProgressIndicator();
              //     } else if (snapshot.hasData) {
              //       // Map Firebase data to widgets here
              //       // Example:
              //       List<Widget>? models = snapshot.data?.docs.map((item) => Text(item.data().toString())).toList();

              //       return ListView.builder(
              //         scrollDirection: Axis.vertical,
              //         shrinkWrap: true,
              //         itemCount: models?.length, // Replace with the length of your data
              //         itemBuilder: (context, index) {
              //           return models?[index];
              //         },
              //       );
              //       } else {
              //         return Text('No data available');
              //       }
              //     },
              //   ),
              FutureBuilder(
                future: _future,
                builder: (context, snapshot) {
                  if(snapshot.connectionState == ConnectionState.done) {
                    if(snapshot.hasError) {
                      return Text('Error loading data');
                    }
                    else if(snapshot.hasData) {
                      if(snapshot.data != null) {
                        List<ListTile> result = [];
                        int counter = 0;
                        // ignore: unused_local_variable
                        for (var element in snapshot.data!.toList()) {
                          result.add(ListTile(
                            title: Text(element.title ?? "No title."),
                            onTap: () => updateCurrentCourseId(element.courseId),
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
                    return CircularProgressIndicator();
                  }
                  return Text('Unknown condition.');
                },
              ),
              ElevatedButton(
                child: Text('Create a course'),
                onPressed: () async {
                  // DataService().addCourse()
                  await Navigator.pushNamed(context, '/create_course');
                  setState(() async {
                    // future = await DataService().getCoursesList() as List<CourseModel>;
                  });
                },
              ),
              ElevatedButton(
                child: Text('Sign out'),
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
}

Future<List<Widget>> listViewData() async {
  List<Widget> widgets = [];
  List<CourseModel> data = await  DataService().getCoursesListFuture();

  if(data.isEmpty) {
    widgets.add(const Text('No data available.'));
  } else {
    for (var element in data) {
      widgets.add(ListTile(
        title: Text(element.title ?? 'No title.')
        )
      );
    }
  }

  return widgets;
}