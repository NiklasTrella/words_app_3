import 'package:flutter/material.dart';
import 'package:words_app_3/backend/data/main_database/set_data.dart';
import 'package:words_app_3/backend/system/models.dart';
import 'package:words_app_3/frontend/editors/set_editor.dart';
import 'package:words_app_3/frontend/learn/l_flashcards.dart';
import 'package:words_app_3/frontend/learn/l_overview.dart';
import 'package:words_app_3/frontend/learn/l_test.dart';
import 'package:words_app_3/frontend/main_pages/overview/progress_overview/progress_overview.dart';

class SetsList extends StatefulWidget {
  final bool isAuthor;
  final String? courseId;
  const SetsList(this.courseId, this.isAuthor, {super.key});

  @override
  State<SetsList> createState() => _SetsListState();
}

class _SetsListState extends State<SetsList> {
  List<SetModel> sets = [];
  bool dataLoaded = false;
  _SetsListState();

  @override
  void initState() {
    loadInitialData().then((value) => setState(() {
      dataLoaded = true;
    }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // if(dataLoaded == false) {
    //   return const Center(
    //     child: CircularProgressIndicator(),
    //   );
    // } else {
    //   return ListView.builder(
    //     shrinkWrap: true,
    //     itemCount: sets.length,
    //     itemBuilder: (context, index) => SetTile(sets[index], parentSetState),
    //   );
    // }
    return FutureBuilder(
      // Zdroj dat
      future: SetDataService().getSetsList(widget.courseId),

      // Builder obsahu
      builder: (context, snapshot) {
        // Zkontrolovat je-li připojení úspěšné
        if(snapshot.connectionState == ConnectionState.done) {

          // Má-li Snapshot error
          if(snapshot.hasError) {
            return const Text('Error loading data');
          }

          // Má-li Snapshot data
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

        // Načítá-li se databáze
        else {
          return const CircularProgressIndicator();
        }

        // Pokud nastal neznámý problém / je-li připojení neúspěšné
        // Potenciálně nepotřebné vzhledem k else-statementu výše
        return const Text('Unknown condition.');
      },
    );
  }

  Future<void> loadInitialData() async {
    print("SetsList loadInitialData()");
    sets = await SetDataService().getSetsList(widget.courseId);
  }

  void parentSetState() {
    setState(() {});
  }
}

class SetTile extends StatefulWidget {
  final SetModel set;
  final Function parentSetState;
  final bool isAuthor;
  const SetTile(this.set, this.parentSetState, this.isAuthor, {super.key});

  @override
  State<SetTile> createState() => _SetTileState();
}

class _SetTileState extends State<SetTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.set.title ?? "No title."),
      subtitle: FutureBuilder(
        future: SetDataService().getWordsNumberFuture(widget.set),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.done) {
            if(snapshot.hasError) {
              print("Error: ${snapshot.error}");
              print("Stacktrace: ${snapshot.stackTrace}");
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
      trailing: Visibility(
        visible: widget.isAuthor,
        child: IconButton(
          onPressed: () async {
            await Navigator.push(context, MaterialPageRoute(
              builder: (context) => SetEditorScreen(widget.set, parentSetState)
            ));
            setState(() {});
          },
          icon: const Icon(Icons.edit)
        ),
      ),
      onTap: () async {
        if(widget.isAuthor) {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => ProgressOverview(widget.set)
          ));
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Learn"),
                content: const Text("Choose a learning mode"),
                actions: [
                  TextButton(
                    onPressed: () async {
                      await Navigator.push(context, MaterialPageRoute(
                        builder: (context) => Overview(widget.set)
                      ));
                      Navigator.pop(context);
                    },
                    child: const Text("Overview")
                  ),
                  TextButton(
                    onPressed: () async {
                      await Navigator.push(context, MaterialPageRoute(
                        builder: (context) => Flashcards(widget.set)
                      ));
                      Navigator.pop(context);
                    },
                    child: const Text("Flashcards")
                  ),
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
}