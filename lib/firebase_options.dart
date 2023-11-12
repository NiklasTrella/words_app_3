// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyA0CopSOxl8LQNCcnD-zeUEbJ4z-xuhbOw',
    appId: '1:920784971074:web:5d38fa8a7e150213cfd4db',
    messagingSenderId: '920784971074',
    projectId: 'words-app-3',
    authDomain: 'words-app-3.firebaseapp.com',
    storageBucket: 'words-app-3.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDJjo3cBDsY5CobX1c20_xQgqXMOHLwN0I',
    appId: '1:920784971074:android:9da017e55be3af89cfd4db',
    messagingSenderId: '920784971074',
    projectId: 'words-app-3',
    storageBucket: 'words-app-3.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBXzXn2m1huXIh2eS5mFLwosHxS-7CmCBw',
    appId: '1:920784971074:ios:97e2ea4e2beccbbdcfd4db',
    messagingSenderId: '920784971074',
    projectId: 'words-app-3',
    storageBucket: 'words-app-3.appspot.com',
    iosBundleId: 'com.example.wordsApp3',
  );
}
