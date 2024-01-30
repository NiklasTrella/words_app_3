import 'package:flutter/material.dart';
import 'package:words_app_3/backend/data/main_database/course_data.dart';
import 'package:words_app_3/backend/system/models.dart';

class CourseEditorScreen extends StatefulWidget {
  final CourseModel course;
  final Function? parentSetState;
  const CourseEditorScreen(this.course, this.parentSetState, {super.key});

  @override
  State<CourseEditorScreen> createState() => _CourseEditorScreenState();
}

class _CourseEditorScreenState extends State<CourseEditorScreen> {
  TextEditingController titleController = TextEditingController();

  @override
  void initState() {
    if(widget.course.title != null) {
      titleController = TextEditingController(text: widget.course.title);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Editor'),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Title'
              ),
              controller: titleController,
            ),
            ElevatedButton(
              child: widget.course.courseId == null ? const Text('Create course') : const Text('Save course'),
              onPressed: () {
                if(titleController.text.length >= 3) {
                  CourseDataService().addCourse(titleController.text.toString(), widget.course.courseId);
                  Navigator.pop(context);
                } else {
                  print('Less than 3 characters!');
                }
              },
            ),
            Visibility(
              visible: widget.course.courseId != null,
              child: TextButton.icon(
                label: const Text("Delete course"),
                onPressed: () {
                  String? courseTitle = widget.course.title;
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Removal confirmation"),
                        content: Text("Do you want to remove $courseTitle?"),
                        actions: [
                          TextButton.icon(
                            icon: const Icon(Icons.done),
                            onPressed: () {
                              CourseDataService().deleteCourse(widget.course.courseId!);
                              widget.parentSetState!();
                              popContext();
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
                icon: const Icon(Icons.delete),
              ),
            )
          ],
        ),
      ),
    );
  }

  void popContext() {
    Navigator.of(context).pop();
  }
}