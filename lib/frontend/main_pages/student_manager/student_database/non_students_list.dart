// Seznam uživatelů, kteří nejsou studenty kurzu

import 'package:flutter/material.dart';

import 'package:words_app_3/backend/data/main_database/course_data.dart';
import 'package:words_app_3/backend/data/users_database/progress_data.dart';
import 'package:words_app_3/backend/data/users_database/student_data.dart';
import 'package:words_app_3/backend/system/models.dart';

// Seznam studentů, kteří nejsou studenty kurzu
class NonStudentsList extends StatefulWidget {
  final String? courseId;
  const NonStudentsList(this.courseId, {super.key});

  @override
  State<NonStudentsList> createState() => _NonStudentsListState();
}

class _NonStudentsListState extends State<NonStudentsList> {
  _NonStudentsListState();

  // Seznam ne-studentů
  List<UserModel> nonStudents = [];

  // Ovládání zaškrtávacího políčka
  List<bool> checkboxControllers = [];

  // Načtení počátečních dat
  @override
  void initState() {
    loadInitialData().then((value) => setState(() {}));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [

        // Seznam studentů
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: nonStudents.length,
          itemBuilder: (context, index) {

            // Karta s údaji jednoho studenta
            return Card(
              child: ListTile(

                // Jméno
                title: Text("${nonStudents[index].firstName} ${nonStudents[index].lastName}"),
                subtitle: Row(
                  children: [

                    // Zaškrtávací políčko
                    Checkbox(
                      value: checkboxControllers[index],
                      onChanged: (value) => setState(() {
                        checkboxControllers[index] = !checkboxControllers[index];
                      })
                    ),
                    const SizedBox(width: 8.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        // Email
                        Text("Email: ${nonStudents[index].email}"),
                        
                        // Id
                        Text("Id: ${nonStudents[index].userId}"),

                        // Údaj, je-li uživatel učitelem
                        Visibility(
                          visible: nonStudents[index].isTeacher ?? false,
                          child: const Text("Teacher")
                        )
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
        ),

        // Potvrzení přidání označených studentů
        OutlinedButton(
          onPressed: () async {
            List<UserModel> nonStudentsToAdd = [];
            for(int i = 0; i < nonStudents.length; i++) {
              if(checkboxControllers[i] == true) {
                nonStudentsToAdd.add(nonStudents[i]);
              }
            }

            // Přidání studentů do kurzu v databázi
            await CourseDataService().addStudents(widget.courseId, nonStudentsToAdd);
            
            // Založení postupu v databázi
            await ProgressDataService().addStudentsProgress(widget.courseId, nonStudentsToAdd);

            // Návrat na původní stránku
            Navigator.pop(context);
          },
          child: const Text("Add selected")
        )
      ],
    );
  }

  // Funkce, která načítá počáteční data
  Future<void> loadInitialData() async {

    // Získání seznamu ne-studentů z databáze
    nonStudents = await StudentDataService().getAllNonStudents(widget.courseId);
    for(int i = 0; i<nonStudents.length; i++) {
      checkboxControllers.add(false);
    }
  }
}