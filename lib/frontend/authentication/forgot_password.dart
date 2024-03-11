// Na této stránce probíhá resetování zapomenutého hesla

import 'package:flutter/material.dart';

import 'package:words_app_3/backend/system/auth.dart';

// Stránka pro obnovu hesla
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController _emailController = TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Forgot password"),
      ),
      body: Container(
        margin: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text("Enter your email so we can send you a link to reset your password."),

            // EMail
            TextField(
              controller: _emailController,
            ),
            const SizedBox(height: 8.0),

            // Tlačítko → potvrzení
            OutlinedButton(
              onPressed: () async {
                AuthService().resetPassword(_emailController.text).then(
                  (errorMessage) => showDialog(
                    context: context,
                    builder: (context) {
                      if(errorMessage == null) {
                        return const AlertDialog(
                          title: Text("Successful reset"),
                          content: Text("Check your email and follow the steps."),
                        );
                      } else {
                        return const AlertDialog(
                          title: Text("Invalid email"),
                          content: Text("Enter a valid email address."),
                        );
                      }
                    }
                  )
                );
              },
              child: const Text("Reset password")
            )
          ],
        ),
      ),
    );
  }
}