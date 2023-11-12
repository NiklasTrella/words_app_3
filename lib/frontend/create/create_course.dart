import 'package:flutter/material.dart';
import 'package:words_app_3/backend/data.dart';

class CreateCourseScreen extends StatelessWidget {
  CreateCourseScreen({super.key});

  TextEditingController titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Course'),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: ListView(
          children: [
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Title'
              ),
              controller: titleController,
            ),
            ElevatedButton(
              child: Text('Create course'),
              onPressed: () {
                if(titleController.text.length >= 3) {
                  DataService().addCourse(titleController.text.toString());
                  Navigator.pop(context);
                } else {
                  print('Less than 3 characters!');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}