import 'package:flutter/material.dart';
import 'package:words_app_3/backend/data/main_database/course_data.dart';
import 'package:words_app_3/backend/data/users_database/progress_data.dart';
import 'package:words_app_3/backend/data/users_database/student_data.dart';
import 'package:words_app_3/backend/system/models.dart';

class NonStudentsList extends StatefulWidget {
  final String? courseId;
  const NonStudentsList(this.courseId, {super.key});

  @override
  State<NonStudentsList> createState() => _NonStudentsListState();
}

class _NonStudentsListState extends State<NonStudentsList> {
  _NonStudentsListState();
  List<UserModel> nonStudents = [];
  List<bool> checkboxControllers = [];

  @override
  void initState() {
    loadInitialData().then((value) => setState(() {}));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          itemCount: nonStudents.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                title: Text("${nonStudents[index].firstName} ${nonStudents[index].lastName}"),
                subtitle: Row(
                  children: [
                    Checkbox(
                      value: checkboxControllers[index],
                      onChanged: (value) => setState(() {
                        checkboxControllers[index] = !checkboxControllers[index];
                      })
                    ),
                    const SizedBox(width: 8.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Email: ${nonStudents[index].email}"),
                        Text("Id: ${nonStudents[index].userId}"),
                        Visibility(
                          visible: nonStudents[index].isTeacher ?? false,
                          child: const Text("Teacher")
                        )
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
        ),
        OutlinedButton(
          onPressed: () async {
            List<UserModel> nonStudentsToAdd = [];
            for(int i = 0; i<nonStudents.length; i++) {
              if(checkboxControllers[i] == true) {
                nonStudentsToAdd.add(nonStudents[i]);
              }
            }
            await CourseDataService().addStudents(widget.courseId, nonStudentsToAdd);
            await ProgressDataService().addStudentsProgress(widget.courseId, nonStudentsToAdd);
            Navigator.pop(context);
          },
          child: const Text("Add selected")
        )
      ],
    );
  }

  Future<void> loadInitialData() async {
    nonStudents = await StudentDataService().getAllNonStudents(widget.courseId);
    for(int i = 0; i<nonStudents.length; i++) {
      checkboxControllers.add(false);
    }
  }
}