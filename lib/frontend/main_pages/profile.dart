// Na této stránce uživatel vidí svoje údaje. Některé z nich zdee může také upravit

import 'package:flutter/material.dart';

import 'package:words_app_3/backend/data/system_data.dart';
import 'package:words_app_3/backend/data/users_database/user_data.dart';
import 'package:words_app_3/backend/system/auth.dart';

import 'package:words_app_3/frontend/editors/password_editor.dart';
import 'package:words_app_3/frontend/editors/profile_editor.dart';

// Stránka profilu
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

              // Nadpis
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

              // FutureBuilder čeká na data z internetu, poté je zobrazí
              FutureBuilder(
                future: UserDataService().getCurrentUserData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    
                    // Zpbrazení načítání při čekání na data
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    
                    // Zobrazení chybové hlášky v případě erroru
                    return Text('Error: ${snapshot.error}');
                  } else {

                    // Jsou li data dostupná → zobrazení stránky
                    String accountType = "student";
                    if(snapshot.data?.isTeacher == true) {
                      accountType = "teacher";
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        // Email
                        Text("Email: ${snapshot.data?.email}"),
                        
                        // Jméno a příjmení
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

                            // Editor profilu
                            OutlinedButton.icon(
                              onPressed: () async {
                                await Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => const ProfileEditorScreen(),
                                ));
                                setState(() {});
                              },
                              icon: const Icon(Icons.edit),
                              label: const Text("Edit name"),
                            )
                          ],
                        ),

                        // Typ účtu
                        Text("Account type: $accountType"),
                        
                        // Tlačítko na získání práv učitele
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

                                              // Ověření kódu, který z uživatele udělá učitele
                                              codeIsCorrect = await SystemDataService().checkTeacherCode(teacherCode.text);
                                              if(codeIsCorrect) {
                                                UserDataService().becomeTeacher();
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
                        ),
                        const SizedBox(height: 8.0),

                        // Změna hesla
                        OutlinedButton.icon(
                          onPressed: () async {
                            await Navigator.push(context, MaterialPageRoute(
                              builder: (context) => const PasswordEditorScreen(),
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

          // Smazání účtu
          OutlinedButton.icon(
            onPressed: () {
            TextEditingController deleteCodeController = TextEditingController();
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Confirm deletion"),
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