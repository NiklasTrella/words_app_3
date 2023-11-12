import 'package:flutter/material.dart';
import 'package:words_app_3/backend/data.dart';

class CreateSetScreen extends StatefulWidget {
  String? courseId;
  CreateSetScreen(this.courseId, {super.key});

  @override
  State<CreateSetScreen> createState() => _CreateSetScreenState();
}

class _CreateSetScreenState extends State<CreateSetScreen> {
  TextEditingController titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create a new set'),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Title'
              ),
              controller: titleController,
            ),
            ElevatedButton(
              child: Text('Create set'),
              onPressed: () {
                  DataService().addSet(titleController.text.toString(), widget.courseId);
                  Navigator.pop(context);
              },
            ),
            WordListGenerator()
          ],
        )
      ),
    );
  }
}

class WordListGenerator extends StatefulWidget {
  const WordListGenerator({super.key});

  @override
  State<WordListGenerator> createState() => _WordListTileState();
}

class _WordListTileState extends State<WordListGenerator> {
  @override
  Widget build(BuildContext context) {
    return Container(

    );
  }
}