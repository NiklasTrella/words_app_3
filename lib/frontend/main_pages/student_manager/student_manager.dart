// Stránka, kde se zobrazí seznam studentů v kurzu. Studenty lze mazat

import 'package:flutter/material.dart';

import 'package:words_app_3/backend/data/main_database/course_data.dart';

import 'package:words_app_3/frontend/main_pages/student_manager/student_database/student_database.dart';
import 'package:words_app_3/frontend/main_pages/student_manager/students_list.dart';

// Stránka se seznamem studentů v kurzu
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

          // Nadpis
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

          // Název kurzu
          FutureBuilder<String>(
            future: CourseDataService().getCourseTitleFuture(widget.courseId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return Text(snapshot.data ?? "No data.");
              }
            }
          ),

          // Zobrazení seznamu studentů, je-li vybraný nějaký kurz
          Visibility(
            visible: widget.courseId != null,
            child: Column(
              children: [
                const SizedBox(height: 10),

                // Seznam studentů
                StudentsList(widget.courseId),
                const SizedBox(height: 10),

                // Stránka na přidávání studentů
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