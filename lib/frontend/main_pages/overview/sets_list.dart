// Tento soubor obsahuje Widget, který zobrazí seznam setů ve vybraném kurzu

import 'package:flutter/material.dart';

import 'package:words_app_3/backend/data/main_database/set_data.dart';
import 'package:words_app_3/backend/data/users_database/progress_data.dart';
import 'package:words_app_3/backend/system/auth.dart';
import 'package:words_app_3/backend/system/models.dart';

import 'package:words_app_3/frontend/editors/set_editor.dart';
import 'package:words_app_3/frontend/learn/l_flashcards.dart';
import 'package:words_app_3/frontend/learn/l_overview.dart';
import 'package:words_app_3/frontend/learn/l_test.dart';
import 'package:words_app_3/frontend/main_pages/overview/progress_overview/progress_overview.dart';

// Zobrazení seznamu setů
class SetsList extends StatefulWidget {
  final bool isAuthor;
  final String? courseId;
  const SetsList(this.courseId, this.isAuthor, {super.key});

  @override
  State<SetsList> createState() => _SetsListState();
}

class _SetsListState extends State<SetsList> {
  _SetsListState();

  // Seznam setů
  List<SetModel> sets = [];

  @override
  void initState() {
    loadInitialData().then((value) => setState(() {
    }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    
    // FutureBuilder, který získá a zobrazí seznam kurzů
    return FutureBuilder(
      future: SetDataService().getSetsList(widget.courseId),
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.done) {
          if(snapshot.hasError) {
            return const Text('Error loading data');
          }
          else if(snapshot.hasData) {
            if(snapshot.data != null) {
              List<SetTile> result = [];
              for (var element in snapshot.data!.toList()) {
                result.add(SetTile(element, parentSetState, widget.isAuthor));
              }
              return ListView(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                children: result
              );
            }
          }
        }
        else {
          return const CircularProgressIndicator();
        }

        // Pokud nastal neznámý problém
        return const Text('Unknown condition.');
      },
    );
  }

  // Načtení počátečních dat
  Future<void> loadInitialData() async {

    // Získání seznamu setů z databáze
    sets = await SetDataService().getSetsList(widget.courseId);
  }

  // Funkce, která znovu sestaví Widget
  void parentSetState() {
    setState(() {});
  }
}

// Jedna "kartička", která reprezentuje set
class SetTile extends StatefulWidget {
  final SetModel set;
  final Function parentSetState;
  final bool isAuthor;
  const SetTile(this.set, this.parentSetState, this.isAuthor, {super.key});

  @override
  State<SetTile> createState() => _SetTileState();
}

class _SetTileState extends State<SetTile> {
  int nLearned = 0;
  int nTested = 0;
  int total = 0;
  
  @override
  void initState() {
    if(!widget.isAuthor) {
      loadInitialData().then((value) => setState(() {}));
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    // Dlaždice seznamu
    return ListTile(
      title: Text(widget.set.title ?? "No title."),
      subtitle: Column(
        children: [

          // Není-li uživatel autorem, zobrazení vlastního postupu
          Visibility(
            visible: !widget.isAuthor,
            child: Column(
              children: [
                Text("Learned: ${nLearned+nTested}/$total"),
                  LinearProgressIndicator(
                    minHeight: 8.0,
                    backgroundColor: Colors.black,
                    color: Colors.yellow,
                    value: ((nLearned+nTested) / (total == 0 ? 1 : total)),
                  ),
                  Text("Tested: $nTested/$total"),
                  LinearProgressIndicator(
                    minHeight: 8.0,
                    backgroundColor: Colors.black,
                    color: Colors.blue,
                    value: (nTested / (total == 0 ? 1 : total)),
                  )
              ],
            ),
          ),

          // Počet slov
          FutureBuilder(
            future: SetDataService().getWordsNumberFuture(widget.set),
            builder: (context, snapshot) {
              if(snapshot.connectionState == ConnectionState.done) {
                if(snapshot.hasError) {
                  return const Text('Error loading data');
                } else if(snapshot.hasData) {
                  if(snapshot.data != null) {
                    return Text("Number of words: ${snapshot.data}");
                  }
                }
                else {
                return const CircularProgressIndicator();
                }
              }
              return const Text('Unknown condition.');
            }
          ),
        ],
      ),

      // Tlačítko na úpravu setu
      trailing: Visibility(
        visible: widget.isAuthor,
        child: IconButton(
          onPressed: () async {
            await Navigator.push(context, MaterialPageRoute(

              // Editor setu
              builder: (context) => SetEditorScreen(widget.set, parentSetState)
            ));
            setState(() {});
          },
          icon: const Icon(Icons.edit)
        ),
      ),
      onTap: () async {

        // Je-li uživatel tvůrcem kurzu, zobrazí se mu při klepnutí na dlaždici přehled postupu studentů. Není-li tvůrcem, zobrazí se mu možnosti studia slovíček
        if(widget.isAuthor) {
          Navigator.push(context, MaterialPageRoute(

            // Stránka s přehledem postupu studentů
            builder: (context) => ProgressOverview(widget.set)
          ));
        } else {

          // Nabídka studia
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Learn"),
                content: const Text("Choose a learning mode"),
                actions: [

                  // Stránka se seznamem slovíček
                  TextButton(
                    onPressed: () async {
                      await Navigator.push(context, MaterialPageRoute(
                        builder: (context) => Overview(widget.set)
                      ));
                      Navigator.pop(context);
                    },
                    child: const Text("Overview")
                  ),

                  // Stránka s výukovými kartičkami
                  TextButton(
                    onPressed: () async {
                      await Navigator.push(context, MaterialPageRoute(
                        builder: (context) => Flashcards(widget.set)
                      ));
                      Navigator.pop(context);
                    },
                    child: const Text("Flashcards")
                  ),

                  // Test
                  OutlinedButton(
                    onPressed: () async {
                      await Navigator.push(context, MaterialPageRoute(
                        builder: (context) => Test(widget.set)
                      ));
                      Navigator.pop(context);
                    },
                    child: const Text("Test")
                  ),
                ],
              );
            }
          );
        }
      }
    );
  }

  void parentSetState() {
    setState(() {});
  }

  Future<void> loadInitialData() async {

    // Získání postupu
    List<WordModel> data = await ProgressDataService().getProgress(UserModel(AuthService().getUserId(), null, null, null), widget.set);
    for(WordModel word in data) {
      if(word.memory1 == 1) {
        nLearned++;
      }
      if(word.memory2 == 1) {
        nLearned++;
      }
      if(word.memory1 == 2) {
        nTested++;
      }
      if(word.memory2 == 2) {
        nTested++;
      }
      total += 2;
    }
  }
}