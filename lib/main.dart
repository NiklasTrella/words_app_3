// Import knihoven
// material.dart = základní knihovna pro Flutter
import 'package:flutter/material.dart';

// Základní knihovna pro Firebase
import 'package:firebase_core/firebase_core.dart';

// Navigace
import 'package:words_app_3/backend/routes.dart';
import 'package:words_app_3/firebase_options.dart';

// Hlavní funkce "main()", ve které program začíná
void main() {
  // Nevím, co následující funkce přesně dělá, ale bez ní někdy dochází
  // k problémům s Firebase.
  WidgetsFlutterBinding.ensureInitialized();

  // Zde je spuštěna funkce "MyApp()", což je má aplikace
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Inicializace Firebase
  final Future<FirebaseApp> _initialization = (Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)) as Future<FirebaseApp>;

  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Firebase inicializace jako argument
      future: _initialization,

      // Argument "builder" rozhoduje, co se bude dít dál po inicializaci
      // Firebase
      builder: (context, snapshot) {
        // Zkontrolovat error
        if(snapshot.hasError) {
          return Center(
            child: Text('Error.' + snapshot.error.toString(), textDirection: TextDirection.ltr),
          );
        }

        // Je-li připojení úspěšné
        else if(snapshot.connectionState == ConnectionState.done) {
          print('Connection successful!');
          // Vrácení aplikace
          return MaterialApp(

            // Vyputí červeného proužku v pravém horním rohu s nápisem "Debug
            // mode".
            debugShowCheckedModeBanner: false,

            // Odkaz na "cesty" - routes: navigace v aplikaci
            routes: appRoutes,
          );
        }

        // Probíhá-li načítání
        else {
          return const Center(
            child: Text(
              'Main Loading.',
              textDirection: TextDirection.ltr,
              )
            );
        }
      },
    );
  }
}