import 'package:flutter/material.dart';
import 'package:words_app_3/backend/data/main_database/word_data.dart';
import 'package:words_app_3/backend/system/models.dart';

class Flashcards extends StatefulWidget {
  final SetModel set;
  const Flashcards(this.set, {super.key});

  @override
  State<Flashcards> createState() => _FlashcardsState();
}

class _FlashcardsState extends State<Flashcards> {
  List<WordModel> words = [];
  int currentIndex = 0;
  PageController pageController = PageController(
    initialPage: 0,
  );

  @override
  void initState() {
    loadData().then((value) => setState(() {}));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flashcards"),
      ),
      body: PageView.builder(
        itemCount: words.length,
        onPageChanged: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        itemBuilder: (context, index) {
          return Flashcard(words[index]);
        },
      ),
    );
  }

  Future<void> loadData() async {
    List<WordModel> wordsList = await WordDataService().getWordsList(widget.set);

    setState(() {
      words = wordsList;
    });
  }
}

class Flashcard extends StatefulWidget {
  final WordModel wordModel;

  Flashcard(this.wordModel);

  @override
  State<Flashcard> createState() => _FlashcardState();
}

class _FlashcardState extends State<Flashcard> {
  bool translationVisible = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        elevation: 4.0,
        margin: const EdgeInsets.all(16.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                widget.wordModel.original ?? "",
                style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16.0),
              Visibility(
                visible: translationVisible,
                child: Column(
                  children: [
                    Text(
                      widget.wordModel.translation ?? "",
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
      onTap: () {
        setState(() {
          translationVisible = !translationVisible;
        });
      },
    );
  }
}