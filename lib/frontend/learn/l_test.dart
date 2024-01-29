import 'package:flutter/material.dart';
import 'package:words_app_3/backend/data/main_database/course_data.dart';
import 'package:words_app_3/backend/data/main_database/word_data.dart';
import 'package:words_app_3/backend/data/users_database/progress_data.dart';
import 'package:words_app_3/backend/system/models.dart';
import 'package:words_app_3/frontend/learn/test_results.dart';

class Test extends StatefulWidget {
  final SetModel set;
  const Test(this.set, {super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  List<WordModel> words = [WordModel(null, null, null)];
  List<String> answers = [];
  int currentWordIndex = 0;
  TextEditingController answerController = TextEditingController();

  @override
  void initState() {
    loadData().then((value) => setState(() {}));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Test"),
      ),
      body: Container(
        margin: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              child: Center(
                child: Text(words[currentWordIndex].original ?? ""),
              ),
            ),
            TextFormField(
              controller: answerController,
              decoration: const InputDecoration(
                labelText: "Translate:",
                hintText: "Answer..."
              ),
            ),
            const SizedBox(height: 8.0),
            OutlinedButton(
              onPressed: () async {
                answers.add(answerController.text);
                answerController.clear();
                answerController.text = "";
                if(currentWordIndex+1 < words.length) {
                  currentWordIndex++;
                  setState(() {});
                } else {
                  await saveData();
                  await Navigator.push(context, MaterialPageRoute(
                    builder: (context) => TestResults(words, answers)
                  ));
                  Navigator.pop(context);
                }
              },
              child: const Text("Next")
            )
          ],
        ),
      ),
    );
  }

  Future<void> loadData() async {
    List<WordModel> wordsList = await WordDataService().getWordsList(widget.set);

    setState(() {
      words = wordsList;
    });
  }

  Future<void> saveData() async {
    Map<String, int> values = {};
    bool isAuthor = await CourseDataService().isAuthor(widget.set.courseId);
    if(!isAuthor) {
      for(int i = 0; i<words.length; i++) {
        if(words[i].translation?.trim() == answers[i].trim()) {
          values.addAll({words[i].wordId! : 1});
        } else {
          values.addAll({words[i].wordId! : 0});
        }
      }
      ProgressDataService().updateSelfWordsProgress(values, widget.set.setId, widget.set.courseId);
    }
  }
}