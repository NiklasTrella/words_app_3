import 'package:flutter/material.dart';
import 'package:words_app_3/backend/auth.dart';

// Přihlašování
class AuthScreen extends StatelessWidget {
  AuthScreen({super.key});

  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Authentication'),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Email
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(
                hintText: 'Email'
              ),
            ),
            // Heslo
            TextFormField(
              controller: passwordController,
              decoration: const InputDecoration(
                hintText: 'Password'
              ),
            ),
            // Tlačítko na přihlášení
            ElevatedButton(
              child: const Text('Login'),
              onPressed: () {
                if (emailController.text.isNotEmpty && passwordController.text.length > 6) {
                  AuthService().logIn(emailController.text, passwordController.text);
                  print("Login button pressed!");
                  print("EmailController: " + emailController.text);
                  print("PasswordController: " + passwordController.text);
                }
              },
            ),
            TextButton(
              child: const Text('Signup'),
              onPressed: () {
                if (emailController.text.isNotEmpty && passwordController.text.length > 6) {
                  AuthService().signUp(emailController.text, passwordController.text);
                  print("Signup button pressed!");
                  print("EmailController: " + emailController.text);
                  print("PasswordController: " + passwordController.text);
                }
              },
            )
          ],
        ),
      ),
    );
  }
}