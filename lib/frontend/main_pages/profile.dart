import 'package:flutter/material.dart';
import 'package:words_app_3/backend/data/system_data.dart';
import 'package:words_app_3/backend/data/users_database/user_data.dart';
import 'package:words_app_3/backend/system/auth.dart';
import 'package:words_app_3/frontend/editors/password_editor.dart';
import 'package:words_app_3/frontend/editors/profile_editor.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController teacherCode = TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Profile Screen",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold
                ),
              ),
              const SizedBox(height: 10),
              const Divider(),
              const SizedBox(height: 10),
              FutureBuilder(
                future: UserDataService().getCurrentUserData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // If the Future is still running, display a loading indicator
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    // If an error occurred, display an error message
                    return Text('Error: ${snapshot.error}');
                  } else {
                    // If the Future is complete and data is available, use it
                    String accountType = "student";
                    if(snapshot.data?.isTeacher == true) {
                      accountType = "teacher";
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Email: ${snapshot.data?.email}"),
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("First name: ${snapshot.data?.firstName}"),
                                Text("Last name: ${snapshot.data?.lastName}"),
                              ],
                            ),
                            const SizedBox(width: 10.0),
                            OutlinedButton.icon(
                              onPressed: () async {
                                await Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => const ProfileEditor(),
                                ));
                                setState(() {});
                              },
                              icon: const Icon(Icons.edit),
                              label: const Text("Edit name"),
                            )
                          ],
                        ),
                        Text("Account type: $accountType"),
                        Visibility(
                          visible: !(snapshot.data?.isTeacher ?? false),
                          child: OutlinedButton(
                            onPressed: () async {
                              bool codeIsCorrect = false;
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
                                                UserDataService().becomeTeacher();
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
                        ),
                        const SizedBox(height: 8.0),
                        OutlinedButton.icon(
                          onPressed: () async {
                            await Navigator.push(context, MaterialPageRoute(
                              builder: (context) => const PasswordEditor(),
                            ));
                            setState(() {});
                          },
                          icon: const Icon(Icons.edit),
                          label: const Text("Change password"),
                        )
                      ],
                    );
                  }
                }
              ),
            ],
          ),
          OutlinedButton.icon(
            onPressed: () {
            TextEditingController deleteCodeController = TextEditingController();
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Confirm teacher identity"),
                  content: Column(
                    children: [
                      const Text("Enter the code you received from the network manager."),
                      TextField(
                        controller: deleteCodeController,
                      ),
                      const SizedBox(height: 8.0),
                      OutlinedButton(
                        onPressed: () async {
                          bool codeIsCorrect = await SystemDataService().checkDeleteCode(deleteCodeController.text);
                          if(codeIsCorrect) {
                            await AuthService().deleteUser();
                            Navigator.pop(context);
                          }
                        },
                        child: const Text("Check")
                      ),
                    ],
                  ),
                )
              );
            },
            icon: const Icon(Icons.delete),
            label: const Text(
              "Delete account",
              style: TextStyle(
                color: Colors.red
              ),
            )
          )
        ],
      ),
    );
  }
}