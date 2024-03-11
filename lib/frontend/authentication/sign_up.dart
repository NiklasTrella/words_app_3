// Na této stránce probíhá vytvoření nového účtu

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:words_app_3/backend/system/auth.dart';
import 'package:words_app_3/backend/data/system_data.dart';
import 'package:words_app_3/backend/data/users_database/user_data.dart';

// Stránka vytvoření účtu
class SignUpScreen extends StatefulWidget {
  SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool codeIsCorrect = false;

  // Ovladače textových polí
  TextEditingController email = TextEditingController();
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController teacherCode = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign up"),
      ),
      body: Column(
        children: [

          // Email
          ListTile(
            title: TextFormField(
              controller: email,
              decoration: const InputDecoration(
                labelText: "Email"
              ),
            ),
          ),

          // Jméno
          ListTile(
            title: TextFormField(
              controller: firstName,
              decoration: const InputDecoration(
                labelText: "First name"
              ),
            ),
          ),

          // Příjmení
          ListTile(
            title: TextFormField(
              controller: lastName,
              decoration: const InputDecoration(
                labelText: "Last name"
              ),
            ),
          ),

          // Získání učitelského účtu - tlačítko
          OutlinedButton(
            onPressed: () async {

              // Zadání učitelského kódu
              await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("Confirm teacher identity"),
                    content: Column(
                      children: [
                        const Text("Enter the code you received from the network manager."),
                        TextField(
                          controller: teacherCode,
                        ),
                        const SizedBox(height: 8.0),
                        OutlinedButton(
                          onPressed: () async {
                            if(!codeIsCorrect) {

                              // Ověření učitelského kódu
                              codeIsCorrect = await SystemDataService().checkTeacherCode(teacherCode.text);
                              if(codeIsCorrect) {
                                Navigator.pop(context);
                              }
                            }
                          },
                          child: const Text("Check")
                        ),
                      ],
                    ),
                  );
                }
              );
              setState(() {});
            },
            child: const Text("Are you a teacher?"),
          ),
          Visibility(
            visible: codeIsCorrect,
            child: const Column(
              children: [
                Text("Successful teacher confirmation"),
                SizedBox(height: 8.0)
              ],
            ),
          ),
          const SizedBox(height: 8.0),
          const Padding(
            padding: EdgeInsets.all(20),
            child: Text("After clicking on Sign Up, please check your email in order to set your password.")),
          const SizedBox(height: 8.0),

          // Potvrzení založení účtu → vygenerování náhodného hesla
          FilledButton(
            onPressed: () async {
              const String chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#%^&*()-_=+';
              String randomPassword = List.generate(12, (index) {
                  return chars[Random().nextInt(chars.length)];
                }
              ).join();

              // Úprava emailu
              email.text.trim().toLowerCase();

              // Kontrola existence uživatele
              bool userAlreadyExists = await UserDataService().checkUserExistence(email.text);

              // Kontrola domény
              bool allowedDomain = false;
              List<String> emailParts = email.text.split("@");
              if(emailParts.length == 2) {
                allowedDomain = await SystemDataService().checkDomain(emailParts[1]);
                print("Domain check.");
              }

              if(!userAlreadyExists && allowedDomain) {
                // Registrace uživatele
                await AuthService().signUp(email.text, randomPassword).then((value) async {
                  await UserDataService().addUser(value, firstName.text, lastName.text, codeIsCorrect, email.text);
                  Navigator.pop(context);
                });
              }
            },
            child: const Text("Sign up")
          )
        ],
      ),
    );
  }
}