// Tento soubor provádí základní interní nastavení frameworku Flutter, připojuje aplikaci k databázi Firebase a, je-li vše v pořádku, spouští samotnou aplikaci. Nakonec uživatele pošle na stránku "StartScreen".

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:words_app_3/firebase_options.dart';

import 'package:words_app_3/backend/system/routes.dart';

// Hlavní funkce "main()", ve které program začíná
void main() {
  // Tato funkce spustí na začátku inicializaci frameworku Flutter a umožní Flutteru lépe spolupracovat s platformami, do kterých se "překládá" (Android, iOS...). Také zajistí, že se aplikace spustí až po dokončení jakéhokoliv asynchronního nastavení.
  WidgetsFlutterBinding.ensureInitialized();

  // Zde je spuštěna funkce "MyApp()", která reprezentuje celou aplikaci.
  runApp(const MyApp());
}



// Následující třída je základním "rodičovským" widgetem celé aplikace
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  // Inicializace Firebase
  final Future<FirebaseApp> _initialization = (Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform));

  // Následující funkce staví aplikaci
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(

      // Zdroj dat: Firebase, jejíř inicializace je uložená v proměnné "_initialization"
      future: _initialization,

      // Argument "builder" rozhoduje, co se bude dít s daty získanými po inicializaci
      builder: (context, snapshot) {

        // Kontrola Erroru. Nastane-li error, zobrazí se na displeji chybová hláška
        if(snapshot.hasError) {
          return Center(
            child: Text('Error.${snapshot.error}', textDirection: TextDirection.ltr),
          );
        }

        // Je-li připojení úspěšné, aplikace se spustí
        else if(snapshot.connectionState == ConnectionState.done) {

          // Vrácení aplikace
          return MaterialApp(

            // Vyputí červeného proužku v pravém horním rohu s nápisem "Debug mode"
            debugShowCheckedModeBanner: false,

            // Odkaz na "cesty" - routes. Routes představují v aplikaci základní navigaci
            routes: appRoutes,
          );
        }

        // Probíhá-li načítání, zobrazí se uprostřed displeje nápis "Main loading."
        else {
          return const Center(
            child: Column(
              children: [
                CircularProgressIndicator(),
                Text('Main loading.', textDirection: TextDirection.ltr),
              ],
            )
          );
        }
      },
    );
  }
}