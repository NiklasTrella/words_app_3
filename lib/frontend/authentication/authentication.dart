import 'package:flutter/material.dart';
import 'package:words_app_3/backend/system/auth.dart';
import 'package:words_app_3/frontend/authentication/forgot_password.dart';
import 'package:words_app_3/frontend/authentication/sign_up.dart';

// Přihlašování
class AuthScreen extends StatefulWidget {
  AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  bool _obscureText = true;

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
                labelText: 'Email',
                hintText: 'username@arcig.cz'
              ),
            ),
            // Heslo
            TextFormField(
              controller: passwordController,
              obscureText: _obscureText,
              decoration: const InputDecoration(
                labelText: 'Password',
                hintText: 'At least 6 characters'
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
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
                    const Text("Show password"),
                  ],
                ),
                TextButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(
                    builder: (context) => ForgotPasswordPage()
                  )),
                  child: const Text("Forgot password")
                )
              ],
            ),
            // Tlačítko na přihlášení
            ElevatedButton(
              child: const Text('Login'),
              onPressed: () {
                if (emailController.text.isNotEmpty && passwordController.text.length >= 6) {
                  // Former process
                  AuthService().logIn(emailController.text, passwordController.text);
                }
              },
            ),
            TextButton(
              child: const Text('Signup'),
              onPressed: () {
                if (emailController.text.isNotEmpty && passwordController.text.length >= 6) {
                  // Send user to the onboarding screen
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => SignUpScreen(emailController.text, passwordController.text)
                  ));
                  // AuthService().signUp(emailController.text, passwordController.text);
                }
              },
            )
          ],
        ),
      ),
    );
  }
}