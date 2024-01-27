import 'package:flutter/material.dart';
import 'package:words_app_3/backend/data/course_data.dart';
import 'package:words_app_3/backend/models.dart';
import 'package:words_app_3/frontend/editors/set_editor.dart';
import 'package:words_app_3/frontend/shared/sets_list.dart';

// První stránka - přehled zvoleného kurzu
class OverviewScreen extends StatefulWidget {
  final Function updateCurrentCourseId;
  final String? courseId;
  const OverviewScreen(this.updateCurrentCourseId, this.courseId, {super.key});

  @override
  State<OverviewScreen> createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {
  late Function updateCurrentCourseId;
  
  @override
  void initState() {
    updateCurrentCourseId = widget.updateCurrentCourseId;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: Column(
          children: [
            const Text(
              "Overview Screen",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold
              ),
            ),
            const SizedBox(height: 10),
            const Divider(),
            const SizedBox(height: 10),
            FutureBuilder<String>(
              future: CourseDataService().getCourseTitleFuture(widget.courseId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // Display a loading indicator while the future is in progress
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  // Display an error message if the future fails
                  return Text('Error: ${snapshot.error}');
                } else {
                  // Display the data when the future completes successfully
                  return Text(snapshot.data ?? "No data."); // .courseToMap()["title"].toString()
                }
              }
            ),
            // Text(widget.courseId != null ? await getCourseDetailsFuture().courseToMap()["title"].toString() : "Firstly choose a course."),
            // Zobrazení seznamu setů
            SetsList(widget.courseId),
            // Tlačítko na přidání setu
            widget.courseId != null ? ElevatedButton(
              onPressed: () async { // formerly async
                // Odeslání uživatele na stránku pro vytvoření nového setu
                await Navigator.push(context, MaterialPageRoute( // formerly await
                  builder: (context) => SetEditorScreen(SetModel(widget.courseId, null, null), null),
                ));
                setState(() {});
              },
              child: const Text("Add set"),
            ) : Container(),
          ],
        ),
      )
    );
  }
}