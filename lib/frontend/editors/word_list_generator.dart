import 'package:flutter/material.dart';
import 'package:words_app_3/backend/data/word_data.dart';
import 'package:words_app_3/backend/models.dart';

class WordListGenerator extends StatefulWidget {
  final Function parentUpdateFunction;
  final SetModel setModel;
  const WordListGenerator(this.setModel, this.parentUpdateFunction, {super.key});

  @override
  State<WordListGenerator> createState() => _WordListGeneratorState();
}

class _WordListGeneratorState extends State<WordListGenerator> {
  _WordListGeneratorState();
  List<WordModel> words = [];

  @override
  void initState() {
    loadInitialData().then((value) => setState(() {}));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          itemCount: words.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                const SizedBox(height: 8.0),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1.0),
                    borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                  ),
                  child: ListTile(
                    subtitle: Text("Word number: ${index+1}"),
                    title: Column(
                      children: [
                        TextField(
                          // controller: words[index]['original'],
                          // onChanged: (value) => localWordUpdate(index, 'original', value),
                          controller: TextEditingController(text: words[index].original),
                          onChanged: (value) => localWordUpdate(index, 'original', value),
                          decoration: const InputDecoration(
                            hintText: 'Original word'
                          ),
                        ),
                        TextField(
                          // controller: words[index]['translation'],
                          // onChanged: (value) => localWordUpdate(index, 'translation', value),
                          controller: TextEditingController(text: words[index].translation),
                          onChanged: (value) => localWordUpdate(index, 'translation', value),
                          decoration: const InputDecoration(
                            hintText: 'Translation'
                          ),
                        ),
                        const SizedBox(height: 10)
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          localWordDelete(index);
                        });
                      },
                    ),
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon( 
            icon: const Icon(Icons.add),
            label: const Text('Add a new word'),
            onPressed: localWordAdd
        )
      ],
    );
  }

  void localWordAdd() {
    setState(() {
      words.add(WordModel(null, null, null));
    });

    parentUpdate();
  }

  void localWordUpdate(int indexToUpdate, String wordKey, String wordValue) {
    // setState(() {
      if(indexToUpdate >= 0 && indexToUpdate < words.length) {
        // words[indexToUpdate][wordKey]?.text = wordValue;
        if(wordKey == 'original') {
          words[indexToUpdate].original = wordValue;
        } else if(wordKey == 'translation') {
          words[indexToUpdate].translation = wordValue;
        } else {
          print("Invalid wordKey");
        }
      } else {
        print("Invalid index. Element not updated.");
      }
    // });

    parentUpdate();
  }

  void localWordDelete(int index) {
    // Removes a word at a specific index
    setState(() {  
      if(index >= 0 && index < words.length) {
        words.removeAt(index);
        print("Deleted an element (word) at index: $index");
      } else {
        print("Invalid index. Element not removed.");
      }
    });

    parentUpdate();
  }

  void parentUpdate() {
    widget.parentUpdateFunction(words);
  }
  
  Future<void> loadInitialData() async {
    List<WordModel> wordsList = await WordDataService().getWordsListFuture(widget.setModel);

    for(WordModel word in wordsList) {
      print("WordId: ${word.wordId}");
      print("Original: ${word.original}\tTranslation: ${word.translation}\n");
    }

    if(wordsList == []) {
      print("WordsList is empty");
      // return [{"": TextEditingController()}];
      // return [];
      setState(() {
        words = [];
      });
      return;
    }

    // return wordsList;
    setState(() {
      words = wordsList;
    });

    parentUpdate();
  }
}