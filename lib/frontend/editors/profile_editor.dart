// Na této stránce může uživatel změnit své osobní údaje

import 'package:flutter/material.dart';

import 'package:words_app_3/backend/data/users_database/user_data.dart';
import 'package:words_app_3/backend/system/models.dart';

// Editor profilu
class ProfileEditorScreen extends StatefulWidget {
  const ProfileEditorScreen({super.key});

  @override
  State<ProfileEditorScreen> createState() => _ProfileEditorScreenState();
}

class _ProfileEditorScreenState extends State<ProfileEditorScreen> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();

  @override
  void initState() {
    loadInitialData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile editor"),
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [

            // Textové pole - jméno
            TextField(
              controller: firstNameController,
              decoration: const InputDecoration(
                label: Text("First name")
              ),
            ),

            // Textové pole - příjmení
            TextField(
              controller: lastNameController,
              decoration: const InputDecoration(
                label: Text("Last name")
              ),
            ),
            const SizedBox(height: 8.0),

            // Potvrzení aktualizace jména
            OutlinedButton(
              onPressed: () {
                UserDataService().updateUserName(firstNameController.text, lastNameController.text);
                Navigator.pop(context);
              },
              child: const Text("Save")
            )
          ],
        ),
      ),
    );
  }

  Future<void> loadInitialData() async {
    UserModel userData = await UserDataService().getCurrentUserData();
    setState(() {
      firstNameController.text = userData.firstName ?? "";
      lastNameController.text = userData.lastName ?? "";
    });
  }
}