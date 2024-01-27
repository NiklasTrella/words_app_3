import 'package:flutter/material.dart';
import 'package:words_app_3/backend/data/user_data.dart';

class ForgotPasswordPage extends StatefulWidget {
  ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  TextEditingController _emailController = TextEditingController(text: "");

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

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
            TextField(
              controller: _emailController,
            ),
            const SizedBox(height: 8.0),
            OutlinedButton(
              onPressed: () async {
                UserDataService().resetPassword(_emailController.text).then(
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