import 'package:flutter/material.dart';
import 'package:words_app_3/backend/data/word_data.dart';
import 'package:words_app_3/backend/models.dart';
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
    List<WordModel> wordsList = await WordDataService().getWordsListFuture(widget.set);

    setState(() {
      words = wordsList;
    });
  }
}