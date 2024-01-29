import 'package:flutter/material.dart';
import 'package:words_app_3/backend/data/main_database/course_data.dart';
import 'package:words_app_3/frontend/main_pages/student_manager/student_database/student_database.dart';
import 'package:words_app_3/frontend/main_pages/student_manager/students_list.dart';

class StudentManagerScreen extends StatefulWidget {
  final String? courseId;
  
  const StudentManagerScreen(this.courseId, {super.key});

  @override
  State<StudentManagerScreen> createState() => _StudentManagerScreenState();
}

class _StudentManagerScreenState extends State<StudentManagerScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Text(
            "Student manager",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold
            ),
          ),
          const SizedBox(height: 10),
          const Divider(),
          const SizedBox(height: 10),
          FutureBuilder<String>(
            future: CourseDataService().getCourseTitleFuture(widget.courseId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Display a loading indicator while the future is in progress
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                // Display an error message if the future fails
                return Text('Error: ${snapshot.error}');
              } else {
                // Display the data when the future completes successfully
                return Text(snapshot.data ?? "No data.");
              }
            }
          ),
          Visibility(
            visible: widget.courseId != null,
            child: Column(
              children: [
                const SizedBox(height: 10),
                StudentsList(widget.courseId),
                const SizedBox(height: 10),
                OutlinedButton.icon(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => StudentsDatabaseScreen(widget.courseId),
                    ));
                    setState(() {});
                  },
                  icon: const Icon(Icons.add),
                  label: const Text("Add students")
                )
              ],
            ),
          ),
        ],
      )
    );
  }
}