// Tento soubor generuje seznam slov

import 'package:flutter/material.dart';

import 'package:words_app_3/backend/data/main_database/word_data.dart';
import 'package:words_app_3/backend/system/models.dart';

// Generátor seznamu slov
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
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: words.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                const SizedBox(height: 8.0),
        
                // Karta (zde Container) jednoho slova
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1.0),
                    borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                  ),
        
                  // Číslo slova
                  child: ListTile(
                    subtitle: Text("Word number: ${index+1}"),
                    title: Column(
                      children: [
        
                        // Textové pole originálu
                        TextField(
                          controller: TextEditingController(text: words[index].original),
                          onChanged: (value) => localWordUpdate(index, 'original', value),
                          decoration: const InputDecoration(
                            hintText: 'Original word'
                          ),
                        ),
        
                        // Textové pole překladu
                        TextField(
                          controller: TextEditingController(text: words[index].translation),
                          onChanged: (value) => localWordUpdate(index, 'translation', value),
                          decoration: const InputDecoration(
                            hintText: 'Translation'
                          ),
                        ),
                        const SizedBox(height: 10)
                      ],
                    ),
        
                    // Tlačítko na smazání slova
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        localWordDelete(index);
                      },
                    ),
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 10),

          // Tlačítko na přidání nového slova
          OutlinedButton.icon( 
            icon: const Icon(Icons.add),
            label: const Text('Add a new word'),
            onPressed: () {
              localWordAdd();
            }
        )
      ],
    );
  }

  // FUnkce, která přidá slovo
  void localWordAdd() {
    setState(() {
      words.add(WordModel(null, null, null));
    });
    print("localWordAdd");
    print("Word length: ${words.length}");

    parentUpdate();
  }

  // Funkce, která aktualizuje slovo
  void localWordUpdate(int indexToUpdate, String wordKey, String wordValue) {
    if(indexToUpdate >= 0 && indexToUpdate < words.length) {
      if(wordKey == 'original') {
        words[indexToUpdate].original = wordValue;
      } else if(wordKey == 'translation') {
        words[indexToUpdate].translation = wordValue;
      }
    }

    parentUpdate();
  }

  // Funkce, která smaže slovo
  void localWordDelete(int index) {
    setState(() {  
      if(index >= 0 && index < words.length) {
        words.removeAt(index);
      }
    });

    parentUpdate();
  }

  // Funkce, která aktualizuje data rodičovského Widgetu
  void parentUpdate() {
    print("Parent update function");
    print("Words length: ${words.length}");
    widget.parentUpdateFunction(words);
  }

  // Funkce, která načítá počáteční data  
  Future<void> loadInitialData() async {
    List<WordModel> wordsList = await WordDataService().getWordsList(widget.setModel);

    if(wordsList == []) {
      setState(() {
        words = [];
      });
      return;
    }

    setState(() {
      words = wordsList;
    });

    parentUpdate();
  }
}