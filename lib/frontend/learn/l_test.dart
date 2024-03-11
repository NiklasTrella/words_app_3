// Na této stránce uživatel může otestovat své znalosti pomocí kvízu

import 'package:flutter/material.dart';

import 'package:words_app_3/backend/data/main_database/course_data.dart';
import 'package:words_app_3/backend/data/main_database/word_data.dart';
import 'package:words_app_3/backend/data/users_database/progress_data.dart';
import 'package:words_app_3/backend/system/auth.dart';
import 'package:words_app_3/backend/system/models.dart';

import 'package:words_app_3/frontend/learn/test_results.dart';

// Stránka testu
class Test extends StatefulWidget {
  final SetModel set;
  const Test(this.set, {super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {

  // Dva seznamy odpovědí na oba směry překladu (originál → překlad a obráceně)
  Map<String, String> originalsAnswers = {};
  Map<String, String> translationsAnswers = {};

  // Seznam slov
  List<WordModel> words = [/*WordModel(null, null, null)*/];
  bool testingOriginal = true;
  int currentWordIndex = 0;
  TextEditingController answerController = TextEditingController();

  @override
  void initState() {
    loadData().then((value) => setState(() {words = value;}));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(words.length > 0) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Test"),
        ),
        body: Container(
          margin: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              
              // Karta se slovem, které má uživatel přeložit
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      testingOriginal ? (words[currentWordIndex].original ?? "") : (words[currentWordIndex - words.length].translation ?? ""),
                      style: const TextStyle(
                        fontSize: 20.0
                      ),
                    ),
                  ),
                ),
              ),

              // Textové pole, do kterého uživatel zapíše odpověď
              TextFormField(
                controller: answerController,
                decoration: const InputDecoration(
                  labelText: "Translate:",
                  hintText: "Answer..."
                ),
              ),
              const SizedBox(height: 8.0),

              // Tlačítko, kterým uživatel přejde na další stránku
              OutlinedButton(
                onPressed: () async {
                  
                  // Uložení odpovědi z ovladače (controller) do mapy odpovědí
                  testingOriginal
                    ? originalsAnswers[words[currentWordIndex].wordId!] = answerController.text
                    : translationsAnswers[words[currentWordIndex - words.length].wordId!] = answerController.text;
                  answerController.clear();
                  answerController.text = "";

                  // V případě přeložení všech slov jedním směrem → změna směru
                  if(currentWordIndex+1 < words.length*2) {
                    if(currentWordIndex+1 == words.length) {
                      testingOriginal = false;
                    }
                    currentWordIndex++;
                    setState(() {});
                  } else {

                    // V případě přeložení slov → přesměrování uživatele na stránku s výsledky testu
                    await saveData();
                    await Navigator.push(context, MaterialPageRoute(
                      builder: (context) => TestResults(words, originalsAnswers, translationsAnswers)
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
    } else {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
  }

  Future<List<WordModel>> loadData() async {

    // Seznam všech slov v setu
    List<WordModel> wordsList = await WordDataService().getWordsList(widget.set);
    
    // Seznam slov, které uživatel v minulosti úspěšně přeložil
    List<WordModel> learnedWordsList = await ProgressDataService().getProgress(UserModel(AuthService().getUserId(), null, null, null), widget.set); // Přidat funkci
    List<String> learnedWordIds = []; // learnedWordsList.map((wordModel) => wordModel.wordId) as List<String>;

    for(WordModel learnedWord in learnedWordsList) {
      if(learnedWord.memory1 == 2 && learnedWord.memory2 == 2) {
        learnedWordIds.add(learnedWord.wordId ?? "");
      }
    }

    // Odstranění již naučených slov
    for(int i = 0; i < wordsList.length; i++) {
      if(learnedWordIds.contains(wordsList[i].wordId)) {
        wordsList.remove(wordsList[i]);
      }
    }

    // Pokud uživatel v minulosti úspěšně uložil už všechna slova → návrat na původní stránku
    if(wordsList.isEmpty) {
      Navigator.pop(context);
    }

    // setState(() {
    //   words = wordsList;
    // });

    return wordsList;
  }

  // Ukládání dat do databáze
  Future<void> saveData() async {
    Map<String, List<int>> values = {};
    
    // Uložení postupu
    for(int i = 0; i < words.length; i++) {
      List<int> value = [];
      
      // Z odpovědi jsou odstraněny případné mezery před a za slovem, převedení na malá písmena
      if(words[i].translation?.trim().toLowerCase() == originalsAnswers[words[i].wordId]?.trim().toLowerCase()) {
        value.add(2);
      } else {
        value.add(0);
      }

      if(words[i].original?.trim().toLowerCase() == translationsAnswers[words[i].wordId]?.trim().toLowerCase()) {
        value.add(2);
      } else {
        value.add(0);
      }

      values.addAll({words[i].wordId! : value});
    }

    // Uložení postupu do databáze
    ProgressDataService().updateSelfWordsProgress(values, widget.set.setId, widget.set.courseId);
  }
}