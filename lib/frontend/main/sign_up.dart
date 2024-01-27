import 'package:flutter/material.dart';
import 'package:words_app_3/backend/auth.dart';
import 'package:words_app_3/backend/data/system_data.dart';
import 'package:words_app_3/backend/data/user_data.dart';

class SignUpScreen extends StatefulWidget {
  final String email;
  final String password;

  SignUpScreen(this.email, this.password, {super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool codeIsCorrect = false;

  TextEditingController firstName = TextEditingController();

  TextEditingController lastName = TextEditingController();

  TextEditingController teacherCode = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String hiddenPassword = "";
    for(int i = 0; i < widget.password.length; i++) {
      hiddenPassword += "*";
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign up"),
      ),
      body: Column(
        children: [
          ListTile(
            title: Text(widget.email),
            subtitle: const Text("Email"),
          ),
          ListTile(
            title: Text(hiddenPassword),
            subtitle: const Text("Password"),
          ),
          ListTile(
            title: TextFormField(
              controller: firstName,
              decoration: const InputDecoration(
                labelText: "First name"
              ),
            ),
          ),
          ListTile(
            title: TextFormField(
              controller: lastName,
              decoration: const InputDecoration(
                labelText: "Last name"
              ),
            ),
          ),
          OutlinedButton(
            onPressed: () async {
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
                              codeIsCorrect = await SystemDataService().checkTeacherCode(teacherCode.text);
                              if(codeIsCorrect) {
                                Navigator.pop(context);
                                print("Code is correct!");
                              } else {
                                print("Code is not correct!");
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
          FilledButton(
            onPressed: () async {
              AuthService().signUp(widget.email, widget.password).then((value) async {
                print("UserId: $value");
                await UserDataService().addUser(value, firstName.text, lastName.text, codeIsCorrect);
                print("User added to the database.");
                Navigator.pop(context);
              });
              // Sign the user up
            },
            child: const Text("Sign up")
          )
        ],
      ),
    );
  }
}