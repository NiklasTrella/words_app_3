import 'package:flutter/material.dart';
import 'package:words_app_3/backend/system/models.dart';

class TestResults extends StatelessWidget {
  final List<WordModel> words;
  final List<String> answers;
  const TestResults(this.words, this.answers, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Test results"),
      ),
      body: Container(
        margin: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Your answers"),
            ListView.builder(
              shrinkWrap: true,
              itemCount: words.length,
              itemBuilder: (context, index) {
                late bool correctAnswer;
                if(answers[index].trim() == words[index].translation?.trim()) {
                  correctAnswer = true;
                } else {
                  correctAnswer = false;
                }
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Original: ${words[index].original ?? ''}",
                        ),
                        Text(
                          "Your answer: ${answers[index]}",
                        ),
                        Visibility(
                          visible: correctAnswer,
                          child: const Row(
                            children: [
                              Icon(Icons.done, color: Colors.green),
                              Text("Correct", style: TextStyle(color: Colors.green))
                            ],
                          ),
                        ),
                        Visibility(
                          visible: !correctAnswer,
                          child: Row(
                            children: [
                              const Icon(Icons.close, color: Colors.red),
                              Text("False. Correct answer: ${words[index].translation ?? ''}", style: const TextStyle(color: Colors.red))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Return to main screen")
            )
          ],
        ),
      ),
    );
  }
}