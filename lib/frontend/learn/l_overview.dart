import 'package:flutter/material.dart';
import 'package:words_app_3/backend/data/word_data.dart';
import 'package:words_app_3/backend/models.dart';

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
    );;
  }
}

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
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 1.0),
                borderRadius: const BorderRadius.all(Radius.circular(8.0)),
              ),
              child: ListTile(
                subtitle: Text("Word number: ${index+1}"),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      words[index].original ?? "",
                      textAlign: TextAlign.left
                    ),
                    Text(
                      words[index].translation ?? "",
                      textAlign: TextAlign.left
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8.0)
          ],
        );
      },
    );
  }

  Future<void> loadData() async {
    List<WordModel> wordsList = await WordDataService().getWordsListFuture(widget.set);

    setState(() {
      words = wordsList;
    });
  }
}