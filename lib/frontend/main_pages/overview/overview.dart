// Tento soubor obsahuje hlavní stránku, kde se zobrazí název a sety zvoleného kurzu

import 'package:flutter/material.dart';

import 'package:words_app_3/backend/data/main_database/course_data.dart';
import 'package:words_app_3/backend/data/users_database/user_data.dart';
import 'package:words_app_3/backend/system/models.dart';

import 'package:words_app_3/frontend/editors/set_editor.dart';
import 'package:words_app_3/frontend/main_pages/overview/sets_list.dart';

// První stránka - přehled zvoleného kurzu
class OverviewScreen extends StatefulWidget {
  final String? courseId;
  final bool isAuthor;
  const OverviewScreen(this.courseId, this.isAuthor, {super.key});

  @override
  State<OverviewScreen> createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {
  bool isTeacher = false;

  // Počáteční nastavení
  @override
  void initState() {
    UserDataService().isTeacher().then((value) {
      isTeacher = value;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: Column(
          children: [

            // Nadpis
            const Text(
              "Overview",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold
              ),
            ),
            const SizedBox(height: 10),
            const Divider(),
            const SizedBox(height: 10),

            // FutureBuilder čeká na data → zobrazení
            FutureBuilder<String>(
              future: CourseDataService().getCourseTitleFuture(widget.courseId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  
                  // Načítání
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  
                  // Chybová hláška v případě erroru
                  return Text('Error: ${snapshot.error}');
                } else {

                  // Zobrazení dat
                  return Text(snapshot.data ?? "No data.");
                }
              }
            ),

            // Seznam setů
            SetsList(widget.courseId, widget.isAuthor),
            
            // Tlačítko na přidání setu (zobrazí se pouze učiteli)
            widget.courseId != null ? Visibility(
              visible: isTeacher,
              child: ElevatedButton(
                onPressed: () async {
                  
                  // Odeslání uživatele na stránku pro vytvoření nového setu
                  await Navigator.push(context, MaterialPageRoute(
                    builder: (context) => SetEditorScreen(SetModel(widget.courseId, null, null), null),
                  ));
                  setState(() {});
                },
                child: const Text("Add set"),
              ),
            ) : Container(),
          ],
        ),
      )
    );
  }
}