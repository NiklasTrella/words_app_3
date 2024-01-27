import 'package:flutter/material.dart';
import 'package:words_app_3/backend/data/user_data.dart';
import 'package:words_app_3/backend/models.dart';

class ProfileEditor extends StatefulWidget {
  const ProfileEditor({super.key});

  @override
  State<ProfileEditor> createState() => _ProfileEditorState();
}

class _ProfileEditorState extends State<ProfileEditor> {
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
            TextField(
              controller: firstNameController,
              decoration: const InputDecoration(
                label: Text("First name")
              ),
            ),
            TextField(
              controller: lastNameController,
              decoration: const InputDecoration(
                label: Text("Last name")
              ),
            ),
            const SizedBox(height: 8.0),
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
    UserModel userData = await UserDataService().getUserData();
    setState(() {
      firstNameController.text = userData.firstName ?? "";
      lastNameController.text = userData.lastName ?? "";
    });
  }
}