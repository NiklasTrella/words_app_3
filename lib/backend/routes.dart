// Import ostatních stránek
import 'package:words_app_3/frontend/create/create_set.dart';
import 'package:words_app_3/frontend/main_screen.dart';
import 'package:words_app_3/frontend/create/create_course.dart';
import 'package:words_app_3/frontend/start.dart';

// Odkazy na "cesty"
var appRoutes = {
  '/': (context) => const StartScreen(),
  '/create_course': (context) => CreateCourseScreen(),
};