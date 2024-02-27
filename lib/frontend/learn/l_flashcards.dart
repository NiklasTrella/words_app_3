// Na této stránce si uživatel může opakovat slovíčka pomocí výukových kartiček (flashcards)

import 'package:flutter/material.dart';

import 'package:words_app_3/backend/data/main_database/word_data.dart';
import 'package:words_app_3/backend/data/users_database/progress_data.dart';
import 'package:words_app_3/backend/system/models.dart';

// Stránka s výukovými kartičkami
class Flashcards extends StatefulWidget {
  final SetModel set;
  const Flashcards(this.set, {super.key});

  @override
  State<Flashcards> createState() => _FlashcardsState();
}

class _FlashcardsState extends State<Flashcards> {
  List<bool> learningOriginal = [];
  List<WordModel> words = [];

  // PageController kontroluje, na které stránce se uživatel aktuálně nachází
  PageController pageController = PageController(
    initialPage: 0,
  );

  @override
  void initState() {
    loadData().then((value) => setState(() {})).then((value) {
      for(WordModel word in words) {
        learningOriginal.add(true);
      }
      for(WordModel word in words) {
        learningOriginal.add(false);
      }
      super.initState();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flashcards"),
      ),
      body: PageView.builder(

        // Kartiček je dvakrát více než slov, protože se studenti učí oběma směry - tedy originál→překlad a obráceně
        itemCount: words.length*2,
        onPageChanged: (index) {},

        // Stavba jednotlivých kartiček
        itemBuilder: (context, index) {
          return Flashcard(learningOriginal[index] ? words[index] : words[index - words.length], learningOriginal[index], widget.set);
        },
      ),
    );
  }

  Future<void> loadData() async {
    
    // Seznam slov je získán z databáze
    List<WordModel> wordsList = await WordDataService().getWordsList(widget.set);

    setState(() {
      words = wordsList;
    });
  }
}

// Jedna výuková kartička
class Flashcard extends StatefulWidget {
  final bool learningOriginal;
  final WordModel wordModel;
  final SetModel setModel;

  const Flashcard(this.wordModel, this.learningOriginal, this.setModel);

  @override
  State<Flashcard> createState() => _FlashcardState();
}

class _FlashcardState extends State<Flashcard> {

  // Tento boolean kontroluje, má-li se zobrazit překlad zobrazeného slova
  bool translationVisible = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(

      // Karta
      child: Card(
        elevation: 4.0,
        margin: const EdgeInsets.all(16.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              // Slovo, jehož překlad se má uživatel naučit
              Text(
                widget.learningOriginal ? widget.wordModel.original ?? "" : widget.wordModel.translation ?? "",
                style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16.0),

              // Překlad zobrazeného slova, který se zobrazí po klepnutí na kartičku
              Visibility(
                visible: translationVisible,
                child: Column(
                  children: [
                    Text(
                      widget.learningOriginal ? widget.wordModel.translation ?? "" : widget.wordModel.original ?? "",
                      style: const TextStyle(fontSize: 18.0),
                    ),
                    const SizedBox(height: 16.0)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      // Klepnutí → zobrazení překladu aktuálního slova
      onTap: () {
        WordModel wordToSave = widget.wordModel;
        if(widget.learningOriginal) {
          wordToSave.memory1 = 1;
        } else {
          wordToSave.memory2 = 1;
        }

        // Uložení dat
        saveData(wordToSave, widget.setModel);
        setState(() {
          translationVisible = !translationVisible;
        });
      },
    );
  }

  // Uložení postupu do databáze
  Future<void> saveData(WordModel wordToSave, SetModel setModel) async {
    ProgressDataService().updateSelfWordsProgress({wordToSave.wordId!: [wordToSave.memory1, wordToSave.memory2]}, setModel.setId, setModel.courseId);
  }
}