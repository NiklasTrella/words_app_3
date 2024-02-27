// V tomto souboru se generuje seznam kurzů

import 'package:flutter/material.dart';

import 'package:words_app_3/backend/data/main_database/course_data.dart';
import 'package:words_app_3/backend/system/models.dart';

import 'package:words_app_3/frontend/editors/course_editor.dart';

// Generátor seznamu kurzů
class CoursesList extends StatefulWidget {
  final Function updateCurrentCourseId;
  const CoursesList(this.updateCurrentCourseId, {super.key});

  @override
  State<CoursesList> createState() => _CoursesListState();
}

class _CoursesListState extends State<CoursesList> {
  List<CourseModel> ownCourses = [];
  List<CourseModel> studiedCourses = [];
  bool dataLoaded = false;
  _CoursesListState();

  @override
  void initState() {
    loadInitialData().then((value) => setState(() {
      dataLoaded = true;
    }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(dataLoaded == false) {
      return const Center(child: CircularProgressIndicator());
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10.0),
          Text(ownCourses.isNotEmpty ? "Own courses" : ""),
          
          // Seznam vlastních kurzů
          ListView.builder(
            shrinkWrap: true,
            itemCount: ownCourses.length,
            itemBuilder: (context, index) => CourseTile(ownCourses[index], widget.updateCurrentCourseId, parentSetState)
          ),
          (ownCourses.isNotEmpty && studiedCourses.isNotEmpty) ? const Divider() : const SizedBox(height: 0.0),
          const SizedBox(height: 10.0),
          Text(studiedCourses.isNotEmpty ? "Studied courses" : ""),
          
          // Seznam studovaných kurzů
          ListView.builder(
            shrinkWrap: true,
            itemCount: studiedCourses.length,
            itemBuilder: (context, index) => CourseTile(studiedCourses[index], widget.updateCurrentCourseId, parentSetState)
          )
        ],
      );
    }
  }

  // Funkce, která dětským Widgetům umožňuje znovu sestavit tento Widget
  void parentSetState() {
    setState(() {});
  }

  // Tato funkce načítá seznam vlastních a studovaných kurzů
  Future<void> loadInitialData() async {
    ownCourses = await CourseDataService().getOwnCourses();
    studiedCourses = await CourseDataService().getStudiedCourses();
  }
}

// Dlaždice jednoho kurzu
class CourseTile extends StatelessWidget {
  final CourseModel element;
  final Function updateCurrentCourseId;
  final Function parentSetState;
  const CourseTile(this.element, this.updateCurrentCourseId, this.parentSetState, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(element.title ?? "No title."),
      subtitle: FutureBuilder(

        // Počet setů
        future: CourseDataService().getSetsNumberFuture(element.courseId),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.done) {
            if(snapshot.hasError) {
              return const Text('Error loading data');
            } else if(snapshot.hasData) {
              if(snapshot.data != null) {
                return Text("Number of sets: ${snapshot.data}");
              }
            }
            else {
            return const CircularProgressIndicator();
            }
          }
          return const Text('Unknown condition.');
        }
      ),
      onTap: () {

        // Po klepnutí na kurz → aktualizace zvoleného kurzu
        updateCurrentCourseId(element.courseId, element.isAuthor);
        Navigator.of(context).pop();
      },

      // Tlačítko → editor kurzu
      trailing: Visibility(
        visible: element.isAuthor ?? false,
        child: IconButton(
          onPressed: () async {
            await Navigator.push(context, MaterialPageRoute(
              builder: (context) => CourseEditorScreen(element, parentSetState)
            ));
            parentSetState();
          },
          icon: const Icon(Icons.more_vert)
        ),
      ),
    );
  }
}