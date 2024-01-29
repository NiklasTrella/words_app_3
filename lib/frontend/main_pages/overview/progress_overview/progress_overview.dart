import 'package:flutter/material.dart';
import 'package:words_app_3/backend/data/main_database/course_data.dart';
import 'package:words_app_3/backend/data/users_database/progress_data.dart';
import 'package:words_app_3/backend/system/models.dart';

class ProgressOverview extends StatefulWidget {
  final SetModel set;
  const ProgressOverview(this.set, {super.key});

  @override
  State<ProgressOverview> createState() => _ProgressOverviewState();
}

class _ProgressOverviewState extends State<ProgressOverview> {
  List<UserModel> students = [];
  List<Map<String, int>> progress = [];

  @override
  void initState() {
    loadInitialData().then((value) => setState(() {}));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Progress overview"),
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(widget.set.title ?? "No title"),
            ListView.builder(
              shrinkWrap: true,
              itemCount: students.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("${students[index].firstName} ${students[index].lastName}"),
                        Text("${progress[index]["nLearned"]}/${progress[index]["total"]!} = ${progress[index]["nLearned"]!/progress[index]["total"]!} %")
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LinearProgressIndicator(
                          minHeight: 8.0,
                          backgroundColor: Colors.red,
                          color: Colors.green,
                          value: (progress[index]["nLearned"]! / (progress[index]["total"]! == 0 ? 1 : progress[index]["total"]!)),
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

  Future<void> loadInitialData() async {
    students = await CourseDataService().getStudentsList(widget.set.courseId);
    Map<UserModel, List<WordModel>> data = await ProgressDataService().getStudentProgress(students, widget.set);
    data.forEach((key, value) {
      int nLearned = 0;
      // int nNotLearned = 0;
      int total = 0;
      for(WordModel word in value) {
        if(word.memory == 1) {
          nLearned++;
        }
        // } else {
        //   nNotLearned++;
        // }
        total++;
      }
      print("Loading initial data");
      progress.add({
        "nLearned": nLearned,
        // "nNotLearned": nNotLearned,
        "total": total
      });
    });
    print("Students length: ${progress.length}");
    print("Data length: ${data.length}");
  }
}