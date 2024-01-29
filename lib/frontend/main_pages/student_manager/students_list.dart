import 'package:flutter/material.dart';
import 'package:words_app_3/backend/data/main_database/course_data.dart';
import 'package:words_app_3/backend/data/users_database/progress_data.dart';
import 'package:words_app_3/backend/data/users_database/student_data.dart';
import 'package:words_app_3/backend/system/models.dart';

class StudentsList extends StatefulWidget {
  final String? courseId;
  const StudentsList(this.courseId, {super.key});

  @override
  State<StudentsList> createState() => _StudentsListState();
}

class _StudentsListState extends State<StudentsList> {
  List<UserModel> students = [];
  _StudentsListState();

  @override
  void initState() {
    loadInitialData().then((value) => setState(() {}));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: students.length,
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            title: Text("${students[index].firstName} ${students[index].lastName}"),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Email: ${students[index].email}"),
                Text("Id: ${students[index].userId}"),
                Visibility(
                  visible: students[index].isTeacher ?? false,
                  child: const Text("Teacher")
                )
              ],
            ),
            trailing: IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Removal confirmation"),
                      content: Text("Do you want to remove ${students[index].firstName} ${students[index].lastName}?"),
                      actions: [
                        TextButton.icon(
                          icon: const Icon(Icons.done),
                          onPressed: () async {
                            await StudentDataService().removeStudent(widget.courseId!, students[index].userId!);
                            await ProgressDataService().deleteCourseProgress(widget.courseId, students[index].userId);
                            setState(() {
                              students.removeAt(index);
                            });
                            Navigator.of(context).pop();
                          },
                          label: const Text("Yes."),
                        ),
                        TextButton.icon(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          label: const Text("No.")
                        )
                      ],
                    );
                  }
                );
              },
              icon: const Icon(Icons.delete)
            ),
          ),
        );
      }
    );
  }

  Future<void> loadInitialData() async {
    students = await CourseDataService().getStudentsList(widget.courseId);
  }
}