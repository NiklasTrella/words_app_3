// Na této stránce učitel vidí postup svých studentů v daném setu

import 'package:flutter/material.dart';

import 'package:words_app_3/backend/data/main_database/course_data.dart';
import 'package:words_app_3/backend/data/users_database/progress_data.dart';
import 'package:words_app_3/backend/system/models.dart';

// Stránka pro zobrazení postupu studentů
class ProgressOverviewScreen extends StatefulWidget {
  final SetModel set;
  const ProgressOverviewScreen(this.set, {super.key});

  @override
  State<ProgressOverviewScreen> createState() => _ProgressOverviewScreenState();
}

class _ProgressOverviewScreenState extends State<ProgressOverviewScreen> {
  List<UserModel> students = [];
  List<Map<String, int>> progress = [];

  // Základní nastavení
  @override
  void initState() {

    // Načlení počátečních dat
    loadInitialData().then((value) => setState(() {}));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      // Nadpis
      appBar: AppBar(
        title: const Text("Progress overview"),
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            Text(widget.set.title ?? "No title"),

            // Seznam studentů
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: students.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(

                    // Jméno studenta
                    title: Text("${students[index].firstName} ${students[index].lastName}"),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        // Postup studia (zobrazení výukových kartiček)
                        Text("Learned: ${progress[index]["nLearned"]! + progress[index]["nTested"]!}/${progress[index]["total"]}"),
                        LinearProgressIndicator(
                          minHeight: 8.0,
                          backgroundColor: Colors.black,
                          color: Colors.yellow,
                          value: ((progress[index]["nLearned"]! + progress[index]["nTested"]!) / (progress[index]["total"]! == 0 ? 1 : progress[index]["total"]!)),
                        ),

                        // Postup testů
                        Text("Tested: ${progress[index]["nTested"]}/${progress[index]["total"]}"),
                        LinearProgressIndicator(
                          minHeight: 8.0,
                          backgroundColor: Colors.black,
                          color: Colors.blue,
                          value: (progress[index]["nTested"]! / (progress[index]["total"]! == 0 ? 1 : progress[index]["total"]!)),
                        )
                      ],
                    ),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  // Načtení počátečních dat
  Future<void> loadInitialData() async {

    // Seznam studentů
    students = await CourseDataService().getStudentsList(widget.set.courseId);
    
    // Postup studentů
    Map<UserModel, List<WordModel>> data = await ProgressDataService().getStudentProgress(students, widget.set);
    
    // Formátování dat
    data.forEach((key, value) {
      int nLearned = 0;
      int nTested = 0;
      int total = 0;
      for(WordModel word in value) {
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
      progress.add({
        "nLearned": nLearned,
        "nTested": nTested,
        "total": total
      });
    });
  }
}