// Na této stránce může uživatel měnit data setu

import 'package:flutter/material.dart';
import 'package:words_app_3/backend/data/main_database/set_data.dart';
import 'package:words_app_3/backend/system/models.dart';
import 'package:words_app_3/frontend/editors/word_list_generator.dart';

// Editor setu
class SetEditorScreen extends StatefulWidget {
  final SetModel setModel;
  final Function? parentSetState;
  const SetEditorScreen(this.setModel, this.parentSetState, {super.key});

  @override
  State<SetEditorScreen> createState() => _CreateSetScreenState();
}

class _CreateSetScreenState extends State<SetEditorScreen> {
  TextEditingController titleController = TextEditingController();
  List<WordModel> words = [];

  @override
  void initState() {

    // Nastavení ovladače názvu setu
    if(widget.setModel.title != null) {
      titleController.text = widget.setModel.title as String;
    } else {
      titleController.text = '';
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.setModel.setId == null ? const Text("Create a new set") : const Text('Edit set'),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [

              // Textové pole na název setu
              TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Title'
                ),
                controller: titleController,
              ),
              const SizedBox(height: 10),

              // Seznam slov
              WordListGenerator(widget.setModel, parentUpdateFunction),
              const SizedBox(height: 10),

              // Tlačítko na uložení setu
              ElevatedButton(
                child: widget.setModel.setId == null ? const Text('Create set') : const Text('Save set'),
                onPressed: () {
                  SetModel setToReturn = SetModel(widget.setModel.courseId, widget.setModel.setId, titleController.text);
                  SetDataService().addSet(setToReturn, words).then(
                    (value) => Navigator.pop(context)
                  );
                },
              ),

              // Tlačítko na smazání setu (zobrazí se pouze jeho tvůrci)
              Visibility(
                visible: widget.setModel.setId != null,
                child: TextButton.icon(
                  label: const Text("Delete set"),
                  onPressed: () {
                    String? setTitle = widget.setModel.title;

                    // Potvrzení smazání setu
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Removal confirmation"),
                          content: Text("Do you want to remove $setTitle?"),
                          actions: [
                            TextButton.icon(
                              icon: const Icon(Icons.done),
                              onPressed: () {
                                SetDataService().deleteSet(widget.setModel);
                                widget.parentSetState!();
                                Navigator.pop(context);
                              },
                              label: const Text("Yes."),
                            ),
                            TextButton.icon(
                              icon: const Icon(Icons.close),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              label: const Text("No.")
                            )
                          ],
                        );
                      }
                    );
                  },
                  icon: const Icon(Icons.delete),
                ),
              )
            ],
          ),
        )
      ),
    );
  }

  // Funkce, která umožňuje generátoru seznamu slov (WordListGenerator) ukládat svá data do tohoto Widgetu
  void parentUpdateFunction(List<WordModel> wordsToUpdate) {
    words = wordsToUpdate;
    print(words);
  }
}