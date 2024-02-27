// Na této stránce se jen zobrazí seznam slovíček v daném setu

import 'package:flutter/material.dart';

import 'package:words_app_3/backend/data/main_database/word_data.dart';
import 'package:words_app_3/backend/system/models.dart';

// Stránka přehledu
class Overview extends StatelessWidget {
  final SetModel set;
  const Overview(this.set, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Overview"),
      ),
      body: OverviewWordList(set),
    );
  }
}

// Seznam slov v setu
class OverviewWordList extends StatefulWidget {
  final SetModel set;
  OverviewWordList(this.set, {super.key});

  @override
  State<OverviewWordList> createState() => _OverviewWordListState();
}

class _OverviewWordListState extends State<OverviewWordList> {
  List<WordModel> words = [];

  @override
  void initState() {
    loadData().then((value) => setState(() {}));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      shrinkWrap: true,
      itemCount: words.length,
      itemBuilder: (context, index) {
        return Column(
          children: [

            // Jedna karta (v tomto případě jako Widget Container)
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 1.0),
                borderRadius: const BorderRadius.all(Radius.circular(8.0)),
              ),
              child: ListTile(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // Originál
                    Text(
                      words[index].original ?? "",
                      textAlign: TextAlign.left
                    ),

                    // Překlad
                    Text(
                      words[index].translation ?? "",
                      textAlign: TextAlign.left
                    )
                  ],
                ),

                // Číslo slova
                subtitle: Text("Word number: ${index+1}"),
              ),
            ),
            const SizedBox(height: 8.0)
          ],
        );
      },
    );
  }

  Future<void> loadData() async {

    // Načtení dat z databáze
    List<WordModel> wordsList = await WordDataService().getWordsList(widget.set);

    setState(() {
      words = wordsList;
    });
  }
}