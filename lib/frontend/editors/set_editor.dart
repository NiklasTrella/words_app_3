// Import knihoven
import 'package:flutter/material.dart';
import 'package:words_app_3/backend/data/main_database/set_data.dart';
import 'package:words_app_3/backend/system/models.dart';
import 'package:words_app_3/frontend/editors/word_list_generator.dart';

// Stránka SetEditor
class SetEditorScreen extends StatefulWidget {

  // Základní data setu
  final SetModel setModel;

  final Function? parentSetState;

  // Získání základních dat setu
  const SetEditorScreen(this.setModel, this.parentSetState, {super.key});

  @override
  State<SetEditorScreen> createState() => _CreateSetScreenState();
}

class _CreateSetScreenState extends State<SetEditorScreen> {

  // Create a controller for the title
  TextEditingController titleController = TextEditingController();

  // Create list of WordModels
  List<WordModel> words = [];

  // Initialize the title controller
  @override
  void initState() {
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
              TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Title'
                ),
                controller: titleController,
              ),
              const SizedBox(height: 10),
              WordListGenerator(widget.setModel, parentUpdateFunction),
              const SizedBox(height: 10),
              ElevatedButton(
                child: widget.setModel.setId == null ? const Text('Create set') : const Text('Save set'),
                onPressed: () {
                  SetModel setToReturn = SetModel(widget.setModel.courseId, widget.setModel.setId, titleController.text);
                  SetDataService().addSet(setToReturn, words).then(
                    (value) => Navigator.pop(context)
                  );
                },
              ),
              Visibility(
                visible: widget.setModel.setId != null,
                child: TextButton.icon(
                  label: const Text("Delete set"),
                  onPressed: () {
                    String? setTitle = widget.setModel.title;
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
                                popContext();
                                Navigator.of(context).pop();
                              },
                              label: const Text("Yes."),
                            ),
                            TextButton.icon(
                              icon: const Icon(Icons.close),
                              onPressed: () {
                                Navigator.of(context).pop();
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

  void popContext() {
    Navigator.of(context).pop();
  }

  void parentUpdateFunction(List<WordModel> wordsToUpdate) {
    print("ParentUpdateFunction has started.");
    words = wordsToUpdate;
    print(words);
  }
}