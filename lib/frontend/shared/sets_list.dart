import 'package:flutter/material.dart';
import 'package:words_app_3/backend/data/set_data.dart';
import 'package:words_app_3/backend/models.dart';
import 'package:words_app_3/frontend/editors/set_editor.dart';
import 'package:words_app_3/frontend/learn/l_flashcards.dart';
import 'package:words_app_3/frontend/learn/l_overview.dart';
import 'package:words_app_3/frontend/learn/l_test.dart';

class SetsList extends StatefulWidget {
  final String? courseId;
  const SetsList(this.courseId, {super.key});

  @override
  State<SetsList> createState() => _SetsListState();
}

class _SetsListState extends State<SetsList> {
  _SetsListState();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Zdroj dat
      future: SetDataService().getSetsListFuture(widget.courseId),

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
                result.add(SetTile(element, parentSetState));
              }
              return ListView(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                children: result
              );
            }
          }
          // return Text(snapshot.data.toString());
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

  void parentSetState() {
    setState(() {});
  }
}

class SetTile extends StatefulWidget {
  final SetModel set;
  final Function parentSetState;
  const SetTile(this.set, this.parentSetState, {super.key});

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
      // trailing: IconButton(
      //   icon: const Icon(Icons.delete),
      //   onPressed: () {
      //     String? setTitle = widget.set.title;
      //     showDialog(
      //       context: context,
      //       builder: (BuildContext context) {
      //         return AlertDialog(
      //           title: const Text("Removal confirmation"),
      //           content: Text("Do you want to remove $setTitle?"),
      //           actions: [
      //             TextButton.icon(
      //               icon: const Icon(Icons.done),
      //               onPressed: () {
      //                 SetDataService().deleteSet(widget.set);
      //                 widget.parentSetState();
      //                 Navigator.of(context).pop();
      //               },
      //               label: const Text("Yes."),
      //             ),
      //             TextButton.icon(
      //               icon: const Icon(Icons.close),
      //               onPressed: () {
      //                 Navigator.of(context).pop();
      //               },
      //               label: const Text("No.")
      //             )
      //           ],
      //         );
      //       }
      //     );
      //   },
      // ),
      trailing: IconButton(
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(
            builder: (context) => SetEditorScreen(widget.set, parentSetState)
          ));
          setState(() {
            print("Drawer updated.");
          });
        },
        icon: const Icon(Icons.more_vert)
      ),
      // onTap: () async {
      //   // print("Set.courseId: ${widget.set.courseId}\tSet.setId: ${widget.set.setId}\tSet.title: ${widget.set.title}");
      //   await Navigator.push(context, MaterialPageRoute(
      //     builder: (context) => SetEditorScreen(widget.set, parentSetState),
      //   ));
      //   setState(() {});
      // },
      onTap: () {
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
      },
    );
  }

  void parentSetState() {
    setState(() {});
  }
}