// Stránka databáze odkud lze přidávat nové studenty do kurzu

import 'package:flutter/material.dart';

import 'package:words_app_3/frontend/main_pages/student_manager/student_database/non_students_list.dart';

// Databáze
class StudentsDatabaseScreen extends StatefulWidget {
  final String? courseId;
  const StudentsDatabaseScreen(this.courseId, {super.key});

  @override
  State<StudentsDatabaseScreen> createState() => _StudentsDatabaseScreenState();
}

class _StudentsDatabaseScreenState extends State<StudentsDatabaseScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      // Nadpis
      appBar: AppBar(
        title: const Text("Student database"),
      ),
      body: Container(
        margin: const EdgeInsets.all(20.0),
        
        // Seznam studentů, které lze přidat do kurzu
        child: NonStudentsList(widget.courseId),
      ),
    );
  }
}