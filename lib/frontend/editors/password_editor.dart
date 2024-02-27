// Na této stránce může uživatel změnit své heslo

import 'package:flutter/material.dart';

import 'package:words_app_3/backend/system/auth.dart';

// Stránka s editorem hesla
class PasswordEditor extends StatefulWidget {
  const PasswordEditor({super.key});

  @override
  State<PasswordEditor> createState() => _PasswordEditorState();
}

class _PasswordEditorState extends State<PasswordEditor> {
  TextEditingController firstPasswordController = TextEditingController(text: "");
  TextEditingController secondPasswordController = TextEditingController(text: "");

  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Password editor"),
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [

            // Textové pole
            TextField(
              obscureText: _obscureText,
              controller: firstPasswordController,
              decoration: const InputDecoration(
                label: Text("New password")
              ),
            ),

            // Zopakování hesla
            TextField(
              obscureText: _obscureText,
              controller: secondPasswordController,
              decoration: const InputDecoration(
                label: Text("Retype password")
              ),
            ),

            // Zaškrtávací políčko → zobrazení hesla
            Row(
              children: [
                Checkbox(
                  value: !_obscureText,
                  onChanged: (value) {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                ),
                const Text("Show password")
              ],
            ),
            const SizedBox(height: 8.0),

            // Tlačítko → uložení nového hesla
            OutlinedButton(
              onPressed: () {
                if(firstPasswordController.text == secondPasswordController.text) {
                  AuthService().updatePassword(firstPasswordController.text);
                  Navigator.pop(context);
                }
              },
              child: const Text("Save")
            )
          ],
        ),
      ),
    );
  }
}