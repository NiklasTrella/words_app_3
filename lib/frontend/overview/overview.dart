import 'package:flutter/material.dart';
import 'package:words_app_3/frontend/create/create_set.dart';

class OverviewScreen extends StatefulWidget {
  String? courseId;
  OverviewScreen(this.courseId, {super.key}) {if(courseId != null) {
      print("Data in OverviewScreen: " + courseId!);
    }
  }

  @override
  State<OverviewScreen> createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {
  _OverviewScreenState();  

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: Column(
          children: [
            const Text('Welcome to the OverviewScreen!'),
            SizedBox(height: 10),
            Divider(),
            SizedBox(height: 10),
            Text(widget.courseId ?? "Firstly choose a course."),
            // Zobrazení seznamu setů
            widget.courseId != null ? SetsList() : Container(),
            // Tlačítko na přidání setu
            widget.courseId != null ? ElevatedButton(
              onPressed: () {
                // Odeslání uživatele na stránku pro vytvoření nového setu
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => CreateSetScreen(widget.courseId),
                ));
              },
              child: Text("Add set"),
            ) : Container()
          ],
        ),
      )
    );
  }
}

class SetsList extends StatefulWidget {
  const SetsList({super.key});

  @override
  State<SetsList> createState() => _SetsListState();
}

class _SetsListState extends State<SetsList> {
  @override
  Widget build(BuildContext context) {
    return const Text('List of sets');
  }
}