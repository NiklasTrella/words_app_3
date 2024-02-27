// Výsledky testu

import 'package:flutter/material.dart';

import 'package:words_app_3/backend/system/models.dart';

// Stránka s výsledky testu
class TestResults extends StatelessWidget {
  bool originalAnswers = true;

  final List<WordModel> words;
  
  final Map<String, String> originalsAnswers;
  final Map<String, String> translationsAnswers;
  
  TestResults(this.words, this.originalsAnswers, this.translationsAnswers, {super.key});

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
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: words.length*2,
                itemBuilder: (context, index) {
                  late bool correctAnswer;
              
                  if(index == words.length) {
                    originalAnswers = false;
                  }
              
                  if(originalAnswers) {
              
                    // Kontrola správnosti odpovědi, odstranění mezer před a za odpovědí, převod na malá písmena
                    if(originalsAnswers[words[index].wordId]?.trim().toLowerCase() == words[index].translation?.trim().toLowerCase()) {
                      correctAnswer = true;
                    } else {
                      correctAnswer = false;
                    }
                  } else {
                    if(translationsAnswers[words[index - words.length].wordId]?.trim().toLowerCase() == words[index - words.length].original?.trim().toLowerCase()) {
                      correctAnswer = true;
                    } else {
                      correctAnswer = false;
                    }
                  }
                  
                  // Karta se slovem a odpovědí
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            originalAnswers ? "Original: ${words[index].original ?? ''}" : "Translation: ${words[index - words.length].translation ?? ''}",
                          ),
                          Text(
                            originalAnswers ? "Your answer: ${originalsAnswers[words[index].wordId]}" : "Your answer: ${translationsAnswers[words[index - words.length].wordId]}",
                          ),
              
                          // Správně
                          Visibility(
                            visible: correctAnswer,
                            child: const Row(
                              children: [
                                Icon(Icons.done, color: Colors.green),
                                Text("Correct", style: TextStyle(color: Colors.green))
                              ],
                            ),
                          ),
              
                          // Špatně
                          Visibility(
                            visible: !correctAnswer,
                            child: Row(
                              children: [
                                const Icon(Icons.close, color: Colors.red),
                                Text(
                                  "False. Correct answer: ${originalAnswers ? words[index].translation ?? '' : words[index - words.length].original ?? ''}",
                                  style: const TextStyle(color: Colors.red)
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Tlačítko → návrat na hlavní stránku
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